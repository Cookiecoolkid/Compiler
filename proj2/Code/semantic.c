#include "semantic.h"
#include "rb_tree.h"
#include "helper.h"
#include "node.h"
#include <assert.h>
#include <string.h>
#include <stdlib.h>

// 全局符号表实例
extern SymbolTable symTable;

// 全局结构体ID
extern struct_t structID;

// 错误报告
#define MSG_SIZE 256
char msg[MSG_SIZE];

void report_error(enum ErrorType type, int line, const char *msg) {
    printf("Error type %d at Line %d: %s\n", type, line, msg);
}

// 检查语义
void check_semantic(Node *root) {
    // Root is "Program"
    // Program -> ExtDefList
    assert(root != NULL && root->child != NULL);
    Node *extDefList = root->child;

    initSymbolTable();
    check_extDefList(extDefList);

    check_func_declared(symTable.globalFuncRoot);
}

void check_func_declared(RBNode funcRoot) {
    // Check if all functions are defined
    if (funcRoot == NULL) return;
    check_func_declared(funcRoot->left);
    if (funcRoot->symbol->type->u.function.defined != 1) {
        snprintf(msg, MSG_SIZE, "Undefined function %s", funcRoot->symbol->name);
        report_error(UNDEFINED_FUNCTION_DECLARATION, funcRoot->symbol->type->u.function.declare_lineno, msg);
    }
    check_func_declared(funcRoot->right);
}

void check_extDefList(Node *extDefList) {
    // ExtDefList -> ExtDef ExtDefList
    //             | empty
    assert(extDefList != NULL);
    if (extDefList->child == NULL) return;
    Node *extDef = extDefList->child;
    Node *nextExtDefList = extDef->next;
    check_extDef(extDef);
    check_extDefList(nextExtDefList);
}

void check_extDef(Node *extDef) {
    // ExtDef -> Specifier ExtDecList SEMI
    //         | Specifier SEMI
    //         | Specifier FunDec CompSt
    //         | Specifier FunDec SEMI
    assert(extDef != NULL);

    int childNum = get_child_num(extDef);
    assert(childNum == 2 || childNum == 3);
    Node *specifier = extDef->child;
    Node *secondChild = specifier->next;
    Type type = check_specifier(specifier);
    if (type == NULL) {
        // FIXME error recovery (check again)
        // Error occurred
        return;
    }

    if (secondChild->next == NULL) {
        // Specifier SEMI
        return;
    }
    assert(childNum == 3);
    Node *thirdChild = secondChild->next;
    if (strcmp(secondChild->name, "ExDecList") == 0) {
        check_extDecList(secondChild, type);
    } else if (strcmp(thirdChild->name, "CompSt") == 0) {
        // Defining a function
        check_funDec(secondChild, type, 1);
        check_compSt(thirdChild, type);
    } else {
        // Function declaration
        check_funDec(secondChild, type, 0);
    }
}

void check_extDecList(Node *extDecList, Type type) {
    // ExtDecList -> VarDec
    //             | VarDec COMMA ExtDecList
    assert(extDecList != NULL);
    Node *varDec = extDecList->child;
    check_varDec(varDec, type, 0);
    if (varDec->next != NULL) {
        check_extDecList(varDec->next->next, type);
    }
}

FieldList check_varDec(Node *varDec, Type type, int isParam) {
    // VarDec -> ID
    //         | VarDec LB INT RB
    assert(varDec != NULL);
    Node *child = varDec->child;

    if (child->next == NULL) {
        // ID
        char *name = child->value.value.str_val;
        if (!isParam) {
            if (search(name, false) != NULL) {
                snprintf(msg, MSG_SIZE, "Duplicate definition %s", name);
                report_error(DUPLICATE_DEFINITION, child->line, msg);
                return NULL;
            }
            Symbol symbol = createSymbol(name, type);
            insert(symbol);
        }
        FieldList field = (FieldList)malloc(sizeof(struct FieldList_));
        field->name = name;
        field->type = type;
        field->tail = NULL;
        return field;
    } else {
        // VarDec LB INT RB
        Node *sizeNode = child->next->next;
        if (sizeNode->value.value.int_val <= 0) {
            snprintf(msg, MSG_SIZE, "Array size must be positive");
            report_error(INVALID_LVALUE_ASSIGNMENT, sizeNode->line, msg);
            return NULL;
        }

        Type arrayType = (Type)malloc(sizeof(struct Type_));
        arrayType->kind = ARRAY;
        arrayType->u.array.elem = type;
        arrayType->u.array.size = sizeNode->value.value.int_val;

        return check_varDec(child, arrayType, isParam);
    }
}

