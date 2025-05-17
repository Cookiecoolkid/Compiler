#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include "addr_regs.h"

char* strdup(const char* s);

// 全局变量定义
InterSymbolTable interSymbolTable = {NULL, 0};  // 初始化 interSymbolTable
RegisterDescriptor reg_desc[32]; // 32个寄存器
int mips_reg_list[] = {8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25}; // $t0-$t9, $s0-$s7
int mips_reg_list_len = 18;

unsigned long reg_timestamp_counter = 0;

// 将变量溢出到内存
void spill_variable(const char* var, FILE* output) {
    int reg = get_operand_reg(var, output);
    AddressDescriptor* addr_desc = ensure_symbol(var);
    fprintf(output, "sw %s, %d($fp)\n", regName[reg], -80 -addr_desc->stack_offset);

    addr_desc->is_in_memory = 1;
    addr_desc->reg_index = -1;
    reg_desc[reg].is_used = 0;
    reg_desc[reg].var_name = NULL;
}

// 获取真实的变量名（去除 * 和 & 前缀）
static const char* get_real_var_name(const char* var_name) {
    if (var_name == NULL) return NULL;
    
    // 跳过前缀的 * 和 &
    while (*var_name == '*' || *var_name == '&') {
        var_name++;
    }
    
    return var_name;
}

// 查找符号
static AddressDescriptor* lookup_symbol(const char *var_name) {
    if (var_name == NULL) return NULL;
    
    InterSymbol *current = interSymbolTable.head;
    while (current != NULL) {
        // 确保所有指针都不为NULL
        if (current->addr_desc == NULL || current->addr_desc->var_name == NULL) {
            current = current->next;
            continue;
        }
        
        if (strcmp(current->addr_desc->var_name, var_name) == 0) {
            return current->addr_desc;
        }
        current = current->next;
    }
    return NULL;
}

// 插入符号到中间代码符号表
static void insert_symbol(const char *var_name) {
    if (var_name == NULL) return;
    
    // 检查符号是否已存在
    if (lookup_symbol(var_name) != NULL) return;
    
    // 创建新的地址描述符
    AddressDescriptor *addr_desc = malloc(sizeof(AddressDescriptor));
    if (addr_desc == NULL) return;  // 内存分配失败
    
    addr_desc->var_name = strdup(var_name);
    
    addr_desc->reg_index = -1;
    addr_desc->stack_offset = interSymbolTable.stack_offset;
    addr_desc->is_in_memory = 0;  // 新变量初始时不在内存中
    
    // 更新栈偏移量
    interSymbolTable.stack_offset += 4;  // 假设每个变量占用4字节
    
    // 创建新的中间代码符号表节点
    InterSymbol *node = malloc(sizeof(InterSymbol));
    
    node->addr_desc = addr_desc;
    node->next = interSymbolTable.head;
    interSymbolTable.head = node;
}

// 确保变量在符号表中，并返回其地址描述符
AddressDescriptor* ensure_symbol(const char* var) {
    if (var == NULL) return NULL;
    
    AddressDescriptor* addr_desc = lookup_symbol(var);
    if (!addr_desc) {
        insert_symbol(var);
        addr_desc = lookup_symbol(var);
    }
    return addr_desc;
}

void init_registers() {
    for (int i = 0; i < 32; ++i) {
        reg_desc[i].reg_index = i;
        reg_desc[i].var_name = NULL;
        reg_desc[i].is_used = 0;
        reg_desc[i].timestamp = 0;
    }
}

int Allocate(const char* var) {
    // 1. 先找空闲寄存器
    for (int i = 0; i < mips_reg_list_len; ++i) {
        int reg = mips_reg_list[i];
        if (!reg_desc[reg].is_used) {
            reg_desc[reg].is_used = 1;
            reg_desc[reg].timestamp = ++reg_timestamp_counter;
            if (var != NULL) {  // 只有当变量名不为NULL时才设置
                reg_desc[reg].var_name = strdup(var);
                // 更新变量的地址描述符
                AddressDescriptor* addr_desc = ensure_symbol(var);
                if (addr_desc != NULL) {  // 确保地址描述符不为NULL
                    addr_desc->reg_index = reg;
                }
            }
            return reg;
        }
    }
    
    // 2. 没有空闲，找最久未用的
    int min_time = 0x7fffffff, min_idx = -1;
    for (int i = 0; i < mips_reg_list_len; ++i) {
        int reg = mips_reg_list[i];
        if (reg_desc[reg].timestamp < min_time) {
            min_time = reg_desc[reg].timestamp;
            min_idx = reg;
        }
    }
    
    // 如果寄存器中已有变量，将其溢出到内存
    if (reg_desc[min_idx].var_name != NULL) {  // 确保变量名不为NULL
        // 更新原变量的地址描述符
        AddressDescriptor* old_addr_desc = lookup_symbol(reg_desc[min_idx].var_name);
        if (old_addr_desc != NULL) {  // 确保地址描述符不为NULL
            old_addr_desc->reg_index = -1;
            old_addr_desc->is_in_memory = 1;  // 标记变量在内存中
        }
    }
    
    reg_desc[min_idx].timestamp = ++reg_timestamp_counter;
    if (var != NULL) {  // 只有当变量名不为NULL时才设置
        reg_desc[min_idx].var_name = strdup(var);
        // 更新变量的地址描述符
        AddressDescriptor* addr_desc = ensure_symbol(var);
        if (addr_desc != NULL) {  // 确保地址描述符不为NULL
            addr_desc->reg_index = min_idx;
        }
    }
    return min_idx;
}

// 获取操作数的寄存器
int get_operand_reg(const char* operand, FILE* output) {
    if (operand == NULL) return -1;
    
    // 处理立即数
    if (operand[0] == '#') {
        int reg = Allocate(NULL);  // 立即数不需要变量名
        fprintf(output, "li %s, %s\n", regName[reg], operand + 1);
        return reg;
    }
    
    // 处理变量
    const char* real_name = get_real_var_name(operand);
    if (real_name == NULL) return -1;
    
    // 确保变量在符号表中
    AddressDescriptor* addr_desc = ensure_symbol(real_name);
    if (addr_desc == NULL) return -1;
    
    // 查找变量是否已在寄存器
    for (int i = 0; i < mips_reg_list_len; ++i) {
        int reg = mips_reg_list[i];
        if (reg_desc[reg].is_used && reg_desc[reg].var_name != NULL && 
            strcmp(reg_desc[reg].var_name, real_name) == 0) {
            reg_desc[reg].timestamp = ++reg_timestamp_counter;
            return reg;
        }
    }
    
    // 不在寄存器中，分配新寄存器
    int reg = Allocate(real_name);
    
    // 如果变量在内存中，需要加载
    if (addr_desc->is_in_memory) {
        fprintf(output, "lw %s, %d($fp)\n", regName[reg], -80 -addr_desc->stack_offset);
        addr_desc->is_in_memory = 0;
        addr_desc->reg_index = reg;
        reg_desc[reg].var_name = strdup(real_name);
        reg_desc[reg].is_used = 1;
        reg_desc[reg].timestamp = ++reg_timestamp_counter;
    }
    
    return reg;
}

void assign_regs(const char *result, const char *op1, const char *op2, int *r_result, int *r_op1, int *r_op2, FILE *output) {
    if (result == NULL || op1 == NULL || op2 == NULL || r_result == NULL || r_op1 == NULL || r_op2 == NULL) {
        return;
    }
    
    *r_op1 = get_operand_reg(op1, output);
    *r_op2 = get_operand_reg(op2, output);
    *r_result = Allocate(result);
}