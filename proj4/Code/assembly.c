#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "assembly.h"

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
static void process_expression(char *expr, FILE *output) {
    char op1[64], op2[64], op3[64];
    char temp[256];
    
    // 跳过空行
    if (strlen(expr) == 0) {
        return;
    }
    
    // 处理常量
    if (expr[0] == '#') {
        fprintf(output, "li Reg(temp), %s\n", expr + 1);
        return;
    }
    
    // 处理变量
    if (strchr(expr, ' ') == NULL && strchr(expr, ':') == NULL) {
        fprintf(output, "move Reg(temp), Reg(%s)\n", expr);
        return;
    }
    
    // 处理函数调用
    if (strstr(expr, "CALL") != NULL) {
        char *call_pos = strstr(expr, "CALL");
        char *func_name = call_pos + 5;  // 跳过 "CALL " 这5个字符
        fprintf(output, "jal %s\n", func_name);
        fprintf(output, "move Reg(temp), Reg(v0)\n");
        return;
    }
    
    // 处理指针操作
    if (expr[0] == '*') {
        fprintf(output, "lw Reg(temp), 0(Reg(%s))\n", expr + 1);
        return;
    }
    
    // 处理算术运算
    if (strchr(expr, '+') != NULL) {
        char *plus = strchr(expr, '+');
        *plus = '\0';
        strcpy(op1, expr);
        strcpy(op2, plus + 1);
        
        if (op2[0] == '#') {
            process_expression(op1, output);
            fprintf(output, "addi Reg(temp), Reg(temp), %s\n", op2 + 1);
        } else {
            process_expression(op1, output);
            fprintf(output, "move Reg(%s), Reg(temp)\n", "temp1");
            process_expression(op2, output);
            fprintf(output, "add Reg(temp), Reg(%s), Reg(temp)\n", "temp1");
        }
        return;
    }
    
    if (strchr(expr, '-') != NULL) {
        char *minus = strchr(expr, '-');
        *minus = '\0';
        strcpy(op1, expr);
        strcpy(op2, minus + 1);
        
        if (op2[0] == '#') {
            process_expression(op1, output);
            fprintf(output, "addi Reg(temp), Reg(temp), -%s\n", op2 + 1);
        } else {
            process_expression(op1, output);
            fprintf(output, "move Reg(%s), Reg(temp)\n", "temp1");
            process_expression(op2, output);
            fprintf(output, "sub Reg(temp), Reg(%s), Reg(temp)\n", "temp1");
        }
        return;
    }
    
    if (strchr(expr, '*') != NULL) {
        char *mul = strchr(expr, '*');
        *mul = '\0';
        strcpy(op1, expr);
        strcpy(op2, mul + 1);
        
        process_expression(op1, output);
        fprintf(output, "move Reg(%s), Reg(temp)\n", "temp1");
        process_expression(op2, output);
        fprintf(output, "mul Reg(temp), Reg(%s), Reg(temp)\n", "temp1");
        return;
    }
    
    if (strchr(expr, '/') != NULL) {
        char *div = strchr(expr, '/');
        *div = '\0';
        strcpy(op1, expr);
        strcpy(op2, div + 1);
        
        process_expression(op1, output);
        fprintf(output, "move Reg(%s), Reg(temp)\n", "temp1");
        process_expression(op2, output);
        fprintf(output, "div Reg(%s), Reg(temp)\n", "temp1");
        fprintf(output, "mflo Reg(temp)\n");
        return;
    }
    
    // 处理赋值
    if (strstr(expr, ":=") != NULL) {
        char *assign = strstr(expr, ":=");
        *assign = '\0';
        strcpy(op1, expr);
        strcpy(op2, assign + 2);
        
        process_expression(op2, output);
        fprintf(output, "move Reg(%s), Reg(temp)\n", op1);
        return;
    }
    
    // 处理指针赋值
    if (strchr(expr, '*') != NULL && strchr(expr, '=') != NULL) {
        char *ptr = strchr(expr, '*');
        char *equal = strchr(expr, '=');
        *ptr = '\0';
        *equal = '\0';
        strcpy(op1, expr);
        strcpy(op2, equal + 1);
        
        process_expression(op2, output);
        fprintf(output, "sw Reg(temp), 0(Reg(%s))\n", op1);
        return;
    }
}

