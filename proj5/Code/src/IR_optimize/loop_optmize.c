#include <loop_optimize.h>
#include <IR.h>

//// ============================ Loop Analysis ============================

void LoopAnalysis_analyze_loops(LoopAnalysis *t, IR_function *func) {
    // 使用深度优先搜索找到所有回边
    for_list(IR_block_ptr, blk, func->blocks) {
        IR_block *current = blk->val;
        List_IR_block_ptr *preds = VCALL(func->blk_pred, get, current);
        for_list(IR_block_ptr, pred, *preds) {
            IR_block *pred_block = pred->val;
            
            // 检查每个前驱是否形成回边
            if (pred_block->label > current->label) {  // 回边的目标节点必须支配源节点
                // 找到回边 pred -> header
                IR_block *header = current;
                IR_block *tail = pred_block;
                
                // 创建新的循环结构
                Loop *loop = (Loop *)malloc(sizeof(Loop));
                loop->header = header;
                Set_IR_block_ptr_init(&loop->body);
                Set_IR_block_ptr_init(&loop->exits);
                Set_IR_var_init(&loop->invariant_vars);
                
                // 使用DFS找到循环体中的所有基本块
                Set_IR_block_ptr visited;
                Set_IR_block_ptr_init(&visited);
                VCALL(visited, insert, tail);
                VCALL(loop->body, insert, tail);
                
                // DFS遍历找到所有循环体中的块
                List_IR_block_ptr stack;
                List_IR_block_ptr_init(&stack);
                VCALL(stack, push_back, tail);
                
                while (stack.head != NULL) {  // 使用head指针判断是否为空
                    IR_block *current_blk = stack.tail->val;  // 获取栈顶元素
                    VCALL(stack, pop_back);  // 弹出栈顶元素
                    
                    List_IR_block_ptr *preds = VCALL(func->blk_pred, get, current_blk);
                    for_list(IR_block_ptr, pred, *preds) {
                        IR_block *pred_blk = pred->val;
                        if (!VCALL(visited, exist, pred_blk)) {  // 使用exist替代contains
                            VCALL(visited, insert, pred_blk);
                            VCALL(loop->body, insert, pred_blk);
                            VCALL(stack, push_back, pred_blk);
                        }
                    }
                }
                
                // 找到循环出口
                for_set(IR_block_ptr, body_blk, loop->body) {
                    List_IR_block_ptr *succs = VCALL(func->blk_succ, get, body_blk->key);
                    for_list(IR_block_ptr, succ, *succs) {
                        IR_block *succ_blk = succ->val;
                        if (!VCALL(loop->body, exist, succ_blk)) {  // 使用exist替代contains
                            VCALL(loop->exits, insert, succ_blk);
                        }
                    }
                }
                
                // 将循环添加到分析器中
                List_Loop_ptr_push_back(&t->loops, loop);
            }
        }
    }
}

