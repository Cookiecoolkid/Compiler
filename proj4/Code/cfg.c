#include "cfg.h"
#include <string.h>

char* strdup(const char* s);

#define MAX_INSTRUCTIONS 1024
#define MAX_SUCCESSORS 16
#define MAX_BLOCKS 1024

// 判断是否是分支指令
static int is_branch_instruction(const char *line) {
    return strstr(line, "GOTO") != NULL || 
           strstr(line, "IF") != NULL || 
           strstr(line, "CALL") != NULL ||
           strstr(line, "RETURN") != NULL;
}

// 判断是否是标签
static int is_label(const char *line) {
    return strstr(line, "LABEL") != NULL;
}

// 判断是否是函数定义
static int is_function(const char *line) {
    return strstr(line, "FUNCTION") != NULL;
}

// 判断是否是特殊函数（READ/WRITE）
static int is_special_function(const char *line) {
    return strstr(line, "READ") != NULL || strstr(line, "WRITE") != NULL;
}

// 从指令中提取标签名
static char* extract_label(const char *line) {
    char *label = malloc(64);
    if (strstr(line, "LABEL") != NULL) {
        sscanf(line, "LABEL %[^:]:", label);
    } else if (strstr(line, "FUNCTION") != NULL) {
        sscanf(line, "FUNCTION %[^:]:", label);
    }
    // 删除最后的空格
    label[strcspn(label, " ")] = '\0';
    return label;
}

// 创建新的基本块
static BasicBlock* create_basic_block() {
    BasicBlock *block = malloc(sizeof(BasicBlock));
    block->instructions = malloc(MAX_INSTRUCTIONS * sizeof(char*));
    block->num_instructions = 0;
    block->successors = malloc(MAX_SUCCESSORS * sizeof(BasicBlock*));
    block->num_successors = 0;
    block->predecessors = malloc(MAX_SUCCESSORS * sizeof(BasicBlock*));
    block->num_predecessors = 0;
    block->is_entry_block = 0;
    block->is_exit_block = 0;
    return block;
}

// 添加前驱基本块
static void add_predecessor(BasicBlock *block, BasicBlock *pred) {
    block->predecessors[block->num_predecessors++] = pred;
}

// 添加后继基本块
static void add_successor(BasicBlock *block, BasicBlock *succ) {
    block->successors[block->num_successors++] = succ;
    add_predecessor(succ, block);
}

