#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include "assembly.h"
#include "addr_regs.h"
#include "command.h"

// #define MIPS_COMMENT  // 需要注释时取消注释
#ifdef MIPS_COMMENT
#define mips_fprintf_comment(fp, fmt, ...) fprintf(fp, fmt, __VA_ARGS__)
#else
#define mips_fprintf_comment(fp, fmt, ...) fprintf(fp, "\n")
#endif

#define MAX_LINES 2048  // 最大中间代码行数
#define MAX_LINE_LENGTH 256  // 每行最大长度

extern InterSymbolTable interSymbolTable;  // 中间代码符号表
extern AddressDescriptor* lookup_symbol(const char *var_name);  // 声明 lookup_symbol 函数

char* strdup(const char* s);

extern int mips_reg_list[];
extern int mips_reg_list_len;

int frame_size = 0;

// 存储中间代码的结构
typedef struct {
    char lines[MAX_LINES][MAX_LINE_LENGTH];
    int count;
} IntermediateCode;

// 全局变量
static IntermediateCode ic;  // 存储所有中间代码

// 读取所有中间代码到数组
static void read_all_intermediate_code(FILE* input, IntermediateCode* ic) {
    ic->count = 0;
    InterCodeNode* current = get_inter_code_list();
    
    while (current != NULL && ic->count < MAX_LINES - 1) {
        strncpy(ic->lines[ic->count], current->line, MAX_LINE_LENGTH - 1);
        ic->lines[ic->count][MAX_LINE_LENGTH - 1] = '\0';
        ic->count++;
        current = current->next;
    }
}

// 处理函数参数
static int handle_function_params(const char* func_name, int start_line, FILE* output) {
    int param_count = 0;
    char param_name[64];
    int i = start_line;
    
    // 计算参数数量并处理每个参数
    while (i < ic.count && strncmp(ic.lines[i], "PARAM", 5) == 0) {
        sscanf(ic.lines[i], "PARAM %s", param_name);
        // 将参数作为普通变量插入符号表
        int reg = Allocate(param_name, output);
        fprintf(output, "lw %s, %d($fp)\n", regName[reg], 4 * param_count);

        AddressDescriptor* addr_desc = ensure_symbol(param_name, output);
        fprintf(output, "sw %s, %d($fp)", regName[reg], - addr_desc->stack_offset);

        mips_fprintf_comment(output, "# PARAM %s: 读取第%d个参数\n", param_name, param_count + 1);
        param_count++;
        i++;
    }
    
    return i;  // 返回处理完参数后的行号
}

// 处理函数调用参数
static int handle_function_args(const char* func_name, int start_line, FILE* output) {
    int arg_count = 0;
    char arg_name[64];
    int i = start_line;
    
    // 先统计参数数量
    while (i >= 0 && strncmp(ic.lines[i], "ARG", 3) == 0) {
        arg_count++;
        i--;
    }
    
    // 从上往下处理参数（从最后一个ARG开始）
    i = start_line - arg_count + 1;
    while (i <= start_line) {
        sscanf(ic.lines[i], "ARG %s", arg_name);
        int reg = get_operand_reg(arg_name, output);
        fprintf(output, "subu $sp, $sp, 4\n");
        fprintf(output, "sw %s, 0($sp)", regName[reg]);
        mips_fprintf_comment(output, "# ARG %s: 压栈参数\n", arg_name);
        i++;
    }
    
    return arg_count * 4;  // 返回参数占用的栈空间大小
}

// MIPS寄存器名称数组定义
char* regName[MIPS_REGS_NUM] = {
    "$zero",
    "$at",
    "$v0", "$v1",
    "$a0", "$a1", "$a2", "$a3",
    "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", // 8 ~ 15
    "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7", // 16 ~ 23
    "$t8", "$t9", // 24 ~ 25
    "$k0", "$k1",
    "$gp",
    "$sp",
    "$fp",
    "$ra"
};

