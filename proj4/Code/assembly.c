#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include "assembly.h"

InterSymbolTable interSymbolTable;

char* strdup(const char* s);

int mips_reg_list[] = {8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23}; // $t0-$t9, $s0-$s7
int mips_reg_list_len = 16;
unsigned long reg_timestamp_counter = 0;

RegisterDescriptor reg_desc[32]; // 32个寄存器
// 变量名到寄存器的映射（可用哈希表或链表实现，简单起见用线性查找）

// 全局变量，用于跟踪当前函数的参数位置
static int param_offset = 0;

void init_registers() {
    for (int i = 0; i < 32; ++i) {
        reg_desc[i].reg_index = i;
        reg_desc[i].var_name = NULL;
        reg_desc[i].is_used = 0;
        reg_desc[i].timestamp = 0;
    }
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

// 插入符号到中间代码符号表
void insert_symbol(const char *var_name) {
    // 检查符号是否已存在
    if (lookup_symbol(var_name) != NULL) {
        return;
    }
    
    // 创建新的地址描述符
    AddressDescriptor *addr_desc = malloc(sizeof(AddressDescriptor));
    addr_desc->var_name = strdup(var_name);
    addr_desc->reg_index = -1;
    addr_desc->stack_offset = interSymbolTable.stack_offset;
    
    // 更新栈偏移量
    interSymbolTable.stack_offset += 4;  // 假设每个变量占用4字节
    
    // 创建新的中间代码符号表节点
    InterSymbol *node = malloc(sizeof(InterSymbol));
    node->addr_desc = addr_desc;
    node->next = interSymbolTable.head;
    interSymbolTable.head = node;
}

// 查找符号
AddressDescriptor* lookup_symbol(const char *var_name) {
    InterSymbol *current = interSymbolTable.head;
    while (current != NULL) {
        if (strcmp(current->addr_desc->var_name, var_name) == 0) {
            return current->addr_desc;
        }
        current = current->next;
    }
    return NULL;
}

// 辅助函数：从行中提取操作数
static void extract_operands(char *line, char *op1, char *op2, char *op3) {
    char *token = strtok(line, " ");
    int count = 0;
    while (token != NULL) {
        if (count == 0) strcpy(op1, token);
        else if (count == 1) strcpy(op2, token);
        else if (count == 2) strcpy(op3, token);
        token = strtok(NULL, " ");
        count++;
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

// 处理赋值操作
void handle_assignment(const char* dest, int src_reg, FILE* output) {
    AddressDescriptor* addr_desc = ensure_symbol(dest);
    
    // 检查变量是否已经在寄存器中
    if (addr_desc->reg_index != -1) {
        // 如果变量已经在寄存器中，更新其值
        if (addr_desc->reg_index != src_reg) {
            fprintf(output, "move %s, %s\n", regName[addr_desc->reg_index], regName[src_reg]);
        }
        // 更新寄存器的使用时间戳
        reg_desc[addr_desc->reg_index].timestamp = ++reg_timestamp_counter;
        return;
    }
    
    // 变量不在寄存器中(调用前应确保在寄存器中)
    assert(0);
}

// 获取变量的寄存器，如果不在寄存器中则从栈中加载
int get_var_reg(const char* var, FILE* output) {
    AddressDescriptor* addr_desc = ensure_symbol(var);
    
    // 检查变量是否已经在寄存器中
    if (addr_desc->reg_index != -1) {
        reg_desc[addr_desc->reg_index].timestamp = ++reg_timestamp_counter;
        return addr_desc->reg_index;
    }
    
    // 变量不在寄存器中，需要从栈中加载
    int reg = Allocate();
    fprintf(output, "lw %s, %d($fp)\n", regName[reg], addr_desc->stack_offset);
    
    // 更新寄存器的变量信息
    if (reg_desc[reg].var_name) {
        // 更新原变量的地址描述符
        AddressDescriptor* old_addr_desc = lookup_symbol(reg_desc[reg].var_name);
        if (old_addr_desc) {
            old_addr_desc->reg_index = -1;
        }
        free(reg_desc[reg].var_name);
    }
    
    reg_desc[reg].var_name = strdup(var);
    reg_desc[reg].is_used = 1;
    reg_desc[reg].timestamp = ++reg_timestamp_counter;
    
    // 更新变量的地址描述符
    addr_desc->reg_index = reg;
    
    return reg;
}

static int is_immediate(const char* str) {
    return str[0] == '#';
}

// 获取立即数的值
static int get_immediate_value(const char* str) {
    return atoi(str + 1);
}

// 获取操作数的寄存器
static int get_operand_reg(const char* operand, FILE* output) {
    if (is_immediate(operand)) {
        int reg = Allocate();
        fprintf(output, "li %s, %s\n", regName[reg], operand + 1);
        return reg;
    } else {
        return get_var_reg(operand, output);
    }
}

// 更新寄存器的变量信息
static void update_reg_var_info(int reg, const char* var) {
    if (reg_desc[reg].var_name) {
        // 更新原变量的地址描述符
        AddressDescriptor* old_addr_desc = lookup_symbol(reg_desc[reg].var_name);
        if (old_addr_desc) {
            old_addr_desc->reg_index = -1;
        }
        free(reg_desc[reg].var_name);
    }
    
    reg_desc[reg].var_name = strdup(var);
    reg_desc[reg].is_used = 1;
    reg_desc[reg].timestamp = ++reg_timestamp_counter;
    
    // 更新变量的地址描述符
    AddressDescriptor* addr_desc = ensure_symbol(var);
    addr_desc->reg_index = reg;
}

// 释放立即数使用的临时寄存器
static void free_immediate_regs(int reg1, int reg2, const char* op1, const char* op2) {
    if (is_immediate(op1)) {
        reg_desc[reg1].is_used = 0;
        if (reg_desc[reg1].var_name) {
            free(reg_desc[reg1].var_name);
            reg_desc[reg1].var_name = NULL;
        }
    }
    if (is_immediate(op2)) {
        reg_desc[reg2].is_used = 0;
        if (reg_desc[reg2].var_name) {
            free(reg_desc[reg2].var_name);
            reg_desc[reg2].var_name = NULL;
        }
    }
}

// 处理二元运算
static void handle_binary_op(const char* x, const char* y, const char* z, const char* op, FILE* output) {
    // 获取操作数的寄存器
    int ry = get_operand_reg(y, output);
    int rz = get_operand_reg(z, output);
    
    // 分配目标寄存器并更新变量信息
    int rx = Allocate();
    update_reg_var_info(rx, x);
    
    // 根据操作符生成相应的指令
    if (strcmp(op, "+") == 0) {
        fprintf(output, "add %s, %s, %s\n", regName[rx], regName[ry], regName[rz]);
    } else if (strcmp(op, "-") == 0) {
        fprintf(output, "sub %s, %s, %s\n", regName[rx], regName[ry], regName[rz]);
    } else if (strcmp(op, "*") == 0) {
        fprintf(output, "mul %s, %s, %s\n", regName[rx], regName[ry], regName[rz]);
    } else if (strcmp(op, "/") == 0) {
        fprintf(output, "div %s, %s\n", regName[ry], regName[rz]);
        fprintf(output, "mflo %s\n", regName[rx]);
    }
    
    // 释放立即数使用的临时寄存器
    free_immediate_regs(ry, rz, y, z);
    
    // 只在必要时写回栈中
    handle_assignment(x, rx, output);
}

// 处理赋值操作
void process_expression(char *expr, FILE *output) {
    char x[64], y[64], z[64], op[8];
    
    // 处理二元运算 x := y op z
    if (sscanf(expr, "%s := %s %s %s", x, y, op, z) == 4) {
        handle_binary_op(x, y, z, op, output);
        return;
    }
    
    // 处理基本赋值操作 x := #k
    if (sscanf(expr, "%s := #%s", x, y) == 2) {
        int rx = Allocate();
        update_reg_var_info(rx, x);
        fprintf(output, "li %s, %s\n", regName[rx], y);
        handle_assignment(x, rx, output);
        return;
    }
    
    // 处理指针操作 x := *y
    if (sscanf(expr, "%s := *%s", x, y) == 2) {
        int ry = get_var_reg(y, output);
        int rx = Allocate();
        update_reg_var_info(rx, x);
        fprintf(output, "lw %s, 0(%s)\n", regName[rx], regName[ry]);
        handle_assignment(x, rx, output);
        return;
    }
    
    // 处理指针操作 *x = y
    if (sscanf(expr, "*%s = %s", x, y) == 2) {
        int rx = get_var_reg(x, output);
        int ry = get_var_reg(y, output);
        fprintf(output, "sw %s, 0(%s)\n", regName[ry], regName[rx]);
        return;
    }
    
    // 处理基本赋值操作 x := y
    if (sscanf(expr, "%s := %s", x, y) == 2) {
        int ry = get_var_reg(y, output);
        int rx = Ensure(x, output);
        handle_assignment(x, ry, output);
        return;
    }
}

void translate_to_mips(FILE *input, FILE *output) {
    char line[256];
    char current_function[64] = "";
    int frame_size = 0;
    int saved_regs_count = 0;
    int saved_regs[8]; // 最多保存8个s寄存器
    int arg_count = 0; // 当前函数调用的参数计数
    
    add_assembly_header(output);
    
    while (fgets(line, sizeof(line), input)) {
        line[strcspn(line, "\n")] = 0;
        if (strlen(line) == 0) continue;

        // FUNCTION
        if (strstr(line, "FUNCTION") == line) {
            char func_name[64];
            sscanf(line, "FUNCTION %s :", func_name);
            strcpy(current_function, func_name);
            
            // 重置参数偏移量
            param_offset = 0;
            
            // 计算栈帧大小：参数空间 + 保存的寄存器空间 + $ra和$fp
            frame_size = interSymbolTable.stack_offset + 8 + 4 * 8; // 8个s寄存器
            
            fprintf(output, "%s:\n", func_name);
            
            // 被调用者序言
            fprintf(output, "subu $sp, $sp, %d\n", frame_size);  // 分配栈空间
            fprintf(output, "sw $ra, %d($sp)\n", frame_size - 4);  // 保存返回地址
            fprintf(output, "sw $fp, %d($sp)\n", frame_size - 8);  // 保存帧指针
            fprintf(output, "addi $fp, $sp, %d\n", frame_size);  // 设置新的帧指针
            
            // 保存所有被调用者保存的寄存器（s0-s7）
            for (int i = 16; i < 24; i++) {  // s0-s7的寄存器编号是16-23
                fprintf(output, "sw %s, %d($sp)\n", regName[i], frame_size - 12 - (i-16)*4);
            }
            
            continue;
        }
        
        // PARAM
        if (strstr(line, "PARAM") == line) {
            char param[64];
            sscanf(line, "PARAM %s", param);
            
            // 从栈中读取参数
            int reg = Allocate();
            fprintf(output, "lw %s, %d($fp)\n", regName[reg], param_offset);
            param_offset += 4; // 每个参数占4字节
        
            continue;
        }
        
        // ARG
        if (strstr(line, "ARG") == line) {
            char arg[64];
            sscanf(line, "ARG %s", arg);
            
            // 将参数压入栈中
            int reg = get_var_reg(arg, output);
            fprintf(output, "sw %s, %d($sp)\n", regName[reg], arg_count * 4);
            arg_count++;
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
                int rx = Ensure(x, output), ry = Ensure(y, output);
                fprintf(output, "beq %s, %s, %s\n", regName[rx], regName[ry], label);
                continue;
            }
            if (sscanf(line, "IF %s != %s GOTO %s", x, y, label) == 3) {
                int rx = Ensure(x, output), ry = Ensure(y, output);
                fprintf(output, "bne %s, %s, %s\n", regName[rx], regName[ry], label);
                continue;
            }
            if (sscanf(line, "IF %s > %s GOTO %s", x, y, label) == 3) {
                int rx = Ensure(x, output), ry = Ensure(y, output);
                fprintf(output, "bgt %s, %s, %s\n", regName[rx], regName[ry], label);
                continue;
            }
            if (sscanf(line, "IF %s < %s GOTO %s", x, y, label) == 3) {
                int rx = Ensure(x, output), ry = Ensure(y, output);
                fprintf(output, "blt %s, %s, %s\n", regName[rx], regName[ry], label);
                continue;
            }
            if (sscanf(line, "IF %s >= %s GOTO %s", x, y, label) == 3) {
                int rx = Ensure(x, output), ry = Ensure(y, output);
                fprintf(output, "bge %s, %s, %s\n", regName[rx], regName[ry], label);
                continue;
            }
            if (sscanf(line, "IF %s <= %s GOTO %s", x, y, label) == 3) {
                int rx = Ensure(x, output), ry = Ensure(y, output);
                fprintf(output, "ble %s, %s, %s\n", regName[rx], regName[ry], label);
                continue;
            }
        }

        // GOTO
        if (strstr(line, "GOTO") == line) {
            char label[64];
            sscanf(line, "GOTO %s", label);
            fprintf(output, "j %s\n", label);
            continue;
        }
        
        // RETURN
        if (strstr(line, "RETURN") == line) {
            char var[64];
            sscanf(line, "RETURN %s", var);
            
            // 恢复所有被调用者保存的寄存器（s0-s7）
            for (int i = 23; i >= 16; i--) {  // s0-s7的寄存器编号是16-23
                fprintf(output, "lw %s, %d($sp)\n", regName[i], frame_size - 12 - (i-16)*4);
            }
            
            // 恢复$fp和$ra
            fprintf(output, "lw $ra, %d($sp)\n", frame_size - 4);
            fprintf(output, "lw $fp, %d($sp)\n", frame_size - 8);
            
            // 返回值处理
            int rv = Ensure(var, output);
            fprintf(output, "move $v0, %s\n", regName[rv]);
            
            // 释放栈空间
            fprintf(output, "addi $sp, $sp, %d\n", frame_size);
            fprintf(output, "jr $ra\n\n");
            
            // 重置参数计数
            arg_count = 0;
            continue;
        }
        
        // CALL
        if (strstr(line, ":= CALL") != NULL) {
            char x[64], f[64];
            sscanf(line, "%s := CALL %s", x, f);
            
            // 保存所有调用者保存的寄存器（t0-t9）
            for (int i = 8; i <= 17; i++) {  // t0-t9的寄存器编号是8-17
                if (reg_desc[i].is_used && reg_desc[i].var_name) {
                    AddressDescriptor* addr_desc = lookup_symbol(reg_desc[i].var_name);
                    if (addr_desc) {
                        fprintf(output, "sw %s, %d($sp)\n", regName[i], addr_desc->stack_offset);
                    }
                }
            }
            
            // 函数调用
            fprintf(output, "jal %s\n", f);
            
            // 恢复所有调用者保存的寄存器（t0-t9）
            for (int i = 8; i <= 17; i++) {  // t0-t9的寄存器编号是8-17
                if (reg_desc[i].is_used && reg_desc[i].var_name) {
                    AddressDescriptor* addr_desc = lookup_symbol(reg_desc[i].var_name);
                    if (addr_desc) {
                        fprintf(output, "lw %s, %d($sp)\n", regName[i], addr_desc->stack_offset);
                    }
                }
            }
            
            // 保存返回值
            int rx = Ensure(x, output);
            fprintf(output, "move %s, $v0\n", regName[rx]);
            
            // 重置参数计数
            arg_count = 0;
            continue;
        }
        
        // READ语句处理
        if (strstr(line, "READ") == line) {
            char var[64];
            sscanf(line, "READ %s", var);
            
            // 保存返回地址
            fprintf(output, "addi $sp, $sp, -4\n");
            fprintf(output, "sw $ra, 0($sp)\n");
            
            // 调用read函数
            fprintf(output, "jal read\n");
            
            // 恢复返回地址
            fprintf(output, "lw $ra, 0($sp)\n");
            fprintf(output, "addi $sp, $sp, 4\n");
            
            // 将返回值存储到目标变量
            int reg = Allocate();
            update_reg_var_info(reg, var);
            fprintf(output, "move %s, $v0\n", regName[reg]);
            handle_assignment(var, reg, output);
            continue;
        }
        
        // WRITE语句处理
        if (strstr(line, "WRITE") == line) {
            char var[64];
            sscanf(line, "WRITE %s", var);
            
            // 获取要输出的变量的值
            int reg = get_var_reg(var, output);
            
            // 将值移动到$a0
            fprintf(output, "move $a0, %s\n", regName[reg]);
            
            // 保存返回地址
            fprintf(output, "subu $sp, $sp, 4\n");
            fprintf(output, "sw $ra, 0($sp)\n");
            
            // 调用write函数
            fprintf(output, "jal write\n");
            
            // 恢复返回地址
            fprintf(output, "lw $ra, 0($sp)\n");
            fprintf(output, "addi $sp, $sp, 4\n");
            continue;
        }
        
        // 其他表达式
        process_expression(line, output);
    }
}

int Allocate() {
    // 1. 先找空闲寄存器
    int min_time = 0x7fffffff, min_idx = -1;
    for (int i = 0; i < mips_reg_list_len; ++i) {
        int reg = mips_reg_list[i];
        if (!reg_desc[reg].is_used) {
            reg_desc[reg].is_used = 1;
            reg_desc[reg].timestamp = ++reg_timestamp_counter;
            return reg;
        }
    }
    // 2. 没有空闲，找最久未用的
    for (int i = 0; i < mips_reg_list_len; ++i) {
        int reg = mips_reg_list[i];
        if (reg_desc[reg].timestamp < min_time) {
            min_time = reg_desc[reg].timestamp;
            min_idx = reg;
        }
    }
    // 这里可以加溢出写回逻辑（如有必要）
    reg_desc[min_idx].timestamp = ++reg_timestamp_counter;
    return min_idx;
}

int Ensure(const char *var, FILE *output) {
    AddressDescriptor* addr_desc = ensure_symbol(var);
    // 查找变量是否已在寄存器
    for (int i = 0; i < mips_reg_list_len; ++i) {
        int reg = mips_reg_list[i];
        if (reg_desc[reg].is_used && reg_desc[reg].var_name && strcmp(reg_desc[reg].var_name, var) == 0) {
            reg_desc[reg].timestamp = ++reg_timestamp_counter;
            return reg;
        }
    }
    // 不在，分配新寄存器
    int reg = Allocate();
    if (reg_desc[reg].var_name) free(reg_desc[reg].var_name);
    reg_desc[reg].var_name = strdup(var);
    reg_desc[reg].is_used = 1;
    reg_desc[reg].timestamp = reg_timestamp_counter;

    // 更新 变量的地址描述符
    addr_desc->reg_index = reg;
    
    // 输出lw指令，使用$fp作为基址
    fprintf(output, "lw %s, %d($fp)\n", regName[reg], addr_desc->stack_offset);
    return reg;
}

void assign_regs(const char *result, const char *op1, const char *op2, int *r_result, int *r_op1, int *r_op2, FILE *output) {
    *r_op1 = Ensure(op1, output);
    *r_op2 = Ensure(op2, output);
    *r_result = Allocate();
    if (reg_desc[*r_result].var_name) free(reg_desc[*r_result].var_name);
    reg_desc[*r_result].var_name = strdup(result);
    reg_desc[*r_result].is_used = 1;
    reg_desc[*r_result].timestamp = ++reg_timestamp_counter;
}

// 确保变量在符号表中，并返回其地址描述符
AddressDescriptor* ensure_symbol(const char* var) {
    AddressDescriptor* addr_desc = lookup_symbol(var);
    if (!addr_desc) {
        insert_symbol(var);
        addr_desc = lookup_symbol(var);
    }
    return addr_desc;
}