// 构建控制流图
ControlFlowGraph* build_cfg(FILE *input) {
    ControlFlowGraph *cfg = malloc(sizeof(ControlFlowGraph));
    cfg->blocks = malloc(MAX_BLOCKS * sizeof(BasicBlock*));
    cfg->num_blocks = 0;
    
    // 创建入口和出口基本块
    BasicBlock *entry_block = create_basic_block();
    entry_block->is_entry_block = 1;
    BasicBlock *exit_block = create_basic_block();
    exit_block->is_exit_block = 1;
    
    cfg->entry_block = entry_block;
    cfg->exit_block = exit_block;
    cfg->blocks[cfg->num_blocks++] = entry_block;
    cfg->blocks[cfg->num_blocks++] = exit_block;

    char line[256];
    BasicBlock *current_block = NULL;
    char *last_label = NULL;
    BasicBlock *first_executable_block = NULL;

    // 第一遍：识别基本块
    while (fgets(line, sizeof(line), input)) {
        line[strcspn(line, "\n")] = 0;

        // 跳过空行
        if (strlen(line) == 0) continue;

        if (current_block != NULL && (is_label(line) || is_function(line))) {
            last_label = extract_label(line);
            // 结束当前基本块
            cfg->blocks[cfg->num_blocks++] = current_block;
            current_block = NULL;
            // 创建新的基本块
            current_block = create_basic_block();
            current_block->instructions[current_block->num_instructions++] = strdup(line);
            continue;
        }

        // 如果 current_block 为空，则创建新的基本块
        if (current_block == NULL) {
            current_block = create_basic_block();
            if (first_executable_block == NULL) {
                first_executable_block = current_block;
            }
            if (is_label(line) || is_function(line)) {
                last_label = extract_label(line);
            }
        }

        current_block->instructions[current_block->num_instructions++] = strdup(line);
        // 如果是分支指令，结束当前基本块
        if (is_branch_instruction(line)) {
            cfg->blocks[cfg->num_blocks++] = current_block;
            current_block = NULL;
        }
    }

    // 添加最后一个基本块
    if (current_block != NULL) {
        cfg->blocks[cfg->num_blocks++] = current_block;
    }

    // 建立入口基本块和第一个可执行基本块的连接
    if (first_executable_block != NULL) {
        add_successor(entry_block, first_executable_block);
    } else {
        add_successor(entry_block, exit_block);
    }

    // 第二遍：建立基本块之间的连接
    for (int i = 0; i < cfg->num_blocks; i++) {
        BasicBlock *block = cfg->blocks[i];
        // 跳过入口和出口基本块
        if (block->is_entry_block || block->is_exit_block) continue;
        
        if (block->num_instructions > 0) {
            char *last_instruction = block->instructions[block->num_instructions - 1];
            
            // 处理无条件跳转(不能用strstr，只有当前四个字符是GOTO才处理)
            if (strncmp(last_instruction, "GOTO", 4) == 0) {
                char label[64];
                sscanf(last_instruction, "GOTO %s", label);
                
                // 查找目标基本块
                for (int j = 0; j < cfg->num_blocks; j++) {
                    BasicBlock *target = cfg->blocks[j];
                    if (target->num_instructions > 0 && 
                        (is_label(target->instructions[0]) || is_function(target->instructions[0])) &&
                        strcmp(extract_label(target->instructions[0]), label) == 0) {
                        add_successor(block, target);
                        break;
                    }
                }
                continue;
            }

            // 添加顺序执行的基本块
            if (i + 1 < cfg->num_blocks) {
                add_successor(block, cfg->blocks[i + 1]);
            }

            // 处理条件跳转
            if (strstr(last_instruction, "IF") != NULL) {
                char label[64];
                char *goto_pos = strstr(last_instruction, "GOTO");
                sscanf(goto_pos + 5, "%s", label);
                
                // 查找目标基本块
                for (int j = 0; j < cfg->num_blocks; j++) {
                    BasicBlock *target = cfg->blocks[j];
                    if (target->num_instructions > 0 && 
                        (is_label(target->instructions[0]) || is_function(target->instructions[0])) &&
                        strcmp(extract_label(target->instructions[0]), label) == 0) {
                        add_successor(block, target);
                        break;
                    }
                }
            }
            // 处理返回语句
            else if (strstr(last_instruction, "RETURN") != NULL) {
                // 返回语句连接到出口基本块
                add_successor(block, exit_block);
            }
            // 最后一条指令，连接到出口基本块
            else if (i + 1 == cfg->num_blocks) {
                add_successor(block, exit_block);
            }
        }
    }

    return cfg;
}

// 打印控制流图
void print_cfg(ControlFlowGraph *cfg, FILE *output) {
    fprintf(output, "Control Flow Graph:\n");
    fprintf(output, "Number of blocks: %d\n", cfg->num_blocks);
    
    for (int i = 0; i < cfg->num_blocks; i++) {
        BasicBlock *block = cfg->blocks[i];
        fprintf(output, "\nBlock %d:\n", i);
        fprintf(output, "Is entry block: %d\n", block->is_entry_block);
        fprintf(output, "Is exit block: %d\n", block->is_exit_block);
        
        fprintf(output, "Instructions:\n");
        for (int j = 0; j < block->num_instructions; j++) {
            fprintf(output, "  %s\n", block->instructions[j]);
        }
        
        fprintf(output, "Predecessors:\n");
        for (int j = 0; j < block->num_predecessors; j++) {
            int pred_idx = -1;
            for (int k = 0; k < cfg->num_blocks; k++) {
                if (cfg->blocks[k] == block->predecessors[j]) {
                    pred_idx = k;
                    break;
                }
            }
            fprintf(output, "  Block %d\n", pred_idx);
        }
        
        fprintf(output, "Successors:\n");
        for (int j = 0; j < block->num_successors; j++) {
            int succ_idx = -1;
            for (int k = 0; k < cfg->num_blocks; k++) {
                if (cfg->blocks[k] == block->successors[j]) {
                    succ_idx = k;
                    break;
                }
            }
            fprintf(output, "  Block %d\n", succ_idx);
        }
    }
}