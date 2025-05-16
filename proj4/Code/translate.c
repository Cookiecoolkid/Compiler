#include "translate.h"
#include "semantic.h"
#include "node.h"
#include "rb_tree.h"
#include "command.h"
#include <assert.h>
#include <stdio.h>

// 全局符号表实例，在语义检查的时候已经得到函数定义与结构体定义
extern SymbolTable symTable;

// 对于所有的语法结构：只有 Stmt && *Dec && Exp && Args && Condition 需要进行 command 翻译.

void translate_program(Node *root, FILE *file) {
    // Program: ExtDefList
    Node *node = root;
    assert(root != NULL && root->child != NULL);
    Node *extDefList = root->child;

    translate_extDefList(extDefList, file);
}

void translate_extDefList(Node *extDefList, FILE *file) {
    // ExtDefList: ExtDef ExtDefList | empty
    assert(extDefList != NULL);
    if (extDefList->child == NULL) return;

    Node *extDef = extDefList->child;
    Node *nextExtDefList = extDef->next;

    translate_extDef(extDef, file);
    translate_extDefList(nextExtDefList, file);
}

void translate_extDef(Node *extDef, FILE *file) {
    // ExtDef: Specifier ExtDecList SEMI
    //        | Specifier SEMI
    //        | Specifier FunDec CompSt
    //        | Specifier FunDec SEMI
    assert(extDef != NULL);
    Node *specifier = extDef->child;
    Node *secondChild = specifier->next;
    Type type = translate_specifier(specifier, file);
    if (secondChild->next == NULL) {
        // Specifier SEMI
        return;
    }
    Node *thirdChild = secondChild->next;
    if (strcmp(secondChild->name, "ExtDecList") == 0) {
        translate_extDecList(secondChild, file, type);
    } else if (strcmp(thirdChild->name, "CompSt") == 0) {
        translate_funDec(secondChild, file);
        Type funcType = search(secondChild->child->value.value.str_val, true)->symbol->type;
        translate_compSt(thirdChild, file, funcType);
    } else {
        translate_funDec(secondChild, file);
    }
}

Type translate_specifier(Node *specifier, FILE *file) {
    // Specifier: TYPE | StructSpecifier
    assert(specifier != NULL);
    Node *child = specifier->child;
    if (strcmp(child->name, "TYPE") == 0) {
        // Basic type
        Type type = (Type)malloc(sizeof(struct Type_));
        type->kind = BASIC;
        char *typeName = child->value.value.str_val;
        if (strcmp(typeName, "int") == 0) {
            type->u.basic = INT_;
        } else if (strcmp(typeName, "float") == 0){
            type->u.basic = FLOAT_;
        } else {
            assert(0);
        }
        return type;
    } else {
        // StructSpecifier
        // Return Basic or Structure type
        // Already insert struct define member in semantic.c so return NULL means do nothing
        // Only return type when it is a struct local/global variable, return its BASIC type
        return translate_structSpecifier(child, file);
    }
}

void translate_extDecList(Node *extDecList, FILE *file, Type type) {
    // ExtDecList: VarDec
    //            | VarDec COMMA ExtDecList
    assert(extDecList != NULL);
    Node *varDec = extDecList->child;
    translate_varDec(varDec, file, type);
    if (varDec->next != NULL) {
        translate_extDecList(varDec->next->next, file, type);
    }
}

void translate_funDec(Node *funDec, FILE *file) {
    // FunDec: ID LP VarList RP | ID LP RP
    assert(funDec != NULL);
    Node *idNode = funDec->child;
    Node *thirdNode = idNode->next->next;

    char *funcName = idNode->value.value.str_val;

    operand funcOp = create_operand(NULL_VALUE, funcName, FUNCTION_NAME, VAL);
    command funcCmd = create_command(FUNCTION_OP, NULL_OP, NULL_OP, funcOp, NULL_RELOP);
    append_command_to_file(funcCmd, file);

    if (thirdNode->next == NULL) {
        // ID LP RP
        return;
    }
    // ID LP VarList RP
    // Node *varList = thirdNode;
    // translate_varList(varList, file);

    // Directly translate VarList by SymTable
    RBNode funcNode = search(funcName, true);
    if (funcNode == NULL) assert(0);
    Type funcType = funcNode->symbol->type;
    FieldList params = funcType->u.function.params;
    while (params != NULL) {
        // ParamDec
        // FIXME
        operand param = create_operand(NULL_VALUE, params->name, VARIABLE, VAL);
        command paramCmd = create_command(PARAM, NULL_OP, NULL_OP, param, NULL_RELOP);
        append_command_to_file(paramCmd, file);

        params = params->tail;
    }
}

