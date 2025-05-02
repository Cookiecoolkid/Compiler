#ifndef __COMMAND_H
#define __COMMAND_H

#include <stdio.h>
#include <stdlib.h>

#define NULL_VALUE 0
#define NULL_NAME NULL
#define NULL_OP NULL
#define NULL_RELOP 0
#define INT_FLOAT_SIZE 4

// 定义操作类型枚举
typedef enum {
    LABEL,        // 定义标号
    FUNCTION_OP,  // 定义函数
    ASSIGN,       // 赋值操作
    ADD,          // 加法操作
    SUB,          // 减法操作
    MUL,          // 乘法操作
    DIV_OP,          // 除法操作
    ADDR,         // 取地址操作
    DEREF,        // 取内存单元内容操作
    STORE,        // 存储操作
    GOTO,         // 无条件跳转
    COND_GOTO,    // 条件跳转
    RETURN_OP,       // 返回操作
    DEC,          // 内存空间申请
    ARG,          // 传实参
    CALL,         // 函数调用
    PARAM,        // 函数参数声明
    READ,         // 从控制台读取
    WRITE         // 向控制台打印
} op_type;

// 定义比较操作符枚举（用于条件跳转）
typedef enum {
    EQ = 1,   // 等于
    NE,   // 不等于
    LT,   // 小于
    GT,   // 大于
    LE,   // 小于等于
    GE    // 大于等于
} relop;

typedef enum {
    VARIABLE,    // 变量
    CONSTANT,    // 常量
    TEMP,        // 临时变量
    FUNCTION_NAME, // 函数名
    LABEL_NAME     // 标签名
} operand_kind;

typedef enum {
    VAL,         // 值
    ADDRESS      // 地址
} operand_type;

typedef struct command_* command;
typedef struct operand_* operand;

struct operand_ {
    operand_kind kind;
    operand_type type;
    
    int value;   // 常量值 / 变量size
    char* name;  // 变量名或函数名

    unsigned tag; // 标记，用于区分不同的操作数
};

// 定义 command 结构体
struct command_ {
    op_type op;   // 操作类型
    operand arg1;     // 第一个参数
    operand arg2;     // 第二个参数（对于单目运算符或某些操作，可能不使用）
    operand result;   // 结果或目标标号
    relop rel;   // 比较操作符（仅用于条件跳转）
};

operand create_operand(int value, char* name, int kind, int type);
command create_command(op_type op, operand arg1, operand arg2, operand result, relop rel);

char* command_to_string(command cmd);

void free_command(command cmd);
void free_operand(operand op);

void append_command_to_file(command cmd, FILE* file);


#endif // __COMMAND_H