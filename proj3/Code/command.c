#include "command.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

char* strdup(const char* s);

unsigned labelTag = 0;
unsigned tempTag = 0;


command create_command(op_type op, operand arg1, operand arg2, operand result, relop rel) {
    command cmd = (command)malloc(sizeof(command));
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
    operand op;
    op->kind = kind;
    op->type = type;
    op->value = value;

    switch (kind) {
        case CONSTANT:
            op->name = strdup(name);
            op->tag = 0;
            break;
        case VARIABLE:
            op->name = strdup(name);
            op->tag = 0;
            break;
        case FUNCTION_NAME:
            op->name = strdup(name);
            op->tag = 0;
            break;
        case LABEL_NAME:
            op->name = "label";
            op->tag = labelTag++;
            break;
        case TEMP:
            op->name = "temp";
            op->tag = tempTag++;
            break;
        default:
            fprintf(stderr, "Unknown operand kind\n");
            exit(1);
    }

    return op;
}

// 定义 free_operand 函数，用于释放 operand 中的动态分配内存
void free_operand(operand op) {
    if (op->kind == VARIABLE || op->kind == FUNCTION_NAME || op->kind == LABEL_NAME) {
        free(op->name);
    }
}

char* command_to_string(command cmd) {
    // 定义操作类型和比较操作符的字符串表示
    const char* rel_strings[] = {
        "==", "!=", "<", ">", "<=", ">="
    };

    // 分配足够的内存来存储字符串
    char* str = (char*)malloc(256 * sizeof(char));
    if (str == NULL) {
        perror("Memory allocation failed");
        exit(1);
    }

    // 根据操作类型生成字符串
    switch (cmd->op) {
        case LABEL:
            snprintf(str, 256, "LABEL %s%d", cmd->result->name, cmd->result->tag);
            break;
        case FUNCTION_OP:
            snprintf(str, 256, "FUNCTION %s", cmd->result->name);
            break;
        case ASSIGN:
            if (cmd->result->type == ADDRESS) {
                snprintf(str, 256, "*%s := %s", cmd->result->name, cmd->arg1->name);
            } else {
                snprintf(str, 256, "%s := %s", cmd->result->name, cmd->arg1->name);
            }
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
            snprintf(str, 256, "GOTO %s%d", cmd->result->name, cmd->result->tag);
            break;
        case COND_GOTO:
            snprintf(str, 256, "IF %s %s %s GOTO %s%d", 
                    cmd->arg1->name, 
                    rel_strings[cmd->rel], 
                    cmd->arg2->name, 
                    cmd->result->name, 
                    cmd->result->tag);
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
    char* str = command_to_string(cmd);
    fprintf(file, "%s\n", str);
    free(str);
    free_command(cmd);
}


void free_command(command cmd) {
    if (cmd != NULL) {
        free(cmd);
    }
}