void translate_compSt(Node *compSt, FILE *file, Type funcType) {
    // CompSt: LC DefList StmtList RC
    assert(compSt != NULL);

    // 进入新的作用域
    enterScope();

    if (funcType != NULL && funcType->kind == FUNCTION) {
        // Insert parameters into symbol table
        FieldList params = funcType->u.function.params;
        while (params != NULL) {
            Symbol symbol = createSymbol(params->name, params->type);
            symbol->isParam = true;
            insert(symbol);
            params = params->tail;
        }
    }

    Node *defList = compSt->child->next;
    Node *stmtList = defList->next;
    translate_defList(defList, file);
    translate_stmtList(stmtList, file, funcType);

    // 退出当前作用域
    exitScope();
}

operand translate_varDec(Node *varDec, FILE *file, Type type) {
    if (varDec == NULL) return NULL_OP;
    
    // 原有的代码生成逻辑
    Node *idNode = varDec->child;
    if (idNode->next == NULL) {
        // ID
        // Struct Define, do nothing
        if (type == NULL) return NULL_OP;

        // 获取变量名
        char* varName = varDec->child->value.value.str_val;
        
        // 插入符号表
        Symbol symbol = createSymbol(varName, type);
        insert(symbol);

        assert(type->kind == BASIC || type->kind == ARRAY);
        operand op;
        if (type->kind == BASIC) {
            if (type->u.basic <= 1) {
                // INT/FLOAT VARIABLE
                // Only struct & function output DEC command
                op = create_operand(INT_FLOAT_SIZE, varName, VARIABLE, VAL);
            } else {
                // Struct
                char structName[256];
                snprintf(structName, sizeof(structName), "%d", type->u.basic);
                RBNode structVar = search(structName, true);
                if (structVar == NULL) assert(0);
                int size_ = calculateTypeSize(structVar->symbol->type);
                op = create_operand(size_, varName, VARIABLE, VAL);
                command structCmd = create_command(DEC, NULL_OP, NULL_OP, op, NULL_RELOP);
                append_command_to_file(structCmd, file);
            }
        } else {
            // ARRAY type
            int size_ = calculateTypeSize(type);
            op = create_operand(size_, varName, VARIABLE, ADDRESS);
            command arrayCmd = create_command(DEC, NULL_OP, NULL_OP, op, NULL_RELOP);
            append_command_to_file(arrayCmd, file);
        }
        return op;
    }
    Node *varDec_child = idNode;
    Node *thirdNode = idNode->next->next;
    // VarDec LB INT RB
    assert(thirdNode != NULL);
    int size_ = thirdNode->value.value.int_val;
    
    // 创建数组类型
    Type arrayType = (Type)malloc(sizeof(struct Type_));
    arrayType->kind = ARRAY;
    arrayType->u.array.elem = type;
    arrayType->u.array.size = size_;
    
    operand op = translate_varDec(varDec_child, file, arrayType);
    operand res_op = op;
    res_op->value = size_ * op->value;
    // if (!inRecursion) {
    //     command decCmd = create_command(DEC, NULL_OP, NULL_OP, op, NULL_RELOP);
    //     append_command_to_file(decCmd, file);
    // }

    return res_op;
}

Type translate_structSpecifier(Node *structSpecifier, FILE *file) {
    // StructSpecifier: STRUCT OptTag LC DefList RC | STRUCT Tag
    
    // Only return type when it is a struct local/global variable, return its BASIC type, otherwise NULL.
    // Do Nothing
    assert(structSpecifier != NULL);
    int childNum = get_child_num(structSpecifier);
    if (childNum != 2) return NULL;
    Node *TagNode = structSpecifier->child->next;
    assert(strcmp(TagNode->name, "Tag") == 0);
    // Tag -> ID
    Node *idNode = TagNode->child;
    assert(idNode != NULL);
    char *structName = idNode->value.value.str_val;
    RBNode result = search(structName, true);
    assert(result != NULL);
    int structID = result->symbol->type->u.structure.ID;
    Type type = (Type)malloc(sizeof(struct Type_));
    type->kind = BASIC;
    type->u.basic = structID;

    return type;
}

void translate_optTag(Node *optTag, FILE *file) {
    // OptTag: ID | empty

    // Do Nothing
    assert(optTag != NULL);
    if (optTag->child == NULL) return;
    Node *idNode = optTag->child;
}

