#ifndef CODE_LOOP_INVARIANT_CODE_MOTION_H
#define CODE_LOOP_INVARIANT_CODE_MOTION_H

#include <dataflow_analysis.h>

// 定义必要的类型
DEF_SET(IR_block)
DEF_SET(IR_var)
DEF_LIST(Loop_ptr)
DEF_MAP(IR_var, Set_IR_block)

typedef Set_IR_block *Set_ptr_IR_block;
typedef Set_IR_var *Set_ptr_IR_var;
typedef IR_block *IR_block_ptr;

// 循环结构体
typedef struct Loop {
    IR_block_ptr header;           // 循环头
    Set_ptr_IR_block body;      // 循环体
    Set_ptr_IR_block exits;     // 循环出口
    Set_ptr_IR_var invariant_vars;  // 循环不变变量
} Loop, *Loop_ptr;

// 循环分析器
typedef struct LoopAnalysis {
    struct LoopAnalysis_virtualTable {
        void (*teardown) (LoopAnalysis *t);
        void (*analyze_loops) (LoopAnalysis *t, IR_function *func);
        void (*identify_invariants) (LoopAnalysis *t, Loop *loop);
        void (*motion_invariants) (LoopAnalysis *t, Loop *loop, IR_function *func);
        void (*printResult) (LoopAnalysis *t, IR_function *func);
    } const *vTable;
    List_Loop_ptr loops;        // 函数中的所有循环
} LoopAnalysis;

// 函数声明
void LoopAnalysis_init(LoopAnalysis *t);
void LoopAnalysis_teardown(LoopAnalysis *t);
void LoopAnalysis_analyze_loops(LoopAnalysis *t, IR_function *func);
void LoopAnalysis_identify_invariants(LoopAnalysis *t, Loop *loop);
void LoopAnalysis_motion_invariants(LoopAnalysis *t, Loop *loop, IR_function *func);
void LoopAnalysis_print_result(LoopAnalysis *t, IR_function *func);

// 优化函数
void loop_invariant_code_motion(IR_function *func);

#endif //CODE_LOOP_INVARIANT_CODE_MOTION_H 