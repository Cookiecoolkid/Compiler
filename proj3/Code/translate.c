#include "translate.h"
#include "node.h"

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
    int childNum = get_child_num(extDef);
    assert(childNum == 2 || childNum == 3);
    Node *specifier = extDef->child;
    Node *secondChild = specifier->next;
    translate_specifier(specifier, file);
    if (childNum == 2) {
        // Specifier SEMI
        return;
    }
    assert(childNum == 3);
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
        // TODO
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
    translate_varDec(varDec, file);
    if (varDec->next != NULL) {
        translate_extDecList(varDec->next->next, file);
    }
}

void translate_funDec(Node *funDec, FILE *file) {
    // FunDec: ID LP VarList RP | ID LP RP
    assert(funDec != NULL);
    Node *idNode = funDec->child;
    Node *thirdNode = idNode->next->next;
    if (thirdNode->next == NULL) {
        // ID LP RP
        // TODO
        return;
    }
    Node *varList = thirdNode;
    translate_varList(varList, file);
}

void translate_compSt(Node *compSt, FILE *file) {
    // CompSt: LC DefList StmtList RC
    assert(compSt != NULL);
    Node *defList = compSt->child->next;
    Node *stmtList = defList->next;
    translate_defList(defList, file);
    translate_stmtList(stmtList, file);
}

void translate_varDec(Node *varDec, FILE *file) {
    // VarDec: ID | VarDec LB INT RB | VarDec LB RB
    assert(varDec != NULL);
    Node *idNode = varDec->child;
    if (idNode->next == NULL) {
        // ID
        // TODO
        return;
    }
    Node *varDec_child = idNode;
    Node *thirdNode = idNode->next->next;
    if (thirdNode->next == NULL) {
        // VarDec LB RB
        // TODO
        translate_varDec(varDec_child, file);
        return;
    }
    // VarDec LB INT RB
    // TODO
    translate_varDec(varDec_child, file);
}

void translate_structSpecifier(Node *structSpecifier, FILE *file) {
    // StructSpecifier: STRUCT OptTag LC DefList RC | STRUCT Tag
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
    assert(optTag != NULL);
    if (optTag->child == NULL) return;
    Node *idNode = optTag->child;
    // TODO
}

void translate_tag(Node *tag, FILE *file) {
    // Tag: ID
    assert(tag != NULL);
    Node *idNode = tag->child;
    // TODO
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
        translate_varDec(varDec, file);
        return;
    }
    Node *exp = varDec->next->next;
    translate_varDec(varDec, file);
    translate_exp(exp, file);
}

void translate_varList(Node *varList, FILE *file) {
    // VarList: ParamDec COMMA VarList | ParamDec
    assert(varList != NULL);
    Node *paramDec = varList->child;
    translate_paramDec(paramDec, file);
    if (paramDec->next != NULL) {
        translate_varList(paramDec->next->next, file);
    }
}

void translate_paramDec(Node *paramDec, FILE *file) {
    // ParamDec: Specifier VarDec
    assert(paramDec != NULL);
    Node *specifier = paramDec->child;
    Node *varDec = specifier->next;
    translate_specifier(specifier, file);
    translate_varDec(varDec, file);
}

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
        return;
    } else if (strcmp(child->name, "CompSt") == 0) {
        // CompSt
        translate_compSt(child, file);
        return;
    } else if (strcmp(child->name, "RETURN") == 0) {
        // RETURN Exp SEMI
        Node *exp = child->next;
        translate_exp(exp, file);
        return;
    } else if (strcmp(child->name, "IF") == 0) {
        // IF LP Exp RP Stmt
        Node *exp = child->next->next;
        Node *stmt1 = exp->next->next;
        translate_exp(exp, file);
        translate_stmt(stmt1, file);
        if (stmt1->next != NULL && stmt1->next->next != NULL) {
            // ELSE Stmt
            Node *stmt2 = stmt1->next->next;
            translate_stmt(stmt2, file);
        }
    } else if (strcmp(child->name, "WHILE") == 0) {
        // WHILE LP Exp RP Stmt
        Node *exp = child->next->next;
        Node *stmt = exp->next->next;
        translate_exp(exp, file);
        translate_stmt(stmt, file);

        return;
    }
}

void translate_exp(Node *exp, FILE *file) {
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