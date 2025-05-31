#include <loop_invariant_code_motion.h>
#include <IR.h>

//// ============================ Loop Analysis ============================

static void LoopAnalysis_teardown(LoopAnalysis *t) {
    for_list(Loop_ptr, i, t->loops) {
        Loop_ptr loop = i->val;
        Set_IR_block_teardown(loop->body);
        Set_IR_block_teardown(loop->exits);
        Set_IR_var_teardown(loop->invariant_vars);
        RDELETE(Loop, loop);
    }
    List_Loop_ptr_teardown(&t->loops);
}

static void LoopAnalysis_analyze_loops(LoopAnalysis *t, IR_function *func) {
    // 使用深度优先搜索找到所有回边
    Set_IR_block visited;
    Set_IR_block_init(&visited);
    
    for_list(IR_block_ptr, i, func->blocks) {
        IR_block_ptr header = i->val;
        List_IR_block_ptr *preds = VCALL(func->blk_pred, get, header);
        
        // 检查每个前驱是否形成回边
        for_list(IR_block_ptr, j, *preds) {
            IR_block_ptr pred = j->val;
            if (VCALL(visited, exist, *pred)) {
                // 找到回边 pred -> header
                // 创建新的循环结构
                Loop_ptr loop = NEW(Loop);
                loop->header = header;
                loop->body = NEW(Set_IR_block);
                loop->exits = NEW(Set_IR_block);
                loop->invariant_vars = NEW(Set_IR_var);
                Set_IR_block_init(loop->body);
                Set_IR_block_init(loop->exits);
                Set_IR_var_init(loop->invariant_vars);
                
                // 使用DFS找到循环体中的所有基本块
                Set_IR_block worklist;
                Set_IR_block_init(&worklist);
                VCALL(worklist, insert, *pred);
                
                bool has_more = true;
                while (has_more) {
                    has_more = false;
                    for_set(IR_block, blk, worklist) {
                        IR_block current = blk->key;
                        VCALL(worklist, delete, current);
                        VCALL(*loop->body, insert, current);
                        has_more = true;
                        
                        // 添加blk的前驱到worklist
                        List_IR_block_ptr *blk_preds = VCALL(func->blk_pred, get, &current);
                        for_list(IR_block_ptr, k, *blk_preds) {
                            IR_block_ptr pred_blk = k->val;
                            if (!VCALL(*loop->body, exist, *pred_blk)) {
                                VCALL(worklist, insert, *pred_blk);
                            }
                        }
                        break;
                    }
                }
                
                // 找到循环出口
                for_set(IR_block, blk, *loop->body) {
                    List_IR_block_ptr *succs = VCALL(func->blk_succ, get, blk->key);
                    for_list(IR_block_ptr, k, *succs) {
                        IR_block_ptr succ = k->val;
                        if (!VCALL(*loop->body, exist, *succ)) {
                            VCALL(*loop->exits, insert, *succ);
                        }
                    }
                }
                
                // 将循环添加到分析器中
                List_Loop_ptr_push_back(&t->loops, loop);
                
                Set_IR_block_teardown(&worklist);
            }
        }
        VCALL(visited, insert, *header);
    }
    
    Set_IR_block_teardown(&visited);
}

