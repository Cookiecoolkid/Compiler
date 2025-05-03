#ifndef CFG_H
#define CFG_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// 基本块结构体
typedef struct BasicBlock {
    char **instructions;    // 基本块中的指令
    int num_instructions;   // 指令数量
    struct BasicBlock **successors;  // 后继基本块
    int num_successors;     // 后继基本块数量
    struct BasicBlock **predecessors;  // 前驱基本块
    int num_predecessors;   // 前驱基本块数量
    
    int is_entry_block;     // 是否是入口基本块
    int is_exit_block;      // 是否是出口基本块
} BasicBlock;

// 控制流图结构体
typedef struct ControlFlowGraph {
    BasicBlock **blocks;    // 基本块数组
    int num_blocks;         // 基本块数量
    BasicBlock *entry_block; // 入口基本块
    BasicBlock *exit_block;  // 出口基本块
} ControlFlowGraph;

// 函数声明
ControlFlowGraph* build_cfg(FILE *input);
void free_cfg(ControlFlowGraph *cfg);
void print_cfg(ControlFlowGraph *cfg, FILE *output);

#endif // CFG_H
