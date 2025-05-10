#ifndef ASSEMBLY_H
#define ASSEMBLY_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

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

// 活跃变量信息结构体
typedef struct LivenessInfo {
    unsigned char bits[128]; // 1024 bits，每个bit表示一个变量是否活跃
} LivenessInfo;

// 函数声明
void insert_symbol(const char *var_name);
AddressDescriptor* lookup_symbol(const char *var_name);
AddressDescriptor* ensure_symbol(const char* var);

// 将中间代码翻译为MIPS汇编代码
void translate_to_mips(FILE *input, FILE *output);

// 分配寄存器并返回三个寄存器编号
void assign_regs(const char *result, const char *op1, const char *op2, int *r_result, int *r_op1, int *r_op2, FILE *output);

// Allocate和Ensure辅助函数
int Allocate();
int Ensure(const char *var, FILE *output);

#endif // ASSEMBLY_H