void LoopAnalysis_identify_invariants(LoopAnalysis *t, Loop *loop) {
    // 1. 收集循环中所有变量的定义和使用
    Map_IR_var_IR_block_ptr def_blocks;  // 变量定义所在的块
    Map_IR_var_IR_block_ptr_init(&def_blocks);
    
    Map_IR_var_Set_IR_block_ptr use_blocks;  // 变量使用所在的块集合
    Map_IR_var_Set_IR_block_ptr_init(&use_blocks);
    
    // 遍历循环体中的所有基本块
    for_set(IR_block_ptr, blk, loop->body) {
        IR_block *block = blk->key;
        // 遍历块中的所有语句
        for_list(IR_stmt_ptr, stmt, block->stmts) {
            IR_stmt *s = stmt->val;
            if (s->dead) continue;  // 跳过死代码
            
            // 获取语句的定义变量
            IR_var def = s->vTable->get_def(s);
            if (def != IR_VAR_NONE) {
                // 记录定义块
                VCALL(def_blocks, set, def, block);
            }
            
            // 获取语句使用的变量
            IR_use use = s->vTable->get_use_vec(s);
            for (unsigned i = 0; i < use.use_cnt; i++) {
                if (use.use_vec[i].is_const) continue;  // 跳过常量
                IR_var use_var = use.use_vec[i].var;
                
                // 初始化使用块集合（如果不存在）
                if (!VCALL(use_blocks, exist, use_var)) {
                    Set_IR_block_ptr use_set;
                    Set_IR_block_ptr_init(&use_set);
                    VCALL(use_blocks, set, use_var, use_set);
                }
                // 添加使用块
                Set_IR_block_ptr use_set = VCALL(use_blocks, get, use_var);
                VCALL(use_set, insert, block);
            }
        }
    }
    
    // 2. 检查每个变量是否满足循环不变条件
    for_map(IR_var, IR_block_ptr, def_it, def_blocks) {
        IR_var var = def_it->key;
        IR_block *def_block = def_it->val;
        
        // 条件1: 变量在循环外定义
        if (!VCALL(loop->body, exist, def_block)) {
            // 条件2: 定义块支配所有出口块
            bool dominates_all_exits = true;
            for_set(IR_block_ptr, exit_blk, loop->exits) {
                if (!VCALL(loop->body, exist, exit_blk->key)) {
                    dominates_all_exits = false;
                    break;
                }
            }
            
            if (dominates_all_exits) {
                // 条件3: 循环内没有其他定义
                bool single_def = true;
                for_set(IR_block_ptr, blk, loop->body) {
                    if (VCALL(def_blocks, exist, var) && 
                        VCALL(def_blocks, get, var) != def_block) {
                        single_def = false;
                        break;
                    }
                }
                
                if (single_def) {
                    // 条件4: 定义块支配所有使用块
                    bool dominates_all_uses = true;
                    if (VCALL(use_blocks, exist, var)) {
                        Set_IR_block_ptr use_set = VCALL(use_blocks, get, var);
                        for_set(IR_block_ptr, use_blk, use_set) {
                            if (!VCALL(loop->body, exist, use_blk->key)) {
                                dominates_all_uses = false;
                                break;
                            }
                        }
                    }
                    
                    // 满足所有条件，添加到不变变量集合
                    if (dominates_all_uses) {
                        VCALL(loop->invariant_vars, insert, var);
                    }
                }
            }
        }
    }
}

void LoopAnalysis_motion_invariants(LoopAnalysis *t, Loop *loop, IR_function *func) {
    // 1. 在循环头前创建新的基本块
    IR_label pre_header_label = ir_label_generator();
    IR_block *pre_header = (IR_block *)malloc(sizeof(IR_block));
    IR_block_init(pre_header, pre_header_label);
    VCALL(func->map_blk_label, set, pre_header_label, pre_header);
    
    // 2. 收集需要移动的语句
    List_IR_stmt_ptr stmts_to_move;
    List_IR_stmt_ptr_init(&stmts_to_move);
    
    for_set(IR_block_ptr, blk, loop->body) {
        IR_block *block = blk->key;
        for_list(IR_stmt_ptr, stmt, block->stmts) {
            IR_stmt *s = stmt->val;
            if (s->dead) continue;  // 跳过死代码
            
            // 获取语句的定义变量
            IR_var def = s->vTable->get_def(s);
            if (def != IR_VAR_NONE && VCALL(loop->invariant_vars, exist, def)) {
                // 将语句添加到待移动列表
                VCALL(stmts_to_move, push_back, s);
                // 标记原语句为死代码
                s->dead = true;
            }
        }
    }
    
    // 3. 移动语句到pre-header
    for_list(IR_stmt_ptr, stmt, stmts_to_move) {
        IR_stmt *s = stmt->val;
        VCALL(pre_header->stmts, push_back, s);
    }
    
    // 4. 更新控制流图
    // 4.1 找到循环头的所有前驱
    List_IR_block_ptr *header_preds = VCALL(func->blk_pred, get, loop->header);
    List_IR_block_ptr new_preds;
    List_IR_block_ptr_init(&new_preds);
    
    // 4.2 更新前驱到pre-header的边
    for_list(IR_block_ptr, pred, *header_preds) {
        IR_block *pred_block = pred->val;
        if (!VCALL(loop->body, exist, pred_block)) {
            // 如果前驱不在循环体内，将其指向pre-header
            VCALL(new_preds, push_back, pred_block);
            
            // 更新前驱的后继
            List_IR_block_ptr *pred_succs = VCALL(func->blk_succ, get, pred_block);
            List_IR_block_ptr new_succs;
            List_IR_block_ptr_init(&new_succs);
            
            // 复制所有后继，但将header替换为pre-header
            for_list(IR_block_ptr, succ, *pred_succs) {
                if (succ->val == loop->header) {
                    VCALL(new_succs, push_back, pre_header);
                } else {
                    VCALL(new_succs, push_back, succ->val);
                }
            }
            
            // 更新前驱的后继列表
            VCALL(func->blk_succ, set, pred_block, &new_succs);
        }
    }
    
    // 4.3 更新header的前驱
    List_IR_block_ptr header_preds_new;
    List_IR_block_ptr_init(&header_preds_new);
    VCALL(header_preds_new, push_back, pre_header);
    
    // 4.4 更新pre-header的后继
    List_IR_block_ptr pre_header_succs;
    List_IR_block_ptr_init(&pre_header_succs);
    VCALL(pre_header_succs, push_back, loop->header);
    
    // 4.5 更新控制流图
    VCALL(func->blk_pred, set, loop->header, &header_preds_new);
    VCALL(func->blk_pred, set, pre_header, &new_preds);
    VCALL(func->blk_succ, set, pre_header, &pre_header_succs);
}