void translate_tag(Node *tag, FILE *file) {
    // Tag: ID

    // Struct Type name, do nothing for translation
    assert(tag != NULL);
    Node *idNode = tag->child;
}

void translate_defList(Node *defList, FILE *file) {
    // DefList: Def DefList | empty
    assert(defList != NULL);
    if (defList->child == NULL) return;

    Node *def = defList->child;
    Node *nextDefList = def->next;

    translate_def(def, file);
    translate_defList(nextDefList, file);
}

void translate_def(Node *def, FILE *file) {
    // Def: Specifier DecList SEMI
    assert(def != NULL);
    Node *specifier = def->child;
    Node *decList = specifier->next;
    Type type = translate_specifier(specifier, file);
    translate_decList(decList, file, type);
}

void translate_decList(Node *decList, FILE *file, Type type) {
    // DecList: Dec | Dec COMMA DecList
    assert(decList != NULL);
    Node *dec = decList->child;
    translate_dec(dec, file, type);
    if (dec->next != NULL) {
        translate_decList(dec->next->next, file, type);
    }
}

void translate_dec(Node *dec, FILE *file, Type type) {
    // Dec: VarDec | VarDec ASSIGNOP Exp
    assert(dec != NULL);
    Node *varDec = dec->child;
    if (varDec->next == NULL) {
        // VarDec
        translate_varDec(varDec, file, type);
        return;
    }
    // VarDec ASSIGNOP Exp
    Node *exp = varDec->next->next;
    operand res = translate_varDec(varDec, file, type);
    operand expOp = translate_exp(exp, file);
    command assignCmd = create_command(ASSIGN, expOp, NULL_OP, res, NULL_RELOP);
    append_command_to_file(assignCmd, file);
}

// void translate_varList(Node *varList, FILE *file) {
//     // VarList: ParamDec COMMA VarList | ParamDec
//     assert(varList != NULL);
//     Node *paramDec = varList->child;
//     translate_paramDec(paramDec, file);
//     if (paramDec->next != NULL) {
//         translate_varList(paramDec->next->next, file);
//     }
// }

// void translate_paramDec(Node *paramDec, FILE *file) {
//     // ParamDec: Specifier VarDec
//     assert(paramDec != NULL);
//     Node *specifier = paramDec->child;
//     Node *varDec = specifier->next;
    
//     // translate_specifier(specifier, file);
//     operand op = translate_varDec(varDec, file, false);
//     command paramCmd = create_command(PARAM, NULL_OP, NULL_OP, op, NULL_RELOP);
//     append_command_to_file(paramCmd, file);
// }

void translate_stmtList(Node *stmtList, FILE *file, Type funcType) {
    // StmtList: Stmt StmtList | empty
    assert(stmtList != NULL);
    if (stmtList->child == NULL) return;

    Node *stmt = stmtList->child;
    Node *nextStmtList = stmt->next;

    translate_stmt(stmt, file, funcType);
    translate_stmtList(nextStmtList, file, funcType);
}

