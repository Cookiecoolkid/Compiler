#ifndef ADDR_REGS_H
#define ADDR_REGS_H

#include <stdio.h>

#define MIPS_REGS_NUM 32
#define MAX_VARS 1024

// MIPS寄存器名称数组
extern char* regName[MIPS_REGS_NUM];

// 全局时间戳
extern unsigned long reg_timestamp_counter;

// 寄存器描述符
typedef struct {
    int reg_index;      // 寄存器编号
    char *var_name;     // 当前存储的变量名
    int is_used;        // 是否被使用
    unsigned long timestamp; // LRU时间戳
} RegisterDescriptor;

// 地址描述符
typedef struct {
    char *var_name;
    int reg_index;      // -1表示不在寄存器
    int stack_offset;
    int is_in_memory;   // 1表示变量在内存中，0表示变量尚未写入内存
} AddressDescriptor;

// 中间代码符号表节点结构体
typedef struct InterSymbol {
    AddressDescriptor *addr_desc;  // 地址描述符
    struct InterSymbol *next;  // 下一个节点
} InterSymbol;

// 中间代码符号表结构体
typedef struct InterSymbolTable {
    InterSymbol *head;  // 头节点
    int stack_offset;       // 当前栈偏移量
} InterSymbolTable;

// 全局变量声明
extern InterSymbolTable interSymbolTable;
extern RegisterDescriptor reg_desc[32];
extern int mips_reg_list[];
extern int mips_reg_list_len;
extern int mips_caller_reg_list[];
extern int mips_caller_reg_list_len;
extern int mips_callee_reg_list[];
extern int mips_callee_reg_list_len;

// 函数声明
void init_registers(void);
int Allocate(const char* var);

void assign_regs(const char* result, const char* op1, const char* op2, int* r_result, int* r_op1, int* r_op2, FILE* output);
AddressDescriptor* ensure_symbol(const char* var);
void spill_variable(const char* var, FILE* output);
int get_operand_reg(const char* operand, FILE* output);


#endif // ADDR_REGS_H