Type check_specifier(Node *specifier) {
    // Specifier -> TYPE
    //            | StructSpecifier
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
            // FIXME: What type of error?
            snprintf(msg, MSG_SIZE, "Undefined type %s", typeName);
            report_error(UNDEFINED_VARIABLE, child->line, msg);
            return NULL;
        }
        return type;
    } else {
        // StructSpecifier
        // Return Basic or Structure type
        return check_structSpecifier(child);
    }
}

Type check_structSpecifier(Node *structSpecifier) {
    // StructSpecifier -> STRUCT OptTag LC DefList RC
    //                  | STRUCT Tag
    assert(structSpecifier != NULL);
    int childNum = get_child_num(structSpecifier);
    assert(childNum == 2 || childNum == 5);
    Node *child = structSpecifier->child;
    if (childNum == 2) {
        // STRUCT Tag
        return check_tag(child->next);
    } else {
        // STRUCT OptTag LC DefList RC
        char *name = check_optTag(child->next);
        
        // whether name is NULL or not, insert the structure into symbol table <nam, type> if there
        // is not define it in SymbolTable yet for named structure
        if (name != NULL) {
            if (search(name, true) != NULL) {
                snprintf(msg, MSG_SIZE, "Duplicate definition %s", name);
                report_error(DUPLICATE_DEFINITION, child->line, msg);
                return NULL;
            }
        }
        Type type = (Type)malloc(sizeof(struct Type_));
        type->kind = STRUCTURE;
        type->u.structure.ID = structID++;
        // fill structure members by defList
        check_defList(child->next->next->next, type->u.structure.struct_members);

        // Now we can insert it.
        Symbol symbol = createSymbol(name, type);
        insert(symbol);
        
        return type;
    }
}

Type check_tag(Node *tag) {
    // Tag -> ID
    assert(tag != NULL);
    // 在符号表中查找是否有对应的结构体定义，如果没有则报错
    // 返回对应结构体的 Type (Basic + StructID)
    char *name = tag->child->value.value.str_val;
    RBNode result = search(name, true);
    Symbol symbol = result->symbol;
    if (symbol == NULL) {
        snprintf(msg, MSG_SIZE, "Undefined structure usage %s", name);
        report_error(UNDEFINED_STRUCTURE_USAGE, tag->line, msg);
        return NULL;
    }
    Type type = (Type)malloc(sizeof(struct Type_));
    type->kind = BASIC;
    type->u.basic = symbol->type->u.structure.ID;
    return type;
}

char *check_optTag(Node *optTag) {
    // OptTag -> ID
    //         | empty
    assert(optTag != NULL);
    if (optTag->child == NULL) return NULL;
    return optTag->child->value.value.str_val;
}

void check_defList(Node *defList, FieldList fields) {
    // DefList -> Def DefList
    //          | empty
    assert(defList != NULL);
    if (defList->child == NULL) return;

    Node *def = defList->child;
    Node *nextDefList = def->next;

    check_def(def, fields);
    check_defList(nextDefList, fields);
}

void check_def(Node *def, FieldList fields) {
    // Def -> Specifier DecList SEMI
    assert(def != NULL);
    Node *specifier = def->child;
    Node *decList = specifier->next;
    check_decList(decList, check_specifier(specifier), fields);
}