void translate_stmt(Node *stmt, FILE *file, Type funcType) {
    // Stmt: Exp SEMI | CompSt | RETURN Exp SEMI | IF LP Exp RP Stmt
    //      | IF LP Exp RP Stmt ELSE Stmt | WHILE LP Exp RP Stmt
    assert(stmt != NULL);
    Node *child = stmt->child;
    if (strcmp(child->name, "Exp") == 0) {
        // Exp SEMI
        translate_exp(child, file);

    } else if (strcmp(child->name, "CompSt") == 0) {
        // CompSt
        translate_compSt(child, file, funcType);

    } else if (strcmp(child->name, "RETURN") == 0) {
        // RETURN Exp SEMI
        Node *exp = child->next;
        operand returnOp = translate_exp(exp, file);
        command returnCmd = create_command(RETURN_OP, NULL_OP, NULL_OP, returnOp, NULL_RELOP);
        append_command_to_file(returnCmd, file);

    } else if (strcmp(child->name, "IF") == 0) {
        Node *exp = child->next->next;
        Node *stmt1 = exp->next->next;
        if (stmt1->next != NULL && stmt1->next->next != NULL) {
            // IF LP Exp RP Stmt ELSE Stmt
            Node *stmt2 = stmt1->next->next;
            operand label1 = create_operand(NULL_VALUE, NULL, LABEL_NAME, VAL);
            operand label2 = create_operand(NULL_VALUE, NULL, LABEL_NAME, VAL);
            operand label3 = create_operand(NULL_VALUE, NULL, LABEL_NAME, VAL);
            translate_cond(exp, file, label1, label2);

            command label1Cmd = create_command(LABEL, NULL_OP, NULL_OP, label1, NULL_RELOP);
            append_command_to_file(label1Cmd, file);

            translate_stmt(stmt1, file, funcType);

            bool isElseReturn = false;
            if (stmt2->child != NULL && strcmp(stmt2->child->name, "RETURN") == 0) {
                isElseReturn = true;
            }
            if (!isElseReturn) {
                command gotoCmd = create_command(GOTO, NULL_OP, NULL_OP, label3, NULL_RELOP);
                append_command_to_file(gotoCmd, file);
            }

            command label2Cmd = create_command(LABEL, NULL_OP, NULL_OP, label2, NULL_RELOP);
            append_command_to_file(label2Cmd, file);

            translate_stmt(stmt2, file, funcType);

            if (!isElseReturn) {
                command label3Cmd = create_command(LABEL, NULL_OP, NULL_OP, label3, NULL_RELOP);
                append_command_to_file(label3Cmd, file);
            }
        } else {
            // IF LP Exp RP Stmt
            operand label1 = create_operand(NULL_VALUE, NULL, LABEL_NAME, VAL);
            operand label2 = create_operand(NULL_VALUE, NULL, LABEL_NAME, VAL);
            translate_cond(exp, file, label1, label2);

            command label1Cmd = create_command(LABEL, NULL_OP, NULL_OP, label1, NULL_RELOP);
            append_command_to_file(label1Cmd, file);

            translate_stmt(stmt1, file, funcType);

            command label2Cmd = create_command(LABEL, NULL_OP, NULL_OP, label2, NULL_RELOP);
            append_command_to_file(label2Cmd, file);
        }
    } else if (strcmp(child->name, "WHILE") == 0) {
        // WHILE LP Exp RP Stmt
        Node *exp = child->next->next;
        Node *stmt = exp->next->next;

        operand label1 = create_operand(NULL_VALUE, NULL, LABEL_NAME, VAL);
        operand label2 = create_operand(NULL_VALUE, NULL, LABEL_NAME, VAL);
        operand label3 = create_operand(NULL_VALUE, NULL, LABEL_NAME, VAL);

        command label1Cmd = create_command(LABEL, NULL_OP, NULL_OP, label1, NULL_RELOP);
        append_command_to_file(label1Cmd, file);

        translate_cond(exp, file, label2, label3);

        command label2Cmd = create_command(LABEL, NULL_OP, NULL_OP, label2, NULL_RELOP);
        append_command_to_file(label2Cmd, file);

        translate_stmt(stmt, file, funcType);

        command gotoCmd = create_command(GOTO, NULL_OP, NULL_OP, label1, NULL_RELOP);
        append_command_to_file(gotoCmd, file);

        command label3Cmd = create_command(LABEL, NULL_OP, NULL_OP, label3, NULL_RELOP);
        append_command_to_file(label3Cmd, file);
    }
}