// 处理二元运算
static void handle_binary_op(const char* x, const char* y, const char* z, const char* op, FILE* output) {
    // 获取操作数的寄存器
    int ry = get_operand_reg(y, output);
    int rz = get_operand_reg(z, output);
    
    // 分配目标寄存器
    int rx = get_operand_reg(x, output);
    
    // 根据操作符生成相应的指令
    if (strcmp(op, "+") == 0) {
        fprintf(output, "add %s, %s, %s", regName[rx], regName[ry], regName[rz]);
        mips_fprintf_comment(output, "# in handle_binary_op: %s := %s + %s\n", x, y, z);
    } else if (strcmp(op, "-") == 0) {
        fprintf(output, "sub %s, %s, %s", regName[rx], regName[ry], regName[rz]);
        mips_fprintf_comment(output, "# in handle_binary_op: %s := %s - %s\n", x, y, z);
    } else if (strcmp(op, "*") == 0) {
        fprintf(output, "mul %s, %s, %s", regName[rx], regName[ry], regName[rz]);
        mips_fprintf_comment(output, "# in handle_binary_op: %s := %s * %s\n", x, y, z);
    } else if (strcmp(op, "/") == 0) {
        fprintf(output, "div %s, %s\n", regName[ry], regName[rz]);
        fprintf(output, "mflo %s", regName[rx]);
        mips_fprintf_comment(output, "# in handle_binary_op: %s := %s / %s (get quotient)\n", x, y, z);
    }
    
    // 将结果写回内存 释放寄存器
    spill_variable(x, output);
    if (y[0] != '#') {
        spill_variable(y, output);
    } else {
        reg_desc[ry].is_used = 0;
        reg_desc[ry].var_name = NULL;
    }
    if (z[0] != '#') {
        spill_variable(z, output);
    } else {
        reg_desc[rz].is_used = 0;
        reg_desc[rz].var_name = NULL;
    }
}

// 处理赋值操作
void process_expression(char *expr, FILE *output) {
    char x[256], y[256], z[256], op[128];
    
    // 处理二元运算 x := y op z
    if (sscanf(expr, "%s := %s %s %s", x, y, op, z) == 4) {
        handle_binary_op(x, y, z, op, output);
        return;
    }
        
    // *x = y (存储到指针指向的位置)
    if (sscanf(expr, "*%s := %s", x, y) == 2) {
        int rx = get_operand_reg(x, output);  // 获取指针变量的地址
        int ry = get_operand_reg(y, output);  // 获取要存储的值
        fprintf(output, "sw %s, 4(%s)", regName[ry], regName[rx]);
        mips_fprintf_comment(output, "# in process_expression: *%s = %s\n", x, y);

        spill_variable(x, output);
        return;
    }
    
    // x := *y (从指针指向的位置加载)
    if (sscanf(expr, "%s := *%s", x, y) == 2) {
        int ry = get_operand_reg(y, output);  // 获取指针变量的地址
        int rx = get_operand_reg(x, output);  // 获取目标寄存器
        fprintf(output, "lw %s, 4(%s)", regName[rx], regName[ry]);
        mips_fprintf_comment(output, "# in process_expression: %s := *%s\n", x, y);

        spill_variable(x, output);
        return;
    }
    
    // 处理基本赋值操作 x := #k
    if (sscanf(expr, "%s := #%s", x, y) == 2) {
        int rx = get_operand_reg(x, output);
        fprintf(output, "li %s, %s", regName[rx], y);
        mips_fprintf_comment(output, "# in process_expression: %s := #%s\n", x, y);

        spill_variable(x, output);
        return;
    }
    
    // 处理赋值 x := y 以及 x := &y
    if (sscanf(expr, "%s := %s", x, y) == 2) {
        int rx = get_operand_reg(x, output);
        int ry = get_operand_reg(y, output);
        fprintf(output, "move %s, %s", regName[rx], regName[ry]);
        mips_fprintf_comment(output, "# in process_expression: %s := %s\n", x, y);

        spill_variable(x, output);
        return;
    }
}

// 添加数据段和代码段声明
static void add_assembly_header(FILE *output) {
    fprintf(output, ".data\n");
    fprintf(output, "_prompt: .asciiz \"Enter an integer:\"\n");
    fprintf(output, "_ret: .asciiz \"\\n\"\n\n");
    fprintf(output, ".text\n");
    fprintf(output, ".globl main\n\n");
    fprintf(output, "read:\n");
    fprintf(output, "li $v0, 4\n");
    fprintf(output, "la $a0, _prompt\n");
    fprintf(output, "syscall\n");
    fprintf(output, "li $v0, 5\n");
    fprintf(output, "syscall\n");
    fprintf(output, "jr $ra\n\n");
    fprintf(output, "write:\n");
    fprintf(output, "li $v0, 1\n");
    fprintf(output, "syscall\n");
    fprintf(output, "li $v0, 4\n");
    fprintf(output, "la $a0, _ret\n");
    fprintf(output, "syscall\n");
    fprintf(output, "move $v0, $0\n");
    fprintf(output, "jr $ra\n\n");
}

