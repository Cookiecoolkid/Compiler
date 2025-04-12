#ifndef __COMMAND_H
#define __COMMAND_H

// 定义操作类型枚举
typedef enum {
    LABEL,        // 定义标号
    FUNCTION,     // 定义函数
    ASSIGN,       // 赋值操作
    ADD,          // 加法操作
    SUB,          // 减法操作
    MUL,          // 乘法操作
    DIV,          // 除法操作
    ADDR,         // 取地址操作
    DEREF,        // 取内存单元内容操作
    STORE,        // 存储操作
    GOTO,         // 无条件跳转
    COND_GOTO,    // 条件跳转
    RETURN,       // 返回操作
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
} rel_op;

// 定义 command 结构体
typedef struct {
    op_type op;   // 操作类型
    int arg1;     // 第一个参数
    int arg2;     // 第二个参数（对于单目运算符或某些操作，可能不使用）
    int result;   // 结果或目标标号
    rel_op rel;   // 比较操作符（仅用于条件跳转）
} command;

command* create_command(op_type op, int arg1, int arg2, int result, rel_op rel);

char* command_to_string(command* cmd);

void free_command(command* cmd);


#endif // __COMMAND_H