void translate_cond(Node *cond, FILE *file, operand label1, operand label2) {
    // Cond: Exp RELOP Exp
    // label1: true label  label2: false label
    assert(cond != NULL);
    int numChild = get_child_num(cond);
    assert(numChild == 3);

    // FIXME 处理嵌套括号的情况
    if (strcmp(cond->child->name, "LP") == 0) {
        translate_cond(cond->child->next, file, label1, label2);
        return;
    }

    Node *exp1 = cond->child;
    Node *node = exp1->next;
    Node *exp2 = node->next;

    if (strcmp(exp1->name, "NOT") == 0) {
        // NOT Exp
        translate_cond(exp1->next, file, label2, label1);
        return;
    }

    if (strcmp(node->name, "RELOP") == 0) {
        // RELOP
        operand op1 = translate_exp(exp1, file);
        operand op2 = translate_exp(exp2, file);

        // if (op1->kind == CONSTANT) {
        //     operand tempOp = create_operand(NULL_VALUE, NULL, TEMP, VAL);
        //     command assignCmd = create_command(ASSIGN, op1, NULL_OP, tempOp, NULL_RELOP);
        //     append_command_to_file(assignCmd, file);
        //     op1 = tempOp;
        // }
        // if (op2->kind == CONSTANT) {
        //     operand tempOp = create_operand(NULL_VALUE, NULL, TEMP, VAL);
        //     command assignCmd = create_command(ASSIGN, op2, NULL_OP, tempOp, NULL_RELOP);
        //     append_command_to_file(assignCmd, file);
        //     op2 = tempOp;
        // }

        char *relop_name = node->value.value.str_val;
        relop relop = str2relop(relop_name);

        //  printf("relop: %s\n", relop_name);

        command ifgotoCmd = create_command(COND_GOTO, op1, op2, label1, relop);
        append_command_to_file(ifgotoCmd, file);

        command gotoLabel2Cmd = create_command(GOTO, NULL_OP, NULL_OP, label2, NULL_RELOP);
        append_command_to_file(gotoLabel2Cmd, file);
    } else if (strcmp(node->name, "AND") == 0) {
        // AND
        operand label = create_operand(NULL_VALUE, NULL, LABEL_NAME, VAL);
        translate_cond(exp1, file, label, label2);

        command labelCmd = create_command(LABEL, NULL_OP, NULL_OP, label, NULL_RELOP);
        append_command_to_file(labelCmd, file);

        translate_cond(exp2, file, label1, label2);
    } else if (strcmp(node->name, "OR") == 0) {
        // OR
        operand label = create_operand(NULL_VALUE, NULL, LABEL_NAME, VAL);
        translate_cond(exp1, file, label1, label);

        command labelCmd = create_command(LABEL, NULL_OP, NULL_OP, label, NULL_RELOP);
        append_command_to_file(labelCmd, file);

        translate_cond(exp2, file, label1, label2);
    } else {
        // others (exp1 != 0)
        operand op1 = translate_exp(exp1, file);
        char *constantName = (char*)malloc(10 * sizeof(char));
        snprintf(constantName, 10, "#%d", 0);
        operand op2 = create_operand(0, constantName, CONSTANT, VAL);

        command ifgotoCmd = create_command(COND_GOTO, op1, op2, label1, NE);

        command gotoLabel2Cmd = create_command(GOTO, NULL_OP, NULL_OP, label2, NULL_RELOP);
        append_command_to_file(gotoLabel2Cmd, file);
    }

}

