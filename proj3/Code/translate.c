#include "translate.h"
#include "node.h"
#include "rb_tree.h"
#include "command.h"
#include <assert.h>

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
    translate_specifier(specifier, file);
    if (secondChild->next == NULL) {
        // Specifier SEMI
        return;
    }
    Node *thirdChild = secondChild->next;
    if (strcmp(secondChild->name, "ExtDecList") == 0) {
        translate_extDecList(secondChild, file);
    } else if (strcmp(thirdChild->name, "CompSt") == 0) {
        translate_funDec(secondChild, file);
        translate_compSt(thirdChild, file);
    } else {
        translate_funDec(secondChild, file);
    }
}

void translate_specifier(Node *specifier, FILE *file) {
    // Specifier: TYPE | StructSpecifier
    assert(specifier != NULL);
    Node *child = specifier->child;
    if (strcmp(child->name, "TYPE") == 0) {
        // Basic type
    } else {
        // StructSpecifier
        translate_structSpecifier(child, file);
    }
}

void translate_extDecList(Node *extDecList, FILE *file) {
    // ExtDecList: VarDec
    //            | VarDec COMMA ExtDecList
    assert(extDecList != NULL);
    Node *varDec = extDecList->child;
    translate_varDec(varDec, file, false);
    if (varDec->next != NULL) {
        translate_extDecList(varDec->next->next, file);
    }
}

