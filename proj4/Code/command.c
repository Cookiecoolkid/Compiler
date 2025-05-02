#include "command.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

char* strdup(const char* s);

unsigned labelTag = 0;
unsigned tempTag = 0;


command create_command(op_type op, operand arg1, operand arg2, operand result, relop rel) {
    command cmd = (command)malloc(sizeof(struct command_));
    if (cmd == NULL) {
        perror("Memory allocation failed");
        exit(1);
    }
    cmd->op = op;
    cmd->arg1 = arg1;
    cmd->arg2 = arg2;
    cmd->result = result;
    cmd->rel = rel;
    return cmd;
}

// 定义 create_operand 函数
operand create_operand(int value, char* name, int kind, int type) {
    operand op = (operand)malloc(sizeof(struct operand_));
    if (op == NULL) {
        perror("Memory allocation failed");
        exit(1);
    }
    
    op->kind = kind;
    op->type = type;
    op->value = value;

    switch (kind) {
        case CONSTANT: {
            if (name != NULL) op->name = strdup(name);
            op->tag = 0;
            break;
        }
        case VARIABLE: {
            assert(name != NULL);
            char* varName = (char*)malloc((strlen(name) + 2) * sizeof(char));
            strcpy(varName, name);
            strcat(varName, "_");
            op->name = varName;
            op->tag = 0;
            break;
        }
        case FUNCTION_NAME: {
            assert(name != NULL);
            op->name = strdup(name);
            op->tag = 0;
            break;
        }
        case LABEL_NAME: {
            // concat name and tag
            char* tagStr = (char*)malloc(10 * sizeof(char));
            snprintf(tagStr, 10, "%d", labelTag);
            op->name = (char*)malloc((strlen("label") + strlen(tagStr) + 1) * sizeof(char));
            strcpy(op->name, "label");
            strcat(op->name, tagStr);
            op->tag = labelTag++;
            break;
        }
        case TEMP: {
            char* tagStr = (char*)malloc(10 * sizeof(char));
            snprintf(tagStr, 10, "%d", tempTag);
            op->name = (char*)malloc((strlen("temp") + strlen(tagStr) + 1) * sizeof(char));
            strcpy(op->name, "temp");
            strcat(op->name, tagStr);
            op->tag = tempTag++;
            break;
        }
        default: {
            fprintf(stderr, "Unknown operand kind\n");
            exit(1);
        }
    }

    return op;
}

// 定义 free_operand 函数，用于释放 operand 中的动态分配内存
void free_operand(operand op) {
    if (op != NULL) {
        free(op);
        op = NULL;
    }
}

char* command_to_string(command cmd) {
    if (cmd == NULL) {
        fprintf(stderr, "Error: cmd is NULL in command_to_string\n");
        return NULL;
    }

    // 定义操作类型和比较操作符的字符串表示
    const char* rel_strings[] = {
        "NULL_RELOP", "==", "!=", "<", ">", "<=", ">="
    };

    // 分配足够的内存来存储字符串
    char* str = (char*)malloc(256 * sizeof(char));
    if (str == NULL) {
        perror("Memory allocation failed in command_to_string");
        return NULL;
    }

    // 初始化字符串
    memset(str, 0, 256);

    // 根据操作类型生成字符串
    switch (cmd->op) {
        case LABEL:
            snprintf(str, 256, "LABEL %s :", cmd->result->name);
            break;
        case FUNCTION_OP:
            snprintf(str, 256, "\nFUNCTION %s :", cmd->result->name);
            break;
        case ASSIGN:
            snprintf(str, 256, "%s := %s", cmd->result->name, cmd->arg1->name);
            break;
        case ADD:
            snprintf(str, 256, "%s := %s + %s", cmd->result->name, cmd->arg1->name, cmd->arg2->name);
            break;
        case SUB:
            snprintf(str, 256, "%s := %s - %s", cmd->result->name, cmd->arg1->name, cmd->arg2->name);
            break;
        case MUL:
            snprintf(str, 256, "%s := %s * %s", cmd->result->name, cmd->arg1->name, cmd->arg2->name);
            break;
        case DIV_OP:
            snprintf(str, 256, "%s := %s / %s", cmd->result->name, cmd->arg1->name, cmd->arg2->name);
            break;
        case ADDR:
            snprintf(str, 256, "%s := &%s", cmd->result->name, cmd->arg1->name);
            break;
        case DEREF:
            snprintf(str, 256, "%s := *%s", cmd->result->name, cmd->arg1->name);
            break;
        case STORE:
            snprintf(str, 256, "*%s := %s", cmd->arg1->name, cmd->arg2->name);
            break;
        case GOTO:
            snprintf(str, 256, "GOTO %s", cmd->result->name);
            break;
        case COND_GOTO:
            snprintf(str, 256, "IF %s %s %s GOTO %s", 
                    cmd->arg1->name, 
                    rel_strings[cmd->rel], 
                    cmd->arg2->name, 
                    cmd->result->name);
            break;
        case RETURN_OP:
            snprintf(str, 256, "RETURN %s", cmd->result->name);
            break;
        case DEC:
            snprintf(str, 256, "DEC %s %d", cmd->result->name, cmd->result->value);
            break;
        case ARG:
            snprintf(str, 256, "ARG %s", cmd->arg1->name);
            break;
        case CALL:
            snprintf(str, 256, "%s := CALL %s", cmd->result->name, cmd->arg1->name);
            break;
        case PARAM:
            snprintf(str, 256, "PARAM %s", cmd->result->name);
            break;
        case READ:
            snprintf(str, 256, "READ %s", cmd->result->name);
            break;
        case WRITE:
            snprintf(str, 256, "WRITE %s", cmd->arg1->name);
            break;
        default:
            snprintf(str, 256, "UNKNOWN OP");
            break;
    }

    return str;
}

void append_command_to_file(command cmd, FILE* file) {
    if (cmd == NULL || file == NULL) {
        return;
    }

    char* str = command_to_string(cmd);
    if (str == NULL) {
        return;
    }

    fprintf(file, "%s\n", str);
    
    // 释放内存
    // free(str);
    // free_command(cmd);
}


void free_command(command cmd) {
    if (cmd != NULL) {
        // 释放操作数成员
        if (cmd->arg1 != NULL) {
            free_operand(cmd->arg1);
            cmd->arg1 = NULL;
        }
        if (cmd->arg2 != NULL) {
            free_operand(cmd->arg2);
            cmd->arg2 = NULL;
        }
        if (cmd->result != NULL) {
            free_operand(cmd->result);
            cmd->result = NULL;
        }
        // 释放命令本身
        free(cmd);
        cmd = NULL;
    }
}