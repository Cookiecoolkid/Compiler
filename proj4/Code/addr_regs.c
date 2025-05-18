#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include "addr_regs.h"

#define BASE_VAR_OFFSET (2 * 80)

char* strdup(const char* s);

// 函数前向声明
static AddressDescriptor* lookup_symbol(const char *var_name);

// 全局变量定义
InterSymbolTable interSymbolTable = {NULL, 0};  // 初始化 interSymbolTable
RegisterDescriptor reg_desc[32]; // 32个寄存器
int mips_reg_list[] = {8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25}; // $t0-$t9, $s0-$s7
int mips_reg_list_len = 18;

unsigned long reg_timestamp_counter = 0;

// 将变量溢出到内存
void spill_variable(const char* var, FILE* output) {
    if (var == NULL) return;
    
    // 获取变量的地址描述符
    AddressDescriptor* addr_desc = lookup_symbol(var);
    if (addr_desc == NULL) return;
    
    // 如果变量在寄存器中，将其写回内存
    if (addr_desc->reg_index >= 0) {
        int reg = addr_desc->reg_index;
        fprintf(output, "sw %s, %d($fp)\n", regName[reg], -BASE_VAR_OFFSET - addr_desc->stack_offset);
        
        // 更新地址描述符
        addr_desc->is_in_memory = 1;
        addr_desc->reg_index = -1;
        
        // 清理寄存器描述符
        reg_desc[reg].is_used = 0;
        reg_desc[reg].var_name = NULL;
    }
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
static void insert_symbol(const char *var_name, int size) {
    if (var_name == NULL) return;
    
    // 检查符号是否已存在
    if (lookup_symbol(var_name) != NULL) return;
    
    // 创建新的地址描述符
    AddressDescriptor *addr_desc = malloc(sizeof(AddressDescriptor));
    if (addr_desc == NULL) return;  // 内存分配失败
    
    addr_desc->var_name = strdup(var_name);
    addr_desc->reg_index = -1;
    addr_desc->stack_offset = interSymbolTable.stack_offset;
    addr_desc->is_in_memory = 0;
    addr_desc->size = size;      // 设置数组大小
    
    // 更新栈偏移量（数组需要对齐到4字节边界）
    int aligned_size = size * 4;  // 向上取整到4的倍数
    interSymbolTable.stack_offset += aligned_size;
    
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
        insert_symbol(var, 1);  // 非数组变量，size为 1
        addr_desc = lookup_symbol(var);
    }
    return addr_desc;
}

// 声明数组
void declare_array(const char* var_name, int size) {
    if (var_name == NULL || size <= 0) return;

    char arr_name[64];
    snprintf(arr_name, sizeof(arr_name), "&%s", var_name);

    insert_symbol(arr_name, size);
    interSymbolTable.stack_offset += size * 4;  // 更新栈偏移量
}


void init_registers() {
    for (int i = 0; i < 32; ++i) {
        reg_desc[i].reg_index = i;
        reg_desc[i].var_name = NULL;
        reg_desc[i].is_used = 0;
        reg_desc[i].timestamp = 0;
    }
}

// 查找空闲寄存器，如果没有则返回最久未使用的寄存器
static int find_free_reg() {
    // 先找空闲寄存器
    for (int i = 0; i < mips_reg_list_len; ++i) {
        int reg = mips_reg_list[i];
        if (!reg_desc[reg].is_used) {
            return reg;
        }
    }
    
    // 没有空闲，找最久未用的
    int min_time = 0x7fffffff, min_idx = -1;
    for (int i = 0; i < mips_reg_list_len; ++i) {
        int reg = mips_reg_list[i];
        if (reg_desc[reg].timestamp < min_time) {
            min_time = reg_desc[reg].timestamp;
            min_idx = reg;
        }
    }
    return min_idx;
}

int Allocate(const char* var, FILE* output) {
    int reg = find_free_reg();
    
    // 如果寄存器中已有变量，将其溢出到内存
    if (reg_desc[reg].var_name != NULL) {
        spill_variable(reg_desc[reg].var_name, output);
    }
    
    // 更新寄存器状态
    reg_desc[reg].timestamp = ++reg_timestamp_counter;
    reg_desc[reg].is_used = 1;
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

// 获取操作数的寄存器
int get_operand_reg(const char* operand, FILE* output) {
    if (operand == NULL) return -1;
    
    // 处理立即数
    if (operand[0] == '#') {
        int reg = Allocate(NULL, output);  // 立即数不需要变量名
        fprintf(output, "li %s, %s\n", regName[reg], operand + 1);
        return reg;
    }
    
    // 确保变量在符号表中
    AddressDescriptor* addr_desc = ensure_symbol(operand);
    if (addr_desc == NULL) return -1;
    
    // 检查变量是否已在寄存器中
    int reg = -1;
    if (addr_desc->reg_index >= 0) {
        reg_desc[addr_desc->reg_index].timestamp = ++reg_timestamp_counter;
        reg = addr_desc->reg_index;
    } else {
        // 如果变量不在寄存器中，分配新寄存器
        reg = Allocate(operand, output);
    }
    
    // 如果变量在内存中，需要加载
    if (addr_desc->size > 1) {
        // 对于数组，加载其基地址（栈空间地址）
        fprintf(output, "addi %s, $fp, %d\n", regName[reg], -BASE_VAR_OFFSET - addr_desc->stack_offset);
    } else if (addr_desc->is_in_memory){
        // 对于普通变量，加载其值
        fprintf(output, "lw %s, %d($fp)\n", regName[reg], -BASE_VAR_OFFSET - addr_desc->stack_offset);
    }
    
    return reg;
}

void assign_regs(const char *result, const char *op1, const char *op2, int *r_result, int *r_op1, int *r_op2, FILE *output) {
    if (result == NULL || op1 == NULL || op2 == NULL || r_result == NULL || r_op1 == NULL || r_op2 == NULL) {
        return;
    }
    
    *r_op1 = get_operand_reg(op1, output);
    *r_op2 = get_operand_reg(op2, output);
    *r_result = Allocate(result, output);
}