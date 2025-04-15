#include "command.h"
#include <stdio.h>

unsigned labelTag = 0;

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
            op->name = strdup(name);
            op->tag = 0;
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
        case FUNCTION:
            snprintf(str, 256, "FUNCTION %s", cmd->result->name);
            break;
        case ASSIGN:
            snprintf(str, 256, "%d := %d", cmd->result, cmd->arg1);
            break;
        case ADD:
            snprintf(str, 256, "%d := %d + %d", cmd->result, cmd->arg1, cmd->arg2);
            break;
        case SUB:
            snprintf(str, 256, "%d := %d - %d", cmd->result, cmd->arg1, cmd->arg2);
            break;
        case MUL:
            snprintf(str, 256, "%d := %d * %d", cmd->result, cmd->arg1, cmd->arg2);
            break;
        case DIV:
            snprintf(str, 256, "%d := %d / %d", cmd->result, cmd->arg1, cmd->arg2);
            break;
        case ADDR:
            snprintf(str, 256, "%d := &%d", cmd->result, cmd->arg1);
            break;
        case DEREF:
            snprintf(str, 256, "%d := *%d", cmd->result, cmd->arg1);
            break;
        case STORE:
            snprintf(str, 256, "*%d := %d", cmd->arg1, cmd->arg2);
            break;
        case GOTO:
            snprintf(str, 256, "GOTO %s%d", cmd->result->name, cmd->result->tag);
            break;
        case COND_GOTO:
            snprintf(str, 256, "IF %s %s %s GOTO %s%d", cmd->arg1->name, rel_strings[cmd->rel], cmd->arg2->name, cmd->result->name, cmd->result->tag);
            break;
        case RETURN:
            snprintf(str, 256, "RETURN %d", cmd->result);
            break;
        case DEC:
            snprintf(str, 256, "DEC %s %d", cmd->result->name, cmd->result->value);
            break;
        case ARG:
            snprintf(str, 256, "ARG %d", cmd->arg1);
            break;
        case CALL:
            snprintf(str, 256, "%d := CALL %d", cmd->result, cmd->arg1);
            break;
        case PARAM:
            snprintf(str, 256, "PARAM %s", cmd->result->name);
            break;
        case READ:
            snprintf(str, 256, "READ %d", cmd->result);
            break;
        case WRITE:
            snprintf(str, 256, "WRITE %d", cmd->arg1);
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