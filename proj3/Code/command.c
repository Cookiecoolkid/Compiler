#include "command.h"
#include <stdio.h>

command* create_command(op_type op, int arg1, int arg2, int result, rel_op rel) {
    command* cmd = (command*)malloc(sizeof(command));
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

char* command_to_string(command* cmd) {
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
            snprintf(str, 256, "LABEL %d", cmd->result);
            break;
        case FUNCTION:
            snprintf(str, 256, "FUNCTION %d", cmd->result);
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
            snprintf(str, 256, "GOTO %d", cmd->result);
            break;
        case COND_GOTO:
            snprintf(str, 256, "IF %d %s %d GOTO %d", cmd->arg1, rel_strings[cmd->rel], cmd->arg2, cmd->result);
            break;
        case RETURN:
            snprintf(str, 256, "RETURN %d", cmd->result);
            break;
        case DEC:
            snprintf(str, 256, "DEC %d %d", cmd->result, cmd->arg1);
            break;
        case ARG:
            snprintf(str, 256, "ARG %d", cmd->arg1);
            break;
        case CALL:
            snprintf(str, 256, "%d := CALL %d", cmd->result, cmd->arg1);
            break;
        case PARAM:
            snprintf(str, 256, "PARAM %d", cmd->arg1);
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

void append_command_to_file(command* cmd, FILE* file) {
    char* str = command_to_string(cmd);
    fprintf(file, "%s\n", str);
    free(str);
}


void free_command(command* cmd) {
    if (cmd != NULL) {
        free(cmd);
    }
}