void translate_funDec(Node *funDec, FILE *file) {
    // FunDec: ID LP VarList RP | ID LP RP
    assert(funDec != NULL);
    Node *idNode = funDec->child;
    Node *thirdNode = idNode->next->next;

    char *funcName = idNode->value.value.str_val;
    operand funcOp = create_operand(NULL_VALUE, funcName, FUNCTION_NAME, VAL);
    command funcCmd = create_command(FUNCTION, NULL_OP, NULL_OP, funcOp, NULL_RELOP);
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

void translate_compSt(Node *compSt, FILE *file) {
    // CompSt: LC DefList StmtList RC
    assert(compSt != NULL);
    Node *defList = compSt->child->next;
    Node *stmtList = defList->next;
    translate_defList(defList, file);
    translate_stmtList(stmtList, file);
}

operand translate_varDec(Node *varDec, FILE *file, bool inRecursion) {
    // VarDec: ID | VarDec LB INT RB 
    assert(varDec != NULL);
    Node *idNode = varDec->child;
    if (idNode->next == NULL) {
        // ID
        char *name = idNode->value.value.str_val;
        RBNode var = search(name, false);
        if (var == NULL) assert(0);
        Type type = var->symbol->type;
        assert(type->kind == BASIC);
        operand op;
        if (type->u.basic <= 1) {
            // INT/FLOAT VARIABLE
            // Only struct & function output DEC command
            op = create_operand(INT_FLOAT_SIZE, name, VARIABLE, VAL);
        } else {
            // Struct
            RBNode structVar = search(itoa(type->u.basic), true);
            if (structVar == NULL) assert(0);
            int size_ = calculate_size(type);
            op = create_operand(size_, structVar->symbol->type->u.structure.ID, VARIABLE, VAL);
            command structCmd = create_command(DEC, NULL_OP, NULL_OP, op, NULL_RELOP);
            append_command_to_file(structCmd, file);
        }
        return op;
    }
    Node *varDec_child = idNode;
    Node *thirdNode = idNode->next->next;
    // VarDec LB INT RB
    assert(thirdNode != NULL);
    int size_ = thirdNode->value.value.int_val;
    operand op = translate_varDec(varDec_child, file, true);
    operand res_op = op;
    res_op->value = size_ * op->value;
    if (!inRecursion) {
        command decCmd = create_command(DEC, NULL_OP, NULL_OP, op, NULL_RELOP);
        append_command_to_file(decCmd, file);
    }

    return res_op;
}

void translate_structSpecifier(Node *structSpecifier, FILE *file) {
    // StructSpecifier: STRUCT OptTag LC DefList RC | STRUCT Tag
    
    // Do Nothing
    assert(structSpecifier != NULL);
    Node *child = structSpecifier->child;
    Node *secondChild = child->next;
    if (secondChild->next == NULL) {
        // STRUCT Tag
        translate_tag(secondChild, file);
    } else {
        // STRUCT OptTag LC DefList RC
        Node *optTag = secondChild;
        Node *defList = optTag->next->next;
        translate_optTag(optTag, file);
        translate_defList(defList, file);
    }
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
    translate_specifier(specifier, file);
    translate_decList(decList, file);
}

void translate_decList(Node *decList, FILE *file) {
    // DecList: Dec | Dec COMMA DecList
    assert(decList != NULL);
    Node *dec = decList->child;
    translate_dec(dec, file);
    if (dec->next != NULL) {
        translate_decList(dec->next->next, file);
    }
}

void translate_dec(Node *dec, FILE *file) {
    // Dec: VarDec | VarDec ASSIGNOP Exp
    assert(dec != NULL);
    Node *varDec = dec->child;
    if (varDec->next == NULL) {
        // VarDec
        translate_varDec(varDec, file, false);
        return;
    }
    // VarDec ASSIGNOP Exp
    Node *exp = varDec->next->next;
    operand res = translate_varDec(varDec, file, false);
    operand exp = translate_exp(exp, file);
    command assignCmd = create_command(ASSIGN, res, exp, NULL_OP, NULL_RELOP);
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

void translate_stmtList(Node *stmtList, FILE *file) {
    // StmtList: Stmt StmtList | empty
    assert(stmtList != NULL);
    if (stmtList->child == NULL) return;

    Node *stmt = stmtList->child;
    Node *nextStmtList = stmt->next;

    translate_stmt(stmt, file);
    translate_stmtList(nextStmtList, file);
}

void translate_stmt(Node *stmt, FILE *file) {
    // Stmt: Exp SEMI | CompSt | RETURN Exp SEMI | IF LP Exp RP Stmt
    //      | IF LP Exp RP Stmt ELSE Stmt | WHILE LP Exp RP Stmt
    assert(stmt != NULL);
    Node *child = stmt->child;
    if (strcmp(child->name, "Exp") == 0) {
        // Exp SEMI
        translate_exp(child, file);

    } else if (strcmp(child->name, "CompSt") == 0) {
        // CompSt
        translate_compSt(child, file);

    } else if (strcmp(child->name, "RETURN") == 0) {
        // RETURN Exp SEMI
        Node *exp = child->next;
        operand returnOp = translate_exp(exp, file);
        command returnCmd = create_command(RETURN, NULL_OP, NULL_OP, returnOp, NULL_RELOP);
        append_command_to_file(returnCmd, file);

    } else if (strcmp(child->name, "IF") == 0) {
        Node *exp = child->next->next;
        Node *stmt1 = exp->next->next;
        if (stmt1->next != NULL && stmt1->next->next != NULL) {
            // IF LP Exp RP Stmt ELSE Stmt
            Node *stmt2 = stmt1->next->next;
            operand label1 = create_operand(NULL_VALUE, NULL, LABEL, VAL);
            operand label2 = create_operand(NULL_VALUE, NULL, LABEL, VAL);
            operand label3 = create_operand(NULL_VALUE, NULL, LABEL, VAL);
            operand cond = translate_cond(exp, file, label1, label2);

            command label1Cmd = create_command(LABEL, NULL_OP, NULL_OP, label1, NULL_RELOP);
            append_command_to_file(label1Cmd, file);

            translate_stmt(stmt1, file);
            
            command gotoCmd = create_command(GOTO, NULL_OP, NULL_OP, label3, NULL_RELOP);
            append_command_to_file(gotoCmd, file);

            command label2Cmd = create_command(LABEL, NULL_OP, NULL_OP, label2, NULL_RELOP);
            append_command_to_file(label2Cmd, file);

            translate_stmt(stmt2, file);

            command label3Cmd = create_command(LABEL, NULL_OP, NULL_OP, label3, NULL_RELOP);
            append_command_to_file(label3Cmd, file);
        } else {
            // IF LP Exp RP Stmt
            operand label1 = create_operand(NULL_VALUE, NULL, LABEL, VAL);
            operand label2 = create_operand(NULL_VALUE, NULL, LABEL, VAL);
            operand cond = translate_cond(exp, file, NULL, label2);

            command label1Cmd = create_command(LABEL, NULL_OP, NULL_OP, label1, NULL_RELOP);
            append_command_to_file(label1Cmd, file);

            translate_stmt(stmt1, file);

            command label2Cmd = create_command(LABEL, NULL_OP, NULL_OP, label2, NULL_RELOP);
            append_command_to_file(label2Cmd, file);
        }
    } else if (strcmp(child->name, "WHILE") == 0) {
        // WHILE LP Exp RP Stmt
        Node *exp = child->next->next;
        Node *stmt = exp->next->next;

        operand label1 = create_operand(NULL_VALUE, NULL, LABEL, VAL);
        operand label2 = create_operand(NULL_VALUE, NULL, LABEL, VAL);
        operand label3 = create_operand(NULL_VALUE, NULL, LABEL, VAL);

        command label1Cmd = create_command(LABEL, NULL_OP, NULL_OP, label1, NULL_RELOP);
        append_command_to_file(label1Cmd, file);

        operand cond = translate_cond(exp, file, label2, label3);

        command label2Cmd = create_command(LABEL, NULL_OP, NULL_OP, label2, NULL_RELOP);
        append_command_to_file(label2Cmd, file);

        translate_stmt(stmt, file);

        command gotoCmd = create_command(GOTO, NULL_OP, NULL_OP, label1, NULL_RELOP);
        append_command_to_file(gotoCmd, file);

        command label3Cmd = create_command(LABEL, NULL_OP, NULL_OP, label3, NULL_RELOP);
        append_command_to_file(label3Cmd, file);
    }
}

operand translate_cond(Node *cond, FILE *file, operand label1, operand label2) {
    // Cond: Exp RELOP Exp
    assert(cond != NULL);
    Node *exp1 = cond->child;
    Node *relop = exp1->next;
    Node *exp2 = relop->next;

    // TODO
}

operand translate_exp(Node *exp, FILE *file) {
    // Exp: Exp ASSIGNOP Exp | Exp AND Exp | Exp OR Exp | Exp RELOP Exp
    //     | Exp PLUS Exp | Exp MINUS Exp | Exp STAR Exp | Exp DIV Exp
    //     | LP Exp RP | ID LP RP | Exp DOT ID | MINUS Exp | NOT Exp
    //     | ID LP Args RP | Exp LB Exp RB | ID | INT | FLOAT
    assert(exp != NULL);
    Node *child = exp->child;
    // TODO
}

void translate_args(Node *args, FILE *file) {
    // Args: Exp COMMA Args | Exp
    assert(args != NULL);
    Node *exp = args->child;
    translate_exp(exp, file);
    if (exp->next != NULL) {
        translate_args(exp->next->next, file);
    }
}