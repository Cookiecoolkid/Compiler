#ifndef ASSIGN_REG_H
#define ASSIGN_REG_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MIPS_REGS_NUM 32

// MIPS寄存器名称数组
extern char* regName[MIPS_REGS_NUM];

// 寄存器描述符结构体
typedef struct RegisterDescriptor {
    int reg_index;   // 寄存器索引
    char *var_name;  // 存储的变量名
    int is_used;     // 是否被使用
} RegisterDescriptor;

// 地址描述符结构体
typedef struct AddressDescriptor {
    char *var_name;  // 变量名
    int in_reg;      // 是否在寄存器中
    int reg_index;   // 如果在寄存器中，存储的寄存器索引
    int stack_offset; // 如果在栈中，存储的栈偏移量
} AddressDescriptor;

// 中间代码符号表节点结构体
typedef struct InterSymbolTableNode {
    AddressDescriptor *addr_desc;  // 地址描述符
    struct InterSymbolTableNode *next;  // 下一个节点
} InterSymbolTableNode;

// 中间代码符号表结构体
typedef struct InterSymbolTable {
    InterSymbolTableNode *head;  // 头节点
    int stack_offset;       // 当前栈偏移量
} InterSymbolTable;

// 寄存器分配器结构体
typedef struct RegisterAllocator {
    RegisterDescriptor *regs;  // 寄存器描述符数组
    InterSymbolTable *sym_table;    // 中间代码符号表
    int num_regs;             // 可用寄存器数量
} RegisterAllocator;

// 函数声明
RegisterAllocator* create_register_allocator(int num_regs);
void free_register_allocator(RegisterAllocator *allocator);
void insert_symbol(RegisterAllocator *allocator, const char *var_name);
AddressDescriptor* lookup_symbol(RegisterAllocator *allocator, const char *var_name);
int get_reg(RegisterAllocator *allocator, const char *var_name);
void free_reg(RegisterAllocator *allocator, int reg_index);
void spill_reg(RegisterAllocator *allocator, int reg_index);

#endif // ASSIGN_REG_H
