#ifndef CODE_LOOP_ANALYSIS_H
#define CODE_LOOP_ANALYSIS_H

#include <dataflow_analysis.h>


// 循环结构体
typedef struct Loop {
    IR_block_ptr header;           // 循环头
    Set_IR_block_ptr body;      // 循环体
    Set_IR_block_ptr exits;     // 循环出口
    Set_IR_var invariant_vars;  // 循环不变变量
} Loop, *Loop_ptr;

DEF_LIST(Loop_ptr)

// 归纳变量结构体
typedef struct InductionVar {
    IR_var base_var;           // 基础归纳变量
    IR_var derived_var;        // 派生变量
    int multiplier;            // 乘数
    int constant;              // 常数项
    Set_IR_block_ptr def_blocks;  // 定义所在的基本块
    Set_IR_block_ptr use_blocks;  // 使用所在的基本块
} InductionVar;

typedef InductionVar *InductionVar_ptr;
DEF_LIST(InductionVar)

// 前向声明
typedef struct LoopAnalysis LoopAnalysis;

// 循环分析器
struct LoopAnalysis {
    List_Loop_ptr loops;        // 函数中的所有循环
    List_InductionVar induction_vars;  // 所有归纳变量
    Map_IR_var_IR_var base_to_derived;     // 基础变量到派生变量的映射
};

// 函数声明
void LoopAnalysis_init(LoopAnalysis *t);
void LoopAnalysis_analyze_loops(LoopAnalysis *t, IR_function *func);
void LoopAnalysis_print_result(LoopAnalysis *t, IR_function *func);

#endif //CODE_LOOP_ANALYSIS_H 