void LoopAnalysis_print_result(LoopAnalysis *t, IR_function *func) {
    printf("Function %s: Loop Invariant Code Motion Result\n", func->func_name);
    for_list(Loop_ptr, i, t->loops) {
        Loop *loop = i->val;
        printf("=================\n");
        printf("Loop Header: %p\n", loop->header);
        printf("Loop Body: ");
        for_set(IR_block_ptr, blk, loop->body)
            printf("%p ", blk->key);
        printf("\n");
        printf("Loop Exits: ");
        for_set(IR_block_ptr, blk, loop->exits)
            printf("%p ", blk->key);
        printf("\n");
        printf("Invariant Variables: ");
        for_set(IR_var, var, loop->invariant_vars)
            printf("v%u ", var->key);
        printf("\n");
        printf("=================\n");
    }
}

void LoopAnalysis_init(LoopAnalysis *t) {
    List_Loop_ptr_init(&t->loops);
    List_InductionVar_init(&t->induction_vars);
    Map_IR_var_IR_var_init(&t->base_to_derived);
}

//// ============================ Optimize ============================

// 检查变量是否是归纳变量
static bool is_induction_var(IR_var var, Loop *loop, IR_function *func) {
    // 1. 检查变量在循环中的定义
    Set_IR_block_ptr def_blocks;
    Set_IR_block_ptr_init(&def_blocks);
    
    // 遍历循环体中的所有基本块
    for_set(IR_block_ptr, blk, loop->body) {
        IR_block *block = blk->key;
        // 遍历块中的所有语句
        for_list(IR_stmt_ptr, stmt, block->stmts) {
            IR_stmt *s = stmt->val;
            if (s->dead) continue;  // 跳过死代码
            
            // 获取语句的定义变量
            IR_var def = s->vTable->get_def(s);
            if (def == var) {
                VCALL(def_blocks, insert, block);
            }
        }
    }
    
    // 2. 检查定义是否满足条件
    // 2.1 变量在循环中只有一个定义
    bool has_single_def = false;
    IR_block *def_block = NULL;
    for_set(IR_block_ptr, blk, def_blocks) {
        if (!has_single_def) {
            has_single_def = true;
            def_block = blk->key;
        } else {
            has_single_def = false;
            break;
        }
    }
    
    if (!has_single_def || def_block == NULL) {
        VCALL(def_blocks, teardown);
        return false;
    }
    
    // 2.2 检查定义语句是否是 a = a + c 的形式
    bool is_induction = false;
    for_list(IR_stmt_ptr, stmt, def_block->stmts) {
        IR_stmt *s = stmt->val;
        if (s->dead) continue;
        
        IR_var def = s->vTable->get_def(s);
        if (def == var) {
            // 检查是否是加法操作
            if (s->stmt_type == IR_OP_STMT) {
                IR_op_stmt *op_stmt = (IR_op_stmt *)s;
                if (op_stmt->op == IR_OP_ADD) {
                    // 检查是否是 a = a + c 的形式
                    if (op_stmt->rs1.is_const && op_stmt->rs2.var == var) {
                        is_induction = true;
                    } else if (op_stmt->rs2.is_const && op_stmt->rs1.var == var) {
                        is_induction = true;
                    }
                }
            }
            break;
        }
    }
    
    VCALL(def_blocks, teardown);
    return is_induction;
}

