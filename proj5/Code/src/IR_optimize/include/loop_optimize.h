#ifndef CODE_LOOP_OPTIMIZE_H
#define CODE_LOOP_OPTIMIZE_H

#include <loop_analysis.h>

// 函数声明
void LoopAnalysis_identify_invariants(LoopAnalysis *t, Loop *loop);
void LoopAnalysis_motion_invariants(LoopAnalysis *t, Loop *loop, IR_function *func);

// 强度削减相关函数
void LoopAnalysis_identify_induction_vars(LoopAnalysis *t, Loop *loop);
void LoopAnalysis_reduce_strength(LoopAnalysis *t, Loop *loop, IR_function *func);

// 优化函数
void loop_optimize(IR_function *func);

#endif //CODE_LOOP_OPTIMIZE_H 