static void LoopAnalysis_identify_invariants(LoopAnalysis *t, Loop *loop) {
    // 1. 收集循环中所有变量的定义和使用
    Map_IR_var_Set_IR_block def_blocks;  // 变量定义所在的基本块
    Map_IR_var_Set_IR_block use_blocks;  // 变量使用所在的基本块
    Map_IR_var_Set_IR_block_init(&def_blocks);
    Map_IR_var_Set_IR_block_init(&use_blocks);
    
    // 遍历循环体中的所有基本块
    for_set(IR_block, blk, *loop->body) {
        for_list(IR_stmt_ptr, i, blk->key.stmts) {
            IR_stmt *stmt = i->val;
            IR_var def = VCALL(*stmt, get_def);
            IR_use use = VCALL(*stmt, get_use_vec);
            
            // 记录定义
            if (def != IR_VAR_NONE) {
                Set_IR_block def_set;
                Set_IR_block_init(&def_set);
                VCALL(def_blocks, insert, def, def_set);
                VCALL(def_set, insert, blk.key);
            }
            
            // 记录使用
            for (unsigned j = 0; j < use.use_cnt; j++) {
                IR_val use_val = use.use_vec[j];
                if (!use_val.is_const) {
                    IR_var use_var = use_val.var;
                    Set_IR_block use_set;
                    Set_IR_block_init(&use_set);
                    VCALL(use_blocks, insert, use_var, use_set);
                    VCALL(use_set, insert, blk->key);
                }
            }
        }
    }
    
    // 2. 检查每个变量是否满足循环不变条件
    for_map(IR_var, Set_IR_block, i, def_blocks) {
        IR_var var = i->key;
        Set_IR_block def_set = i->val;
        Set_IR_block use_set = VCALL(use_blocks, get, var);
        
        // 条件1: 循环不变 - 变量的所有操作数在循环外定义或为常量
        bool is_invariant = true;
        for_set(IR_block, def_blk, def_set) {
            IR_stmt *def_stmt = def_blk->key.stmts.tail->val;
            IR_use use = VCALL(*def_stmt, get_use_vec);
            for (unsigned j = 0; j < use.use_cnt; j++) {
                IR_val use_val = use.use_vec[j];
                if (!use_val.is_const) {
                    IR_var use_var = use_val.var;
                    Set_IR_block use_def_set = VCALL(def_blocks, get, use_var);
                    bool has_def = false;
                    for_set(IR_block, def_blk2, use_def_set) {
                        has_def = true;
                        break;
                    }
                    if (has_def) {
                        is_invariant = false;
                        break;
                    }
                }
            }
            if (!is_invariant) break;
        }
        
        if (!is_invariant) continue;
        
        // 条件2: 定义块支配所有出口块
        bool dominates_exits = true;
        for_set(IR_block, exit_blk, *loop->exits) {
            // TODO: 实现支配性检查
            // 这里需要实现支配性分析
            // 暂时假设所有定义块都支配出口块
        }
        
        if (!dominates_exits) continue;
        
        // 条件3: 循环内没有其他定义
        bool has_multiple_defs = false;
        unsigned def_count = 0;
        for_set(IR_block, def_blk, def_set) {
            def_count++;
            if (def_count > 1) {
                has_multiple_defs = true;
                break;
            }
        }
        if (has_multiple_defs) continue;
        
        // 条件4: 定义块支配所有使用块
        bool dominates_uses = true;
        if (use_set.root) {
            for_set(IR_block, use_blk, use_set) {
                // TODO: 实现支配性检查
                // 这里需要实现支配性分析
                // 暂时假设所有定义块都支配使用块
            }
        }
        
        if (!dominates_uses) continue;
        
        // 满足所有条件，添加到不变变量集合
        VCALL(*loop->invariant_vars, insert, var);
    }
    
    // 清理资源
    for_map(IR_var, Set_IR_block, i, def_blocks) {
        Set_IR_block_teardown(&i->val);
    }
    for_map(IR_var, Set_IR_block, i, use_blocks) {
        Set_IR_block_teardown(&i->val);
    }
    Map_IR_var_Set_IR_block_teardown(&def_blocks);
    Map_IR_var_Set_IR_block_teardown(&use_blocks);
}

