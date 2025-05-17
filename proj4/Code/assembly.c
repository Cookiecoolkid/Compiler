#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include "assembly.h"
#include "addr_regs.h"

#define MIPS_COMMENT  // 需要注释时取消注释
#ifdef MIPS_COMMENT
#define mips_fprintf_comment(fp, fmt, ...) fprintf(fp, fmt, __VA_ARGS__)
#else
#define mips_fprintf_comment(fp, fmt, ...) fprintf(fp, "\n")
#endif

extern InterSymbolTable interSymbolTable;  // 中间代码符号表

char* strdup(const char* s);

extern int mips_reg_list[];
extern int mips_reg_list_len;

int frame_size = 0;

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
    
    // 将结果写回内存
    spill_variable(x, output);
}

// 处理赋值操作
void process_expression(char *expr, FILE *output) {
    char x[256], y[256], z[256], op[128];
    
    // 处理二元运算 x := y op z
    if (sscanf(expr, "%s := %s %s %s", x, y, op, z) == 4) {
        handle_binary_op(x, y, z, op, output);
        return;
    }
    
    // 处理基本赋值操作 x := #k
    if (sscanf(expr, "%s := #%s", x, y) == 2) {
        int rx = get_operand_reg(y, output);
        fprintf(output, "li %s, %s\n", regName[rx], y);
        return;
    }
    
    // 处理赋值 x := y
    if (sscanf(expr, "%s := %s", x, y) == 2 && y[0] != '#' && !strchr(y, '+') && !strchr(y, '-') && !strchr(y, '*') && !strchr(y, '/')) {
        int rx = get_operand_reg(x, output);
        int ry = get_operand_reg(y, output);
        fprintf(output, "move %s, %s\n", regName[rx], regName[ry]);
        return;
    }
    
    // x := y + #k
    if (sscanf(expr, "%s := %s + #%s", x, y, z) == 3) {
        int rx = get_operand_reg(x, output);
        int ry = get_operand_reg(y, output);
        fprintf(output, "addi %s, %s, %s\n", regName[rx], regName[ry], z);
        return;
    }
    
    // x := y + z
    if (sscanf(expr, "%s := %s + %s", x, y, z) == 3 && z[0] != '#') {
        int rx, ry, rz;
        assign_regs(x, y, z, &rx, &ry, &rz, output);
        fprintf(output, "add %s, %s, %s\n", regName[rx], regName[ry], regName[rz]);
        return;
    }
    
    // x := y - #k
    if (sscanf(expr, "%s := %s - #%s", x, y, z) == 3) {
        int rx = get_operand_reg(x, output);
        int ry = get_operand_reg(y, output);
        fprintf(output, "addi %s, %s, -%s\n", regName[rx], regName[ry], z);
        return;
    }
    
    // x := y - z
    if (sscanf(expr, "%s := %s - %s", x, y, z) == 3 && z[0] != '#') {
        int rx, ry, rz;
        assign_regs(x, y, z, &rx, &ry, &rz, output);
        fprintf(output, "sub %s, %s, %s\n", regName[rx], regName[ry], regName[rz]);
        return;
    }
    
    // x := y * z
    if (sscanf(expr, "%s := %s * %s", x, y, z) == 3) {
        int rx, ry, rz;
        assign_regs(x, y, z, &rx, &ry, &rz, output);
        fprintf(output, "mul %s, %s, %s\n", regName[rx], regName[ry], regName[rz]);
        return;
    }
    
    // x := y / z
    if (sscanf(expr, "%s := %s / %s", x, y, z) == 3) {
        int rx, ry, rz;
        assign_regs(x, y, z, &rx, &ry, &rz, output);
        fprintf(output, "div %s, %s\n", regName[ry], regName[rz]);
        fprintf(output, "mflo %s\n", regName[rx]);
        return;
    }
    
    // x := *y
    if (sscanf(expr, "%s := *%s", x, y) == 2) {
        int rx = get_operand_reg(x, output);
        int ry = get_operand_reg(y, output);
        fprintf(output, "lw %s, 0(%s)\n", regName[rx], regName[ry]);
        return;
    }
    
    // *x = y
    if (sscanf(expr, "*%s = %s", x, y) == 2) {
        int rx = get_operand_reg(x, output);
        int ry = get_operand_reg(y, output);
        fprintf(output, "sw %s, 0(%s)\n", regName[ry], regName[rx]);
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
    char line[256];
    char current_function[64] = "";

    int param_count = 0;
    
    add_assembly_header(output);
    init_registers();  // 初始化寄存器
    
    while (fgets(line, sizeof(line), input)) {
        line[strcspn(line, "\n")] = 0;
        if (strlen(line) == 0) continue;

        // FUNCTION
        if (strstr(line, "FUNCTION") == line) {
            char func_name[64];
            sscanf(line, "FUNCTION %s :", func_name);
            strcpy(current_function, func_name);
            
            frame_size = 8 + 4 * mips_reg_list_len;

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
                for (int i = 0; i < mips_reg_list_len; i++) {
                    int reg = mips_reg_list[i];
 
                    fprintf(output, "sw %s, %d($fp)", regName[reg], -12 - 4 * i);
                    mips_fprintf_comment(output, "# FUNCTION %s: 保存寄存器 %s\n", func_name, regName[reg]);
                    
                }
            }
            
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
                for (int i = mips_reg_list_len - 1; i >= 0; i--) {
                    int reg = mips_reg_list[i];

                    fprintf(output, "lw %s, %d($fp)", regName[reg], -12 - 4 * i);
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
            // mips_fprintf_comment(output, "# RETURN %s: 释放栈空间\n", var);
            fprintf(output, "jr $ra\n\n");
            // mips_fprintf_comment(output, "# RETURN %s: 返回\n\n", var);
            
            continue;
        }
        
        // CALL
        if (strstr(line, ":= CALL") != NULL) {
            char result[64], callee[64];
            sscanf(line, "%s := CALL %s", result, callee);

            fprintf(output, "jal %s", callee);
            mips_fprintf_comment(output, "# CALL %s: 调用函数\n", callee);
            param_count = 0;

            int reg = get_operand_reg(result, output);
            fprintf(output, "move %s, $v0", regName[reg]);
            mips_fprintf_comment(output, "# CALL %s: 保存返回值\n", callee);
            continue;
        }        
        
        // PARAM
        if (strncmp(line, "PARAM", 5) == 0) {
            char param[64];
            sscanf(line, "PARAM %s", param);
            
            static int param_index = 0;
            int reg = Allocate(param);
            fprintf(output, "lw %s, %d($fp)", regName[reg], 4 * (param_count - param_index));
            mips_fprintf_comment(output, "# PARAM %s: 读取第%d个参数\n", param, param_index + 1);
            param_index++;
            continue;
        }
        
        // ARG
        if (strncmp(line, "ARG", 3) == 0) {
            char arg[64];
            sscanf(line, "ARG %s", arg);
            int reg = get_operand_reg(arg, output);
            fprintf(output, "subu $sp, $sp, 4");
            mips_fprintf_comment(output, "# ARG %s: 压栈参数\n", arg);
            fprintf(output, "sw %s, 0($sp)\n", regName[reg]);
            param_count++;
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
            char x[64], y[64], op[4], label[64];
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
            int reg = Allocate(var);
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