void translate_to_mips(FILE *input, FILE *output) {
    char line[256];
    char current_function[64] = "";
    
    // 添加汇编头部
    add_assembly_header(output);
    
    while (fgets(line, sizeof(line), input)) {
        // 移除行尾的换行符
        line[strcspn(line, "\n")] = 0;
        
        // 跳过空行
        if (strlen(line) == 0) {
            continue;
        }
        
        // 处理函数定义
        if (strstr(line, "FUNCTION") != NULL) {
            char func_name[64];
            sscanf(line, "FUNCTION %s :", func_name);
            strcpy(current_function, func_name);
            fprintf(output, "%s:\n", func_name);
            continue;
        }
        
        // 处理参数声明
        if (strstr(line, "PARAM") != NULL) {
            char param[64];
            sscanf(line, "PARAM %s", param);
            fprintf(output, "move Reg(%s), Reg(a0)\n", param);
            continue;
        }
        
        // 处理参数传递
        if (strstr(line, "ARG") != NULL) {
            char arg[64];
            sscanf(line, "ARG %s", arg);
            fprintf(output, "move Reg(a0), Reg(%s)\n", arg);
            continue;
        }
        
        // 处理标签
        if (strstr(line, "LABEL") != NULL) {
            char label[64];
            sscanf(line, "LABEL %s:", label);
            fprintf(output, "%s:\n", label);
            continue;
        }
        
        // 处理跳转指令
        if (strstr(line, "GOTO") != NULL) {
            char label[64];
            sscanf(line, "GOTO %s", label);
            fprintf(output, "j %s\n", label);
            continue;
        }
        
        // 处理返回语句
        if (strstr(line, "RETURN") != NULL) {
            char var[64];
            sscanf(line, "RETURN %s", var);
            if (var[0] == '#') {
                fprintf(output, "li Reg(v0), %s\n", var + 1);
            } else {
                fprintf(output, "move Reg(v0), Reg(%s)\n", var);
            }
            fprintf(output, "jr Reg(ra)\n");
            continue;
        }
        
        // 处理条件跳转
        if (strstr(line, "IF") != NULL) {
            char cond[64], op1[64], op2[64], label[64];
            char *if_pos = strstr(line, "IF");
            char *goto_pos = strstr(line, "GOTO");
            *goto_pos = '\0';
            sscanf(goto_pos + 5, "%s", label);
            
            char *cond_str = if_pos + 3;
            if (strstr(cond_str, "==") != NULL) {
                sscanf(cond_str, "%s == %s", op1, op2);
                fprintf(output, "beq Reg(%s), Reg(%s), %s\n", op1, op2, label);
            }
            else if (strstr(cond_str, "!=") != NULL) {
                sscanf(cond_str, "%s != %s", op1, op2);
                fprintf(output, "bne Reg(%s), Reg(%s), %s\n", op1, op2, label);
            }
            else if (strstr(cond_str, ">") != NULL) {
                sscanf(cond_str, "%s > %s", op1, op2);
                fprintf(output, "bgt Reg(%s), Reg(%s), %s\n", op1, op2, label);
            }
            else if (strstr(cond_str, "<") != NULL) {
                sscanf(cond_str, "%s < %s", op1, op2);
                fprintf(output, "blt Reg(%s), Reg(%s), %s\n", op1, op2, label);
            }
            else if (strstr(cond_str, ">=") != NULL) {
                sscanf(cond_str, "%s >= %s", op1, op2);
                fprintf(output, "bge Reg(%s), Reg(%s), %s\n", op1, op2, label);
            }
            else if (strstr(cond_str, "<=") != NULL) {
                sscanf(cond_str, "%s <= %s", op1, op2);
                fprintf(output, "ble Reg(%s), Reg(%s), %s\n", op1, op2, label);
            }
            continue;
        }
        
        // 处理其他表达式
        process_expression(line, output);
    }
}