static void LoopAnalysis_motion_invariants(LoopAnalysis *t, Loop *loop, IR_function *func) {
    // 1. 在循环头前创建新的基本块
    IR_block pre_header;
    IR_block_init(&pre_header, IR_LABEL_NONE);
    
    // 2. 收集需要移动的语句
    List_IR_stmt_ptr stmts_to_move;
    List_IR_stmt_ptr_init(&stmts_to_move);
    
    for_set(IR_var, var, *loop->invariant_vars) {
        // 找到变量的定义语句
        for_set(IR_block, blk, *loop->body) {
            for_list(IR_stmt_ptr, i, blk->key.stmts) {
                IR_stmt *stmt = i->val;
                if (VCALL(*stmt, get_def) == var->key) {
                    List_IR_stmt_ptr_push_back(&stmts_to_move, stmt);
                    break;
                }
            }
        }
    }
    
    // 3. 移动语句到pre-header
    for_list(IR_stmt_ptr, i, stmts_to_move) {
        IR_stmt *stmt = i->val;
        // 从原位置删除语句
        for_set(IR_block, blk, *loop->body) {
            for_list(IR_stmt_ptr, j, blk->key.stmts) {
                if (j->val == stmt) {
                    List_IR_stmt_ptr_erase(j);
                    break;
                }
            }
        }
        // 添加到pre-header
        List_IR_stmt_ptr_push_back(&pre_header.stmts, stmt);
    }
    
    // 4. 更新控制流图
    // 4.1 找到循环头的所有前驱
    List_IR_block_ptr *header_preds = VCALL(func->blk_pred, get, loop->header);
    List_IR_block_ptr *header_succs = VCALL(func->blk_succ, get, loop->header);
    
    // 4.2 更新前驱到pre-header的边
    for_list(IR_block_ptr, i, *header_preds) {
        IR_block_ptr pred = i->val;
        if (!VCALL(*loop->body, exist, *pred)) {
            // 从pred到header的边改为到pre-header
            List_IR_block_ptr *pred_succs = VCALL(func->blk_succ, get, pred);
            for_list(IR_block_ptr, j, *pred_succs) {
                if (j->val == loop->header) {
                    j->val = &pre_header;
                    break;
                }
            }
        }
    }
    
    // 4.3 添加pre-header到header的边
    List_IR_block_ptr *pre_header_succs = VCALL(func->blk_succ, get, &pre_header);
    List_IR_block_ptr_push_back(pre_header_succs, loop->header);
    
    // 4.4 更新header的前驱
    List_IR_block_ptr_clear(header_preds);
    List_IR_block_ptr_push_back(header_preds, &pre_header);
    
    // 5. 清理资源
    List_IR_stmt_ptr_teardown(&stmts_to_move);
}

static void LoopAnalysis_print_result(LoopAnalysis *t, IR_function *func) {
    printf("Function %s: Loop Invariant Code Motion Result\n", func->func_name);
    for_list(Loop_ptr, i, t->loops) {
        Loop *loop = i->val;
        printf("=================\n");
        printf("Loop Header: %p\n", loop->header);
        printf("Loop Body: ");
        for_set(IR_block, blk, *loop->body)
            printf("%p ", &blk->key);
        printf("\n");
        printf("Loop Exits: ");
        for_set(IR_block, blk, *loop->exits)
            printf("%p ", &blk->key);
        printf("\n");
        printf("Invariant Variables: ");
        for_set(IR_var, var, *loop->invariant_vars)
            printf("v%u ", var->key);
        printf("\n");
        printf("=================\n");
    }
}

void LoopAnalysis_init(LoopAnalysis *t) {
    const static struct LoopAnalysis_virtualTable vTable = {
            .teardown = LoopAnalysis_teardown,
            .analyze_loops = LoopAnalysis_analyze_loops,
            .identify_invariants = LoopAnalysis_identify_invariants,
            .motion_invariants = LoopAnalysis_motion_invariants,
            .printResult = LoopAnalysis_print_result
    };
    t->vTable = &vTable;
    List_Loop_ptr_init(&t->loops);
}

//// ============================ Optimize ============================

void loop_invariant_code_motion(IR_function *func) {
    LoopAnalysis analysis;
    LoopAnalysis_init(&analysis);
    
    // 分析循环
    VCALL(analysis, analyze_loops, func);
    
    // 对每个循环进行优化
    for_list(Loop_ptr, i, analysis.loops) {
        Loop *loop = i->val;
        // 识别循环不变代码
        VCALL(analysis, identify_invariants, loop);
        // 移动循环不变代码
        VCALL(analysis, motion_invariants, loop, func);
    }
    
    // 打印结果
    VCALL(analysis, printResult, func);
    
    // 清理资源
    LoopAnalysis_teardown(&analysis);
} 