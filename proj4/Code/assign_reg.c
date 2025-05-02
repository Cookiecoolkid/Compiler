#include "assign_reg.h"

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

// 创建寄存器分配器
RegisterAllocator* create_register_allocator(int num_regs) {
    RegisterAllocator *allocator = malloc(sizeof(RegisterAllocator));
    allocator->num_regs = num_regs;
    
    // 初始化寄存器描述符数组
    allocator->regs = malloc(num_regs * sizeof(RegisterDescriptor));
    for (int i = 0; i < num_regs; i++) {
        allocator->regs[i].reg_index = i;
        allocator->regs[i].var_name = NULL;
        allocator->regs[i].is_used = 0;
    }
    
    // 初始化中间代码符号表
    allocator->sym_table = malloc(sizeof(InterSymbolTable));
    allocator->sym_table->head = NULL;
    allocator->sym_table->stack_offset = 0;
    
    return allocator;
}

// 释放寄存器分配器
void free_register_allocator(RegisterAllocator *allocator) {
    if (allocator == NULL) return;
    
    // 释放寄存器描述符
    for (int i = 0; i < allocator->num_regs; i++) {
        if (allocator->regs[i].var_name != NULL) {
            free(allocator->regs[i].var_name);
        }
    }
    free(allocator->regs);
    
    // 释放中间代码符号表
    InterSymbolTableNode *current = allocator->sym_table->head;
    while (current != NULL) {
        InterSymbolTableNode *next = current->next;
        free(current->addr_desc->var_name);
        free(current->addr_desc);
        free(current);
        current = next;
    }
    free(allocator->sym_table);
    
    free(allocator);
}

// 插入符号到中间代码符号表
void insert_symbol(RegisterAllocator *allocator, const char *var_name) {
    // 检查符号是否已存在
    if (lookup_symbol(allocator, var_name) != NULL) {
        return;
    }
    
    // 创建新的地址描述符
    AddressDescriptor *addr_desc = malloc(sizeof(AddressDescriptor));
    addr_desc->var_name = strdup(var_name);
    addr_desc->in_reg = 0;
    addr_desc->reg_index = -1;
    addr_desc->stack_offset = allocator->sym_table->stack_offset;
    
    // 更新栈偏移量
    allocator->sym_table->stack_offset += 4;  // 假设每个变量占用4字节
    
    // 创建新的中间代码符号表节点
    InterSymbolTableNode *node = malloc(sizeof(InterSymbolTableNode));
    node->addr_desc = addr_desc;
    node->next = allocator->sym_table->head;
    allocator->sym_table->head = node;
}

// 查找符号
AddressDescriptor* lookup_symbol(RegisterAllocator *allocator, const char *var_name) {
    InterSymbolTableNode *current = allocator->sym_table->head;
    while (current != NULL) {
        if (strcmp(current->addr_desc->var_name, var_name) == 0) {
            return current->addr_desc;
        }
        current = current->next;
    }
    return NULL;
}

// 获取可用的寄存器
int get_reg(RegisterAllocator *allocator, const char *var_name) {
    // 查找变量是否已经在寄存器中
    AddressDescriptor *addr_desc = lookup_symbol(allocator, var_name);
    if (addr_desc != NULL && addr_desc->in_reg) {
        return addr_desc->reg_index;
    }
    
    // 查找空闲寄存器
    for (int i = 0; i < allocator->num_regs; i++) {
        if (!allocator->regs[i].is_used) {
            // 分配寄存器
            allocator->regs[i].is_used = 1;
            if (allocator->regs[i].var_name != NULL) {
                free(allocator->regs[i].var_name);
            }
            allocator->regs[i].var_name = strdup(var_name);
            
            // 更新地址描述符
            if (addr_desc != NULL) {
                addr_desc->in_reg = 1;
                addr_desc->reg_index = i;
            }
            
            return i;
        }
    }
    
    // 如果没有空闲寄存器，选择一个寄存器进行溢出
    int reg_to_spill = 0;  // 简单起见，选择第一个寄存器
    spill_reg(allocator, reg_to_spill);
    
    // 分配溢出的寄存器
    allocator->regs[reg_to_spill].is_used = 1;
    if (allocator->regs[reg_to_spill].var_name != NULL) {
        free(allocator->regs[reg_to_spill].var_name);
    }
    allocator->regs[reg_to_spill].var_name = strdup(var_name);
    
    // 更新地址描述符
    if (addr_desc != NULL) {
        addr_desc->in_reg = 1;
        addr_desc->reg_index = reg_to_spill;
    }
    
    return reg_to_spill;
}

// 释放寄存器
void free_reg(RegisterAllocator *allocator, int reg_index) {
    if (reg_index < 0 || reg_index >= allocator->num_regs) {
        return;
    }
    
    // 更新地址描述符
    if (allocator->regs[reg_index].var_name != NULL) {
        AddressDescriptor *addr_desc = lookup_symbol(allocator, allocator->regs[reg_index].var_name);
        if (addr_desc != NULL) {
            addr_desc->in_reg = 0;
            addr_desc->reg_index = -1;
        }
    }
    
    // 释放寄存器
    allocator->regs[reg_index].is_used = 0;
    if (allocator->regs[reg_index].var_name != NULL) {
        free(allocator->regs[reg_index].var_name);
        allocator->regs[reg_index].var_name = NULL;
    }
}

// 溢出寄存器到栈
void spill_reg(RegisterAllocator *allocator, int reg_index) {
    if (reg_index < 0 || reg_index >= allocator->num_regs) {
        return;
    }
    
    // 如果寄存器未被使用，直接返回
    if (!allocator->regs[reg_index].is_used) {
        return;
    }
    
    // 获取变量名
    char *var_name = allocator->regs[reg_index].var_name;
    if (var_name == NULL) {
        return;
    }
    
    // 查找地址描述符
    AddressDescriptor *addr_desc = lookup_symbol(allocator, var_name);
    if (addr_desc == NULL) {
        return;
    }
    
    // 更新地址描述符
    addr_desc->in_reg = 0;
    addr_desc->reg_index = -1;
    
    // 释放寄存器
    free_reg(allocator, reg_index);
}
