#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "assembly.h"

InterSymbolTable interSymbolTable;

char* strdup(const char* s);

int mips_reg_list[] = {8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23}; // $t0-$t9, $s0-$s7
int mips_reg_list_len = 16;
unsigned long reg_timestamp_counter = 0;

RegisterDescriptor reg_desc[32]; // 32个寄存器
// 变量名到寄存器的映射（可用哈希表或链表实现，简单起见用线性查找）

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
    "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7",
    "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7",
    "$t8", "$t9",
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

// 递归处理表达式
void process_expression(char *expr, FILE *output) {
    char x[64], y[64], z[64], op[8];
    // 1. x := y + #k
    if (sscanf(expr, "%s := %s + #%s", x, y, z) == 3) {
        int rx = Ensure(x, output);
        int ry = Ensure(y, output);
        fprintf(output, "addi %s, %s, %s\n", regName[rx], regName[ry], z);
        AddressDescriptor* addr_desc = ensure_symbol(x);
        fprintf(output, "sw %s, %d($sp)\n", regName[rx], addr_desc->stack_offset);
        return;
    }
    // 2. x := y + z
    if (sscanf(expr, "%s := %s + %s", x, y, z) == 3 && z[0] != '#') {
        int rx, ry, rz;
        assign_regs(x, y, z, &rx, &ry, &rz, output);
        fprintf(output, "add %s, %s, %s\n", regName[rx], regName[ry], regName[rz]);
        AddressDescriptor* addr_desc = ensure_symbol(x);
        fprintf(output, "sw %s, %d($sp)\n", regName[rx], addr_desc->stack_offset);
        return;
    }
    // 3. x := y - #k
    if (sscanf(expr, "%s := %s - #%s", x, y, z) == 3) {
        int rx = Ensure(x, output);
        int ry = Ensure(y, output);
        fprintf(output, "addi %s, %s, -%s\n", regName[rx], regName[ry], z);
        AddressDescriptor* addr_desc = ensure_symbol(x);
        fprintf(output, "sw %s, %d($sp)\n", regName[rx], addr_desc->stack_offset);
        return;
    }
    // 4. x := y - z
    if (sscanf(expr, "%s := %s - %s", x, y, z) == 3 && z[0] != '#') {
        int rx, ry, rz;
        assign_regs(x, y, z, &rx, &ry, &rz, output);
        fprintf(output, "sub %s, %s, %s\n", regName[rx], regName[ry], regName[rz]);
        AddressDescriptor* addr_desc = ensure_symbol(x);
        fprintf(output, "sw %s, %d($sp)\n", regName[rx], addr_desc->stack_offset);
        return;
    }
    // 5. x := y * z
    if (sscanf(expr, "%s := %s * %s", x, y, z) == 3) {
        int rx, ry, rz;
        assign_regs(x, y, z, &rx, &ry, &rz, output);
        fprintf(output, "mul %s, %s, %s\n", regName[rx], regName[ry], regName[rz]);
        AddressDescriptor* addr_desc = ensure_symbol(x);
        fprintf(output, "sw %s, %d($sp)\n", regName[rx], addr_desc->stack_offset);
        return;
    }
    // 6. x := y / z
    if (sscanf(expr, "%s := %s / %s", x, y, z) == 3) {
        int rx, ry, rz;
        assign_regs(x, y, z, &rx, &ry, &rz, output);
        fprintf(output, "div %s, %s\n", regName[ry], regName[rz]);
        fprintf(output, "mflo %s\n", regName[rx]);
        AddressDescriptor* addr_desc = ensure_symbol(x);
        fprintf(output, "sw %s, %d($sp)\n", regName[rx], addr_desc->stack_offset);
        return;
    }
    // 7. x := #k
    if (sscanf(expr, "%s := #%s", x, y) == 2) {
        int rx = Ensure(x, output);
        fprintf(output, "li %s, %s\n", regName[rx], y);
        AddressDescriptor* addr_desc = ensure_symbol(x);
        fprintf(output, "sw %s, %d($sp)\n", regName[rx], addr_desc->stack_offset);
        return;
    }
    // 8. x := y
    if (sscanf(expr, "%s := %s", x, y) == 2 && y[0] != '#' && !strchr(y, '+') && !strchr(y, '-') && !strchr(y, '*') && !strchr(y, '/')) {
        int rx = Ensure(x, output);
        int ry = Ensure(y, output);
        fprintf(output, "move %s, %s\n", regName[rx], regName[ry]);
        AddressDescriptor* addr_desc = ensure_symbol(x);
        fprintf(output, "sw %s, %d($sp)\n", regName[rx], addr_desc->stack_offset);
        return;
    }
    // 9. x := *y
    if (sscanf(expr, "%s := *%s", x, y) == 2) {
        int rx = Ensure(x, output);
        int ry = Ensure(y, output);
        fprintf(output, "lw %s, 0(%s)\n", regName[rx], regName[ry]);
        AddressDescriptor* addr_desc = ensure_symbol(x);
        fprintf(output, "sw %s, %d($sp)\n", regName[rx], addr_desc->stack_offset);
        return;
    }
    // 10. *x = y
    if (sscanf(expr, "*%s = %s", x, y) == 2) {
        int rx = Ensure(x, output);
        int ry = Ensure(y, output);
        fprintf(output, "sw %s, 0(%s)\n", regName[ry], regName[rx]);
        return;
    }
}

void translate_to_mips(FILE *input, FILE *output) {
    char line[256];
    char current_function[64] = "";
    
    add_assembly_header(output);
    
    while (fgets(line, sizeof(line), input)) {
        line[strcspn(line, "\n")] = 0;
        if (strlen(line) == 0) continue;

        // FUNCTION
        if (strstr(line, "FUNCTION") == line) {
            char func_name[64];
            sscanf(line, "FUNCTION %s :", func_name);
            strcpy(current_function, func_name);
            fprintf(output, "%s:\n", func_name);
            // 统计变量总数
            int total_var_size = interSymbolTable.stack_offset;
            fprintf(output, "addiu $sp, $sp, -%d\n", total_var_size);
            continue;
        }
        // LABEL
        if (strstr(line, "LABEL") == line) {
            char label[64];
            sscanf(line, "LABEL %[^:]:", label);
            fprintf(output, "%s:\n", label);
            continue;
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
            int rv = Ensure(var, output);
            fprintf(output, "move $v0, %s\n", regName[rv]);
            fprintf(output, "jr $ra\n\n");
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
        // x := CALL f
        if (strstr(line, ":= CALL") != NULL) {
            char x[64], f[64];
            sscanf(line, "%s := CALL %s", x, f);
            fprintf(output, "jal %s\n", f);
            int rx = Ensure(x, output);
            fprintf(output, "move %s, $v0\n", regName[rx]);
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
    // 输出lw指令
    fprintf(output, "lw %s, %d($sp)\n", regName[reg], addr_desc->stack_offset);
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