void check_decList(Node *decList, Type type, FieldList fields) {
    // DecList -> Dec
    //          | Dec COMMA DecList
    assert(decList != NULL);
    Node *dec = decList->child;
    check_dec(dec, type, fields);
    if (dec->next != NULL) {
        check_decList(dec->next->next, type, fields);
    }
}

void check_dec(Node *dec, Type type, FieldList fields) {
    // Dec -> VarDec
    //      | VarDec ASSIGNOP Exp
    assert(dec != NULL);
    Node *varDec = dec->child;
    FieldList field = check_varDec(varDec, type, 0);
    if (field == NULL) {
        // FIXME error recovery (check again)
        return;
    }
    if (fields != NULL) {
        // Insert field into fields 
        FieldList res = searchFieldList(fields, field->name);
        if (res != NULL) {
            snprintf(msg, MSG_SIZE, "Duplicate definition %s", field->name);
            report_error(DUPLICATE_DEFINITION, varDec->line, msg);
            return;
        }
        appendFieldList(&fields, field);
    }

    if (varDec->next != NULL) {
        // VarDec ASSIGNOP Exp
        Node *exp = varDec->next->next;
        Type expType = check_exp(exp);
        if (type && expType && compareTypes(type, expType)) {
            snprintf(msg, MSG_SIZE, "Type mismatched for assignment");
            report_error(TYPE_MISMATCH_ASSIGNMENT, exp->line, msg);
        }
    }
}

void check_funDec(Node *funDec, Type type, int isDefine) {
    // FunDec -> ID LP VarList RP
    //         | ID LP RP
    assert(funDec != NULL);
    Node *child = funDec->child;
    int childNum = get_child_num(funDec);
    char *funcName = child->value.value.str_val;

    RBNode res = search(funcName, true);
    if (res != NULL) {
        assert(res->symbol->type->kind == FUNCTION);
        // Function already defined
        if (res->symbol->type->u.function.defined) {
            snprintf(msg, MSG_SIZE, "Duplicate definition %s", funcName);
            report_error(DUPLICATE_FUNCTION_DEFINITION, child->line, msg);
            return;
        }
        // Function can declare many times, but only define once
        if (isDefine) {
            res->symbol->type->u.function.defined = 1;
        }
    }
    // Insert new function into symbol table
    Type funcType = (Type)malloc(sizeof(struct Type_));
    funcType->kind = FUNCTION;
    funcType->u.function.ret = type;
    funcType->u.function.defined = isDefine;
    funcType->u.function.declare_lineno = child->line;
    funcType->u.function.params = NULL;
    funcType->u.function.paramNum = 0;

    if (childNum == 4) {
        // Has parameters
        Node *varList = child->next->next;
        check_varList(varList, &(funcType->u.function.params), &(funcType->u.function.paramNum));
    }

    Symbol symbol = createSymbol(funcName, funcType);
    insert(symbol);
}

void check_varList(Node *varList, FieldList *params, int *paramNum) {
    // VarList -> ParamDec COMMA VarList
    //          | ParamDec
    assert(varList != NULL);
    Node *paramDec = varList->child;
    Node *nextVarList = paramDec->next;

    FieldList param = check_paramDec(paramDec);
    appendFieldList(params, param);
    (*paramNum)++;

    if (nextVarList != NULL) {
        check_varList(nextVarList->next, params, paramNum);
    }
}

FieldList check_paramDec(Node *paramDec) {
    // ParamDec -> Specifier VarDec
    assert(paramDec != NULL);
    Node *specifier = paramDec->child;
    Node *varDec = specifier->next;
    Type type = check_specifier(specifier);
    return check_varDec(varDec, type, 1); // 1 indicates it's a parameter
}

void check_compSt(Node *compSt, Type funcType) {
    // CompSt -> LC DefList StmtList RC
    assert(compSt != NULL);
    enterScope();

    Node *defList = compSt->child->next;
    Node *stmtList = defList->next;

    check_defList(defList, NULL); // 解析局部变量定义
    check_stmtList(stmtList, funcType); // 解析语句列表

    exitScope();
}