void translate_to_mips(FILE *input, FILE *output) {
    char current_function[64] = "";
    
    // 读取所有中间代码
    read_all_intermediate_code(input, &ic);
    
    add_assembly_header(output);
    init_registers();  // 初始化寄存器
    
    // 处理所有指令
    for (int i = 0; i < ic.count; i++) {
        char line[MAX_LINE_LENGTH];
        strcpy(line, ic.lines[i]);
        
        // DEC 数组声明
        if (strncmp(line, "DEC", 3) == 0) {
            char var_name[64];
            int size;
            if (sscanf(line, "DEC %s %d", var_name, &size) == 2) {
                declare_array(var_name, size, output);
                continue;
            }
        }

        // FUNCTION
        if (strstr(line, "FUNCTION") == line) {
            char func_name[64];
            sscanf(line, "FUNCTION %s :", func_name);
            strcpy(current_function, func_name);
            
            // 清空所有寄存器状态
            free_all_regs();
            
            // 计算固定保存区域大小（$ra, $fp, 寄存器等）
            int fixed_size = 8 + 4 * mips_reg_list_len;  // $ra, $fp, 寄存器保存区域
            frame_size = fixed_size;  // 总栈帧大小
            // 重置栈偏移量
            interSymbolTable.stack_offset = frame_size;
            
            fprintf(output, "%s:\n", func_name);
            
            // 被调用者序言
            fprintf(output, "subu $sp, $sp, %d", frame_size);
            mips_fprintf_comment(output, "# FUNCTION %s: 分配栈帧\n", func_name);
            fprintf(output, "sw $fp, %d($sp)", frame_size - 4);
            mips_fprintf_comment(output, "# FUNCTION %s: 保存旧帧指针\n", func_name);
            fprintf(output, "sw $ra, %d($sp)", frame_size - 8);
            mips_fprintf_comment(output, "# FUNCTION %s: 保存返回地址\n", func_name);
            fprintf(output, "addiu $fp, $sp, %d", frame_size);
            mips_fprintf_comment(output, "# FUNCTION %s: 设置新的帧指针\n", func_name);
            
            // 保存所有寄存器
            if (strcmp(current_function, "main") != 0) {
                for (int j = 0; j < mips_reg_list_len; j++) {
                    int reg = mips_reg_list[j];
                    fprintf(output, "sw %s, %d($fp)", regName[reg], -12 - 4 * j);
                    mips_fprintf_comment(output, "# FUNCTION %s: 保存寄存器 %s\n", func_name, regName[reg]);
                }
            }
            
            // 处理函数参数
            i = handle_function_params(func_name, i + 1, output) - 1;
            continue;
        }
        
        // CALL
        if (strstr(line, ":= CALL") != NULL) {
            char result[64], callee[64];
            sscanf(line, "%s := CALL %s", result, callee);
            
            // 处理函数调用参数（从当前行开始向前查找）
            int arg_size = handle_function_args(callee, i - 1, output);
            
            fprintf(output, "jal %s", callee);
            mips_fprintf_comment(output, "# CALL %s: 调用函数\n", callee);
            
            // 恢复栈指针
            if (arg_size > 0) {
                fprintf(output, "addi $sp, $sp, %d", arg_size);
                mips_fprintf_comment(output, "# CALL %s: 恢复栈指针\n", callee);
            }
            
            int reg = get_operand_reg(result, output);
            fprintf(output, "move %s, $v0", regName[reg]);
            mips_fprintf_comment(output, "# CALL %s: 保存返回值\n", callee);
            continue;
        }
        
        // RETURN
        if (strstr(line, "RETURN") == line) {
            char var[64];
            sscanf(line, "RETURN %s", var);
            
            // 返回值处理 恢复之后数值会被覆盖
            int rv = get_operand_reg(var, output);
            fprintf(output, "move $v0, %s", regName[rv]);
            mips_fprintf_comment(output, "# RETURN %s: 设置返回值\n", var);

            if (strcmp(current_function, "main") != 0) {
                // 恢复所有寄存器
                for (int j = mips_reg_list_len - 1; j >= 0; j--) {
                    int reg = mips_reg_list[j];
                    fprintf(output, "lw %s, %d($fp)", regName[reg], -12 - 4 * j);
                    mips_fprintf_comment(output, "# RETURN %s: 恢复寄存器%s\n", var, regName[reg]);
                }
            }
            
            // 恢复$fp和$ra
            fprintf(output, "lw $ra, %d($fp)", -8);
            mips_fprintf_comment(output, "# RETURN %s: 恢复返回地址\n", var);
            fprintf(output, "lw $fp, %d($fp)", -4);
            mips_fprintf_comment(output, "# RETURN %s: 恢复帧指针\n", var);
            
            // 释放栈空间
            fprintf(output, "addi $sp, $sp, %d\n", frame_size); 
            fprintf(output, "jr $ra\n\n");
            
            continue;
        }
        
        // LABEL
        if (strstr(line, "LABEL") == line) {
            char label[64];
            sscanf(line, "LABEL %[^:]:", label);
            fprintf(output, "%s:\n", label);
            continue;
        }
        
        // IF x == y GOTO z
        if (strstr(line, "IF") == line) {
            char x[64], y[64], label[64];
            if (sscanf(line, "IF %s == %s GOTO %s", x, y, label) == 3) {
                int rx = get_operand_reg(x, output), ry = get_operand_reg(y, output);
                fprintf(output, "beq %s, %s, %s\n", regName[rx], regName[ry], label);
                continue;
            }
            if (sscanf(line, "IF %s != %s GOTO %s", x, y, label) == 3) {
                int rx = get_operand_reg(x, output), ry = get_operand_reg(y, output);
                fprintf(output, "bne %s, %s, %s\n", regName[rx], regName[ry], label);
                continue;
            }
            if (sscanf(line, "IF %s > %s GOTO %s", x, y, label) == 3) {
                int rx = get_operand_reg(x, output), ry = get_operand_reg(y, output);
                fprintf(output, "bgt %s, %s, %s\n", regName[rx], regName[ry], label);
                continue;
            }
            if (sscanf(line, "IF %s < %s GOTO %s", x, y, label) == 3) {
                int rx = get_operand_reg(x, output), ry = get_operand_reg(y, output);
                fprintf(output, "blt %s, %s, %s\n", regName[rx], regName[ry], label);
                continue;
            }
            if (sscanf(line, "IF %s >= %s GOTO %s", x, y, label) == 3) {
                int rx = get_operand_reg(x, output), ry = get_operand_reg(y, output);
                fprintf(output, "bge %s, %s, %s\n", regName[rx], regName[ry], label);
                continue;
            }
            if (sscanf(line, "IF %s <= %s GOTO %s", x, y, label) == 3) {
                int rx = get_operand_reg(x, output), ry = get_operand_reg(y, output);
                fprintf(output, "ble %s, %s, %s\n", regName[rx], regName[ry], label);
                continue;
            }
        }

        // GOTO
        if (strstr(line, "GOTO") == line) {
            char label[64];
            sscanf(line, "GOTO %s", label);
            fprintf(output, "j %s", label);
            mips_fprintf_comment(output, "# GOTO %s\n", label);
            continue;
        }
        
        // READ语句处理
        if (strstr(line, "READ") == line) {
            char var[64];
            sscanf(line, "READ %s", var);
            
            // 保存返回地址
            fprintf(output, "addi $sp, $sp, -4");
            mips_fprintf_comment(output, "# READ %s: 保存返回地址\n", var);
            fprintf(output, "sw $ra, 0($sp)\n");
            
            // 调用read函数
            fprintf(output, "jal read");
            mips_fprintf_comment(output, "# READ %s: 调用read函数\n", var);
            
            // 恢复返回地址
            fprintf(output, "lw $ra, 0($sp)\n");
            fprintf(output, "addi $sp, $sp, 4");
            mips_fprintf_comment(output, "# READ %s: 恢复返回地址\n", var);
            
            // 将返回值存储到目标变量
            int reg = Allocate(var, output);
            fprintf(output, "move %s, $v0", regName[reg]);
            mips_fprintf_comment(output, "# READ %s: 将返回值存储到%s\n", var, var);
            continue;
        }
        
        // WRITE语句处理
        if (strstr(line, "WRITE") == line) {
            char var[64];
            sscanf(line, "WRITE %s", var);
            
            // 获取要输出的变量的值
            int reg = get_operand_reg(var, output);
            
            // 将值移动到$a0
            fprintf(output, "move $a0, %s", regName[reg]);
            mips_fprintf_comment(output, "# WRITE %s: 将值移动到$a0\n", var);
            
            // 保存返回地址
            fprintf(output, "subu $sp, $sp, 4");
            mips_fprintf_comment(output, "# WRITE %s: 保存返回地址\n", var);
            fprintf(output, "sw $ra, 0($sp)\n");
            
            // 调用write函数
            fprintf(output, "jal write");
            mips_fprintf_comment(output, "# WRITE %s: 调用write函数\n", var);
            
            // 恢复返回地址
            fprintf(output, "lw $ra, 0($sp)\n");
            fprintf(output, "addi $sp, $sp, 4");
            mips_fprintf_comment(output, "# WRITE %s: 恢复返回地址\n", var);
            continue;
        }
        
        // 其他表达式
        process_expression(line, output);
    }
}