void LoopAnalysis_identify_induction_vars(LoopAnalysis *t, Loop *loop) {
    // 1. 识别基础归纳变量
    for_set(IR_block_ptr, blk, loop->body) {
        IR_block *block = blk->key;
        for_list(IR_stmt_ptr, stmt, block->stmts) {
            IR_stmt *s = stmt->val;
            if (s->dead) continue;
            
            if (s->stmt_type == IR_OP_STMT) {
                IR_op_stmt *op_stmt = (IR_op_stmt *)s;
                if (op_stmt->op == IR_OP_ADD && 
                    op_stmt->rs1.var == op_stmt->rd && 
                    op_stmt->rs2.is_const) {
                    // 找到基础归纳变量
                    IR_var base_var = op_stmt->rd;
                    if (is_induction_var(base_var, loop, NULL)) {
                        // 创建归纳变量结构
                        InductionVar ind_var;
                        ind_var.base_var = base_var;
                        ind_var.derived_var = base_var;
                        ind_var.multiplier = 1;
                        ind_var.constant = op_stmt->rs2.const_val;
                        Set_IR_block_ptr_init(&ind_var.def_blocks);
                        Set_IR_block_ptr_init(&ind_var.use_blocks);
                        
                        // 添加到分析器中
                        VCALL(t->induction_vars, push_back, ind_var);
                        VCALL(t->base_to_derived, set, base_var, base_var);
                    }
                }
            }
        }
    }
    
    // 2. 识别派生归纳变量
    for_set(IR_block_ptr, blk, loop->body) {
        IR_block *block = blk->key;
        for_list(IR_stmt_ptr, stmt, block->stmts) {
            IR_stmt *s = stmt->val;
            if (s->dead) continue;
            
            if (s->stmt_type == IR_OP_STMT) {
                IR_op_stmt *op_stmt = (IR_op_stmt *)s;
                if (op_stmt->op == IR_OP_MUL || op_stmt->op == IR_OP_ADD) {
                    // 检查是否使用了基础归纳变量
                    IR_var base_var = IR_VAR_NONE;
                    int multiplier = 1;
                    int constant = 0;
                    
                    if (!op_stmt->rs1.is_const && 
                        VCALL(t->base_to_derived, exist, op_stmt->rs1.var)) {
                        base_var = VCALL(t->base_to_derived, get, op_stmt->rs1.var);
                        if (op_stmt->rs2.is_const) {
                            multiplier = op_stmt->rs2.const_val;
                        }
                    } else if (!op_stmt->rs2.is_const && 
                             VCALL(t->base_to_derived, exist, op_stmt->rs2.var)) {
                        base_var = VCALL(t->base_to_derived, get, op_stmt->rs2.var);
                        if (op_stmt->rs1.is_const) {
                            multiplier = op_stmt->rs1.const_val;
                        }
                    }
                    
                    if (base_var != IR_VAR_NONE) {
                        // 创建派生归纳变量
                        InductionVar ind_var;
                        ind_var.base_var = base_var;
                        ind_var.derived_var = op_stmt->rd;
                        ind_var.multiplier = multiplier;
                        ind_var.constant = constant;
                        Set_IR_block_ptr_init(&ind_var.def_blocks);
                        Set_IR_block_ptr_init(&ind_var.use_blocks);
                        
                        // 添加到分析器中
                        VCALL(t->induction_vars, push_back, ind_var);
                        VCALL(t->base_to_derived, set, op_stmt->rd, base_var);
                    }
                }
            }
        }
    }
}