void check_stmtList(Node *stmtList, Type funcType) {
    // StmtList -> Stmt StmtList
    //           | empty
    assert(stmtList != NULL);
    if (stmtList->child == NULL) return;

    Node *stmt = stmtList->child;
    check_stmt(stmt, funcType);
    check_stmtList(stmt->next, funcType);
}

/* ========================== Stmt & Exp ========================== */

void check_stmt(Node *stmt, Type funcType) {
    // Stmt -> Exp SEMI
    //       | CompSt
    //       | RETURN Exp SEMI
    //       | IF LP Exp RP Stmt
    //       | IF LP Exp RP Stmt ELSE Stmt
    //       | WHILE LP Exp RP Stmt
    
    assert(stmt != NULL);
    if (stmt->child == NULL) return;

    Node *child = stmt->child;
    if (strcmp(child->name, "Exp") == 0) {
        // Exp SEMI
        check_exp(child);
    } else if (strcmp(child->name, "CompSt") == 0) {
        // CompSt
        check_compSt(child, funcType);
    } else if (strcmp(child->name, "RETURN") == 0) {
        // RETURN Exp SEMI
        Node *exp = child->next;
        Type returnType = check_exp(exp);
        if (funcType->u.function.ret && returnType && compareTypes(funcType->u.function.ret, returnType)) {
            snprintf(msg, MSG_SIZE, "Return type mismatch");
            report_error(RETURN_TYPE_MISMATCH, exp->line, msg);
        }
    } else if (strcmp(child->name, "IF") == 0) {
        // IF LP Exp RP Stmt
        Node *exp = child->next->next;
        Type expType = check_exp(exp);
        if (expType->kind != BASIC || expType->u.basic != INT_) {
            snprintf(msg, MSG_SIZE, "Condition must be integer");
            report_error(OPERATION_TYPE_MISMATCH, exp->line, msg);
        }
        Node *stmt1 = exp->next->next;
        check_stmt(stmt1, funcType);
        if (stmt1->next != NULL && stmt1->next->next != NULL) {
            // ELSE Stmt
            Node *stmt2 = stmt1->next->next;
            check_stmt(stmt2, funcType);
        }
    } else if (strcmp(child->name, "WHILE") == 0) {
        // WHILE LP Exp RP Stmt
        Node *exp = child->next->next;
        Type expType = check_exp(exp);
        if (expType->kind != BASIC || expType->u.basic != INT_) {
            snprintf(msg, MSG_SIZE, "Condition must be integer");
            report_error(OPERATION_TYPE_MISMATCH, exp->line, msg);
        }
        Node *stmt1 = exp->next->next;
        check_stmt(stmt1, funcType);
    }
}