operand translate_exp(Node *exp, FILE *file) {
    // Exp: Exp ASSIGNOP Exp | Exp AND Exp | Exp OR Exp | Exp RELOP Exp
    //     | Exp PLUS Exp | Exp MINUS Exp | Exp STAR Exp | Exp DIV Exp
    //     | LP Exp RP | ID LP RP | Exp DOT ID | MINUS Exp | NOT Exp
    //     | ID LP Args RP | Exp LB Exp RB | ID | INT | FLOAT
    assert(exp != NULL);
    Node *child = exp->child;

    // 基本情况：处理叶子节点
    if (child->next == NULL) {
        if (strcmp(child->name, "INT") == 0) {
            // 整数常量
            char *constantName = (char*)malloc(10 * sizeof(char));
            snprintf(constantName, 10, "#%d", child->value.value.int_val);
            operand constantOp = create_operand(child->value.value.int_val, constantName, CONSTANT, VAL);
            return constantOp;
        } else if (strcmp(child->name, "FLOAT") == 0) {
            // 浮点数常量
            char *constantName = (char*)malloc(10 * sizeof(char));
            snprintf(constantName, 10, "#%f", child->value.value.float_val);
            operand constantOp = create_operand(child->value.value.float_val, constantName, CONSTANT, VAL);
            return constantOp;
        } else if (strcmp(child->name, "ID") == 0) {
            // 变量引用
            char *name = child->value.value.str_val;
            RBNode var = search(name, false);
            if (var == NULL) assert(0);
            
            Type type = var->symbol->type;
            if (type->kind == BASIC) {
                if (type->u.basic <= 1) {
                    // INT/FLOAT 变量
                    return create_operand(INT_FLOAT_SIZE, name, VARIABLE, VAL);
                } else {
                    // 结构体
                    char structName[256];
                    snprintf(structName, sizeof(structName), "%d", type->u.basic);
                    RBNode structVar = search(structName, true);
                    if (structVar == NULL) assert(0); 
                    
                    int size_ = calculateTypeSize(structVar->symbol->type);
                    operand structOp = create_operand(size_, child->value.value.str_val, VARIABLE, ADDRESS);

                    // 检查是否是函数参数
                    if (var->symbol->isParam) {
                        // 函数参数中的结构体/数组变量已经是ADDR类型
                        return structOp;
                    } else {
                        // 普通结构体变量需要取地址
                        operand addrOp = create_operand(NULL_VALUE, NULL_NAME, TEMP, ADDRESS);
                        command addrCmd = create_command(ADDR, structOp, NULL_OP, addrOp, NULL_RELOP);
                        append_command_to_file(addrCmd, file);
                        return addrOp;
                    }
                }
            } else if (type->kind == ARRAY) {
                // 数组类型
                int size_ = calculateTypeSize(type);
                operand arrayOp = create_operand(size_, name, VARIABLE, ADDRESS);

                // 检查是否是函数参数
                if (var->symbol->isParam) {
                    // 函数参数中的数组变量已经是ADDR类型
                    return arrayOp;
                } else {
                    // 普通数组变量需要取地址
                    operand addrOp = create_operand(NULL_VALUE, NULL_NAME, TEMP, ADDRESS);
                    command addrCmd = create_command(ADDR, arrayOp, NULL_OP, addrOp, NULL_RELOP);
                    append_command_to_file(addrCmd, file);
                    return addrOp;
                }
            } else {
                assert(0); // 不应该有其他类型
            }
        }
    }

    if (child->next != NULL) {
        if (strcmp(child->name, "LP") == 0) {
            // LP Exp RP
            return translate_exp(child->next, file);
        } else if (strcmp(child->name, "MINUS") == 0) {
            // MINUS Exp
            Node *exp1 = child->next;
            operand op = translate_exp(exp1, file);
            operand resOp = create_operand(-op->value, NULL, TEMP, VAL);
            char *constantName = (char*)malloc(10 * sizeof(char));
            snprintf(constantName, 10, "#%d", 0);
            operand zeroOp = create_operand(0, constantName, CONSTANT, VAL);
            command minusCmd = create_command(SUB, zeroOp, op, resOp, NULL_RELOP);
            append_command_to_file(minusCmd, file);
            return resOp;
        }
        Node *secondChild = child->next;

        if (strcmp(secondChild->name, "ASSIGNOP") == 0) {
            // Exp ASSIGNOP Exp
            Node *exp1 = child;
            Node *exp2 = child->next->next;
            operand lhs = translate_exp(exp1, file);
            operand rhs = translate_exp(exp2, file);

            // 检查左边是否是数组访问或结构体成员访问
            if (exp1->child->next != NULL && 
                (strcmp(exp1->child->next->name, "DOT") == 0 || 
                 strcmp(exp1->child->next->name, "LB") == 0)) {
                // 数组访问或结构体成员访问，使用STORE命令
                command storeCmd = create_command(STORE, lhs, rhs, NULL_OP, NULL_RELOP);
                append_command_to_file(storeCmd, file);
            } else {
                // 普通变量赋值
                command assignCmd = create_command(ASSIGN, rhs, NULL_OP, lhs, NULL_RELOP);
                append_command_to_file(assignCmd, file);
            }
            return lhs;
        } 
        if ((strcmp(secondChild->name, "PLUS") == 0) || (strcmp(secondChild->name, "MINUS") == 0) ||
            (strcmp(secondChild->name, "STAR") == 0) || (strcmp(secondChild->name, "DIV") == 0)) {
            // Exp PLUS Exp | Exp MINUS Exp | Exp STAR Exp | Exp DIV Exp
            Node *exp1 = child;
            Node *exp2 = secondChild->next;
            operand op1 = translate_exp(exp1, file);
            operand op2 = translate_exp(exp2, file);
            operand resOp;
            if (strcmp(secondChild->name, "PLUS") == 0) {
                resOp = create_operand(op1->value + op2->value, NULL, TEMP, VAL);
                command plusCmd = create_command(ADD, op1, op2, resOp, NULL_RELOP);
                append_command_to_file(plusCmd, file);
            } else if (strcmp(secondChild->name, "MINUS") == 0) {
                resOp = create_operand(op1->value - op2->value, NULL, TEMP, VAL);
                command minusCmd = create_command(SUB, op1, op2, resOp, NULL_RELOP);
                append_command_to_file(minusCmd, file);
            } else if (strcmp(secondChild->name, "STAR") == 0) {
                resOp = create_operand(op1->value * op2->value, NULL, TEMP, VAL);
                command mulCmd = create_command(MUL, op1, op2, resOp, NULL_RELOP);
                append_command_to_file(mulCmd, file);
            } else if (strcmp(secondChild->name, "DIV") == 0) {
                resOp = create_operand(op1->value / op2->value, NULL, TEMP, VAL);
                command divCmd = create_command(DIV_OP, op1, op2, resOp, NULL_RELOP);
                append_command_to_file(divCmd, file);
            }
            return resOp;
        }
        if ((strcmp(child->name, "NOT") == 0) || (strcmp(secondChild->name, "RELOP") == 0) ||
            (strcmp(secondChild->name, "AND") == 0) || (strcmp(secondChild->name, "OR") == 0)) {
            // NOT Exp | Exp RELOP Exp | Exp AND Exp | Exp OR Exp
            operand label1 = create_operand(NULL_VALUE, NULL, LABEL_NAME, VAL);
            operand label2 = create_operand(NULL_VALUE, NULL, LABEL_NAME, VAL);

            operand resOp = create_operand(NULL_VALUE, NULL, TEMP, VAL);
            char *constantName1 = (char*)malloc(10 * sizeof(char));
            snprintf(constantName1, 10, "#%d", 0);
            operand zeroOp = create_operand(0, constantName1, CONSTANT, VAL);

            command assignOp0 = create_command(ASSIGN, zeroOp, NULL_OP, resOp, NULL_RELOP);
            append_command_to_file(assignOp0, file);

            translate_cond(exp, file, label1, label2);

            char *constantName2 = (char*)malloc(10 * sizeof(char)); 
            snprintf(constantName2, 10, "#%d", 1);
            operand oneOp = create_operand(1, constantName2, CONSTANT, VAL);
            command assignOp1 = create_command(ASSIGN, oneOp, NULL_OP, resOp, NULL_RELOP);
            command label1Cmd = create_command(LABEL, NULL_OP, NULL_OP, label1, NULL_RELOP);
            command label2Cmd = create_command(LABEL, NULL_OP, NULL_OP, label2, NULL_RELOP);

            append_command_to_file(label1Cmd, file);
            append_command_to_file(assignOp1, file);
            append_command_to_file(label2Cmd, file);

            return resOp;
        }
        if (strcmp(secondChild->name, "LP") == 0) {
            if (secondChild->next->next == NULL) {
                // ID LP RP
                char *funcName = child->value.value.str_val;
                RBNode func = search(funcName, true);
                if (func == NULL) assert(0);

                if (strcmp(funcName, "read") == 0) {
                    operand place = create_operand(0, NULL, TEMP, VAL);
                    command readCmd = create_command(READ, NULL_OP, NULL_OP, place, NULL_RELOP);
                    append_command_to_file(readCmd, file);
                    return place;
                } else {
                    operand place = create_operand(0, NULL, TEMP, VAL);
                    operand funcOp = create_operand(NULL_VALUE, funcName, FUNCTION_NAME, VAL);
                    command callCmd = create_command(CALL, funcOp, NULL_OP, place, NULL_RELOP);
                    append_command_to_file(callCmd, file);
                    return place;
                }
            } else {
                // ID LP Args RP
                char *funcName = child->value.value.str_val;
                RBNode func = search(funcName, true);
                if (func == NULL) assert(0);

                Node *args = secondChild->next;
                // WRITE don't need to translate args(write arg)
                if (strcmp(funcName, "write") == 0) {
                    operand arg = translate_exp(args->child, file);
                    command writeCmd = create_command(WRITE, arg, NULL_OP, NULL_OP, NULL_RELOP);
                    append_command_to_file(writeCmd, file);
                    char *constantName = (char*)malloc(10 * sizeof(char));
                    snprintf(constantName, 10, "#%d", 0);
                    operand place = create_operand(0, constantName, CONSTANT, VAL);
                    return place;
                } else {
                    translate_args(args, file);
                    operand place = create_operand(0, NULL, TEMP, VAL);
                    operand funcOp = create_operand(NULL_VALUE, funcName, FUNCTION_NAME, VAL);
                    command callCmd = create_command(CALL, funcOp, NULL_OP, place, NULL_RELOP);
                    append_command_to_file(callCmd, file);
                    return place;
                }
            }
        }
        if (strcmp(secondChild->name, "DOT") == 0) {
            // Exp DOT ID
            Node *idNode = secondChild->next;
            char *fieldName = idNode->value.value.str_val;
            operand structOp = translate_exp(child, file);

            // 如果structOp是VAL类型，需要先取地址
            if (structOp->type == VAL) {
                operand tempAddr = create_operand(NULL_VALUE, NULL_NAME, TEMP, ADDRESS);
                command addrCmd = create_command(ADDR, structOp, NULL_OP, tempAddr, NULL_RELOP);
                append_command_to_file(addrCmd, file);
                structOp = tempAddr;
            }

            Type type = check_exp(child);
            char structName[256];
            snprintf(structName, sizeof(structName), "%d", type->u.basic);
            RBNode structNode = search(structName, true);
            assert(structNode != NULL && structNode->symbol->type->kind == STRUCTURE);
            FieldList members = structNode->symbol->type->u.structure.struct_members;

            int offset = calculateFieldOffset(members, fieldName);
            // ADDRESS + CONSTANT = ADDRESS
            operand temp = create_operand(NULL_VALUE, NULL_NAME, TEMP, ADDRESS);
            char *constantName = (char*)malloc(10 * sizeof(char));
            snprintf(constantName, 10, "#%d", offset);
            operand offsetOp = create_operand(offset, constantName, CONSTANT, VAL);
            command addCmd = create_command(ADD, structOp, offsetOp, temp, NULL_RELOP);
            append_command_to_file(addCmd, file);

            // 如果是赋值语句的左边，直接返回地址
            if (exp->next != NULL && strcmp(exp->next->name, "ASSIGNOP") == 0) {
                return temp;
            }

            // FIXME 处理嵌套 s1.s2.member 情况
            if (exp->next != NULL && strcmp(exp->next->name, "DOT") == 0) {
                return temp;
            }
            
            // 否则需要取操作数
            operand derefOp = create_operand(NULL_VALUE, NULL_NAME, TEMP, VAL);
            command derefCmd = create_command(DEREF, temp, NULL_OP, derefOp, NULL_RELOP);
            append_command_to_file(derefCmd, file);
            return derefOp;
        }
        if (strcmp(secondChild->name, "LB") == 0) {
            // Exp LB Exp RB
            Node *exp1 = child;
            Node *exp2 = secondChild->next;
            operand baseOp = translate_exp(exp1, file);
            operand indexOp = translate_exp(exp2, file);
            
            // 获取数组类型信息
            Type arrayType = check_exp(exp1);
            // 最后一维的基本元素是 BASIC
            assert(arrayType->kind == ARRAY || arrayType->kind == BASIC);
            
            // 计算元素大小
            int elemSize = calculateTypeSize(arrayType->u.array.elem);
            
            // 计算偏移量
            char *constantName = (char*)malloc(10 * sizeof(char));
            snprintf(constantName, 10, "#%d", elemSize);
            operand offsetOp = create_operand(elemSize, constantName, CONSTANT, VAL);
            operand temp1 = create_operand(NULL_VALUE, NULL_NAME, TEMP, VAL);
            command mulCmd = create_command(MUL, indexOp, offsetOp, temp1, NULL_RELOP);
            append_command_to_file(mulCmd, file);
            
            // 计算最终地址
            operand temp2 = create_operand(NULL_VALUE, NULL_NAME, TEMP, ADDRESS);
            command addCmd = create_command(ADD, temp1, baseOp, temp2, NULL_RELOP);
            append_command_to_file(addCmd, file);
            
            // 检查是否在赋值语句的左边
            bool isLValue = (exp->next != NULL && strcmp(exp->next->name, "ASSIGNOP") == 0);
            
            // 如果是多维数组，递归处理
            if (arrayType->u.array.elem->kind == ARRAY) {
                return temp2;
            } else {
                // 最后一维
                if (isLValue) {
                    // 在赋值左边，返回地址用于STORE
                    return temp2;
                } else {
                    // 在赋值右边，需要取数值
                    operand result = create_operand(NULL_VALUE, NULL_NAME, TEMP, VAL);
                    command derefCmd = create_command(DEREF, temp2, NULL_OP, result, NULL_RELOP);
                    append_command_to_file(derefCmd, file);
                    return result;
                }
            }
        }
    }

    return NULL_OP; // 默认返回
}

void translate_args(Node *args, FILE *file) {
    assert(args != NULL);
    Node *exp = args->child;

    if (exp == NULL) return;

    operand argOp = translate_exp(exp, file);
    // // FIXME: 在实验三这里参数传反了
    // command argCmd = create_command(ARG, argOp, NULL_OP, NULL_OP, NULL_RELOP);
    // append_command_to_file(argCmd, file);

    if (exp->next != NULL && strcmp(exp->next->name, "COMMA") == 0) {
        translate_args(exp->next->next, file);
    }

    // FIXME: 应当在这里（否则顺序是错的）
    command argCmd = create_command(ARG, argOp, NULL_OP, NULL_OP, NULL_RELOP);
    append_command_to_file(argCmd, file);
}