void LoopAnalysis_reduce_strength(LoopAnalysis *t, Loop *loop, IR_function *func) {
    // 对每个归纳变量进行强度削减
    for_list(InductionVar, ind_var_it, t->induction_vars) {
        InductionVar *ind_var = &ind_var_it->val;
        
        // 跳过基础归纳变量
        if (ind_var->base_var == ind_var->derived_var) {
            continue;
        }
        
        // 1. 在循环头前创建新的基本块
        IR_label pre_header_label = ir_label_generator();
        IR_block *pre_header = (IR_block *)malloc(sizeof(IR_block));
        IR_block_init(pre_header, pre_header_label);
        VCALL(func->map_blk_label, set, pre_header_label, pre_header);
        
        // 2. 创建初始化和更新语句
        // 初始化语句：derived_var = base_var * multiplier + constant
        IR_op_stmt *init_stmt = (IR_op_stmt *)malloc(sizeof(IR_op_stmt));
        IR_op_stmt_init(init_stmt, IR_OP_MUL, ind_var->derived_var,
                       (IR_val){.is_const = false, .var = ind_var->base_var},
                       (IR_val){.is_const = true, .const_val = ind_var->multiplier});
        
        VCALL(pre_header->stmts, push_back, (IR_stmt *)init_stmt);
        
        if (ind_var->constant != 0) {
            IR_op_stmt *add_stmt = (IR_op_stmt *)malloc(sizeof(IR_op_stmt));
            IR_op_stmt_init(add_stmt, IR_OP_ADD, ind_var->derived_var,
                           (IR_val){.is_const = false, .var = ind_var->derived_var},
                           (IR_val){.is_const = true, .const_val = ind_var->constant});
            
            VCALL(pre_header->stmts, push_back, (IR_stmt *)add_stmt);
        }
        
        // 更新语句：derived_var = derived_var + (base_var_increment * multiplier)
        IR_op_stmt *update_stmt = (IR_op_stmt *)malloc(sizeof(IR_op_stmt));
        IR_op_stmt_init(update_stmt, IR_OP_ADD, ind_var->derived_var,
                       (IR_val){.is_const = false, .var = ind_var->derived_var},
                       (IR_val){.is_const = true, .const_val = ind_var->multiplier});
        
        // 4. 在循环体中插入更新语句
        for_set(IR_block_ptr, blk, loop->body) {
            IR_block *block = blk->key;
            for_list(IR_stmt_ptr, stmt, block->stmts) {
                IR_stmt *s = stmt->val;
                if (s->dead) continue;
                
                // 检查是否是基础归纳变量的更新语句
                IR_var def = s->vTable->get_def(s);
                if (def != IR_VAR_NONE && def == ind_var->base_var) {
                    // 在更新语句后插入派生变量的更新语句
                    VCALL(block->stmts, push_back, (IR_stmt *)update_stmt);
                    break;
                }
            }
        }
        
        // 5. 更新控制流图
        List_IR_block_ptr *header_preds = VCALL(func->blk_pred, get, loop->header);
        List_IR_block_ptr new_preds;
        List_IR_block_ptr_init(&new_preds);
        
        // 更新前驱到pre-header的边
        for_list(IR_block_ptr, pred, *header_preds) {
            IR_block *pred_block = pred->val;
            if (!VCALL(loop->body, exist, pred_block)) {
                VCALL(new_preds, push_back, pred_block);
                
                // 更新前驱的后继
                List_IR_block_ptr *pred_succs = VCALL(func->blk_succ, get, pred_block);
                List_IR_block_ptr new_succs;
                List_IR_block_ptr_init(&new_succs);
                
                for_list(IR_block_ptr, succ, *pred_succs) {
                    if (succ->val == loop->header) {
                        VCALL(new_succs, push_back, pre_header);
                    } else {
                        VCALL(new_succs, push_back, succ->val);
                    }
                }
                
                VCALL(func->blk_succ, set, pred_block, &new_succs);
            }
        }
        
        // 更新header的前驱
        List_IR_block_ptr header_preds_new;
        List_IR_block_ptr_init(&header_preds_new);
        VCALL(header_preds_new, push_back, pre_header);
        
        // 更新pre-header的后继
        List_IR_block_ptr pre_header_succs;
        List_IR_block_ptr_init(&pre_header_succs);
        VCALL(pre_header_succs, push_back, loop->header);
        
        // 更新控制流图
        VCALL(func->blk_pred, set, loop->header, &header_preds_new);
        VCALL(func->blk_pred, set, pre_header, &new_preds);
        VCALL(func->blk_succ, set, pre_header, &pre_header_succs);
    }
}

void loop_optimize(IR_function *func) {
    LoopAnalysis analysis;
    LoopAnalysis_init(&analysis);
    
    // 分析循环
    LoopAnalysis_analyze_loops(&analysis, func);
    
    // 对每个循环进行优化
    for_list(Loop_ptr, i, analysis.loops) {
        Loop *loop = i->val;
        // 识别循环不变代码
        LoopAnalysis_identify_invariants(&analysis, loop);
        // 移动循环不变代码
        LoopAnalysis_motion_invariants(&analysis, loop, func);
        // 识别归纳变量
        LoopAnalysis_identify_induction_vars(&analysis, loop);
        // 进行强度削减
        LoopAnalysis_reduce_strength(&analysis, loop, func);
    }
    
    // 打印结果
    LoopAnalysis_print_result(&analysis, func);
} 