Type check_exp(Node *exp) {
    // Exp -> Exp ASSIGNOP Exp
    //      | Exp AND Exp
    //      | Exp OR Exp
    //      | Exp RELOP Exp
    //      | Exp PLUS Exp
    //      | Exp MINUS Exp
    //      | Exp STAR Exp
    //      | Exp DIV Exp
    //      | LP Exp RP
    //      | ID LP RP
    //      | Exp DOT ID
    //      | MINUS Exp
    //      | NOT Exp
    //      | ID LP Args RP
    //      | Exp LB Exp RB
    //      | ID
    //      | INT
    //      | FLOAT
    assert(exp != NULL);
    assert(exp->child != NULL);

    Node *child = exp->child;

    // 叶子节点：ID, INT, FLOAT
    if (child->next == NULL) {
        if (strcmp(child->name, "ID") == 0) {
            char *name = child->value.value.str_val;
            RBNode result = search(name, false);
            if (result == NULL) {
                snprintf(msg, MSG_SIZE, "Undefined variable %s", name);
                report_error(UNDEFINED_VARIABLE, exp->line, msg);
                return NULL;
            }
            return result->symbol->type;
        } else if (strcmp(child->name, "INT") == 0) {
            Type type = createBasicType(INT_);
            return type;
        } else if (strcmp(child->name, "FLOAT") == 0) {
            Type type = createBasicType(FLOAT_);
            return type;
        }
        return NULL;
    }

    Node *second_child = child->next;

    if (strcmp(second_child->name, "ASSIGNOP") == 0) {
        // Exp ASSIGNOP Exp
        Node *left = child;
        Node *right = second_child->next;
        Type leftType = check_exp(left);
        Type rightType = check_exp(right);
        if (leftType && rightType && compareTypes(leftType, rightType)) {
            snprintf(msg, MSG_SIZE, "Type mismatch in assignment");
            report_error(TYPE_MISMATCH_ASSIGNMENT, exp->line, msg);
        }
        return leftType;
    } else if (strcmp(second_child->name, "AND") == 0 || strcmp(second_child->name, "OR") == 0) {
        // Exp AND/OR Exp
        Node *left = child;
        Node *right = second_child->next;
        Type leftType = check_exp(left);
        Type rightType = check_exp(right);
        if (leftType && rightType && compareTypes(leftType, rightType)) {
            snprintf(msg, MSG_SIZE, "Type mismatch in logical operation");
            report_error(OPERATION_TYPE_MISMATCH, exp->line, msg);
        }
        return createBasicType(INT_); // 假设逻辑运算结果为 int 类型
    } else if (strcmp(second_child->name, "RELOP") == 0) {
        // Exp RELOP Exp
        Node *left = child;
        Node *right = second_child->next;
        Type leftType = check_exp(left);
        Type rightType = check_exp(right);
        if (leftType && rightType && compareTypes(leftType, rightType)) {
            snprintf(msg, MSG_SIZE, "Type mismatch in relational operation");
            report_error(OPERATION_TYPE_MISMATCH, exp->line, msg);
        }
        return createBasicType(INT_); // 假设关系运算结果为 int 类型
    } else if (strcmp(second_child->name, "PLUS") == 0 || strcmp(second_child->name, "MINUS") == 0 ||
               strcmp(second_child->name, "STAR") == 0 || strcmp(second_child->name, "DIV") == 0) {
        // Exp PLUS/MINUS/STAR/DIV Exp
        Node *left = child;
        Node *right = second_child->next;
        Type leftType = check_exp(left);
        Type rightType = check_exp(right);
        // assert(leftType != NULL && rightType != NULL);
        if (leftType && rightType && compareTypes(leftType, rightType)) {
            snprintf(msg, MSG_SIZE, "Type mismatch in arithmetic operation");
            report_error(OPERATION_TYPE_MISMATCH, exp->line, msg);
        }
        return leftType; // 假设算术运算结果类型与左操作数类型相同
    } else if (strcmp(child->name, "LP") == 0 && strcmp(second_child->name, "RP") == 0) {
        // LP Exp RP
        return check_exp(child->next);
    } else if (strcmp(child->name, "ID") == 0 && strcmp(second_child->name, "LP") == 0 && strcmp(second_child->next->name, "RP") == 0) {
        // ID LP RP
        char *name = child->value.value.str_val;
        RBNode result = search(name, true);
        if (result == NULL) {
            snprintf(msg, MSG_SIZE, "Undefined function call %s", name);
            report_error(UNDEFINED_FUNCTION_CALL, exp->line, msg);
            return NULL;
        }
        if (result->symbol->type->kind != FUNCTION) {
            snprintf(msg, MSG_SIZE, "Function call on non-function %s", name);
            report_error(FUNCTION_CALL_ON_NON_FUNCTION, exp->line, msg);
            return NULL;
        }
        return result->symbol->type->u.function.ret;
    } else if (strcmp(second_child->name, "DOT") == 0) {
        // Exp DOT ID
        Node *left = child;
        Node *right = second_child->next;
        Type leftType = check_exp(left);
        if (leftType->kind != STRUCTURE) {
            snprintf(msg, MSG_SIZE, "Structure field on non-structure");
            report_error(STRUCTURE_FIELD_ON_NON_STRUCTURE, exp->line, msg);
            return NULL;
        }
        char *fieldName = right->value.value.str_val;
        FieldList field = leftType->u.structure.struct_members;
        while (field != NULL) {
            if (strcmp(field->name, fieldName) == 0) {
                return field->type;
            }
            field = field->tail;
        }
        snprintf(msg, MSG_SIZE, "Undefined structure field %s", fieldName);
        report_error(UNDEFINED_STRUCTURE_FIELD, exp->line, msg);
        return NULL;
    } else if (strcmp(child->name, "MINUS") == 0) {
        // MINUS Exp
        Node *right = child->next;
        Type rightType = check_exp(right);
        if (rightType->kind != BASIC || (rightType->u.basic != INT_ && rightType->u.basic != FLOAT_)) {
            snprintf(msg, MSG_SIZE, "Type mismatch in unary minus operation");
            report_error(OPERATION_TYPE_MISMATCH, exp->line, msg);
        }
        return rightType;
    } else if (strcmp(child->name, "NOT") == 0) {
        // NOT Exp
        Node *right = child->next;
        Type rightType = check_exp(right);
        if (rightType->kind != BASIC || rightType->u.basic != INT_) {
            snprintf(msg, MSG_SIZE, "Type mismatch in logical NOT operation");
            report_error(OPERATION_TYPE_MISMATCH, exp->line, msg);
        }
        return createBasicType(INT_);
    } else if (strcmp(second_child->name, "LP") == 0 && strcmp(second_child->next->next->name, "RP") == 0) {
        // ID LP Args RP
        char *name = child->value.value.str_val;
        RBNode result = search(name, true);
        if (result == NULL) {
            snprintf(msg, MSG_SIZE, "Undefined function call %s", name);
            report_error(UNDEFINED_FUNCTION_CALL, exp->line, msg);
            return NULL;
        }
        if (result->symbol->type->kind != FUNCTION) {
            snprintf(msg, MSG_SIZE, "Function call on non-function %s", name);
            report_error(FUNCTION_CALL_ON_NON_FUNCTION, exp->line, msg);
            return NULL;
        }
        // 检查参数类型匹配
        check_args(second_child->next, result->symbol->type->u.function.params);
        return result->symbol->type->u.function.ret;
    } else if (strcmp(second_child->name, "LB") == 0 && strcmp(second_child->next->next->name, "RB") == 0) {
        // Exp LB Exp RB
        Node *left = child;
        Node *right = second_child->next;
        Type leftType = check_exp(left);
        if (leftType->kind != ARRAY) {
            snprintf(msg, MSG_SIZE, "Array access on non-array");
            report_error(ARRAY_ACCESS_ON_NON_ARRAY, exp->line, msg);
            return NULL;
        }
        Type rightType = check_exp(right);
        if (rightType->kind != BASIC || rightType->u.basic != INT_) {
            snprintf(msg, MSG_SIZE, "Non-integer array index");
            report_error(NON_INTEGER_ARRAY_INDEX, exp->line, msg);
            return NULL;
        }
        return leftType->u.array.elem;
    }

    return NULL;
}


void check_args(Node *args, FieldList params) {
    if (args == NULL && params == NULL) {
        return;
    }
    if (args == NULL || params == NULL) {
        snprintf(msg, MSG_SIZE, "Function argument mismatch");
        report_error(FUNCTION_ARGUMENT_MISMATCH, args->line, msg);
        return;
    }

    Type argType = check_exp(args);
    if (argType->kind != params->type->kind) {
        snprintf(msg, MSG_SIZE, "Argument type mismatch");
        report_error(FUNCTION_ARGUMENT_MISMATCH, args->line, msg);
    }

    if (args->next != NULL) {
        check_args(args->next->next, params->tail);
    }
}