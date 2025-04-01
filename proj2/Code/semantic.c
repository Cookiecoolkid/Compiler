#include "semantic.h"
#include "rb_tree.h"
#include "node.h"
#include <assert.h>
#include <string.h>
#include <stdlib.h>

// 全局符号表实例
extern SymbolTable symTable;

// 全局结构体ID
extern struct_t structID;

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
        report_error(UNDEFINED_FUNCTION_DECLARATION, funcRoot->symbol->type->u.function.declare_lineno, "Undefined function declaration");
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
    check_varDec(varDec, type);
    if (varDec->next != NULL) {
        check_extDecList(varDec->next->next, type);
    }
}

void check_varDec(Node *varDec, Type type) {
    // VarDec -> ID
    //         | VarDec LB INT RB
    
    assert(varDec != NULL);
    Node *child = varDec->child;

    if (child->next == NULL) {
        // ID, insert into symbol table(maybe be array)
        char *name = child->value.value.str_val;
        if (search(name, false) != NULL) {
            report_error(DUPLICATE_DEFINITION, child->line, "Duplicate definition");
            return;
        }
        Symbol symbol = createSymbol(name, type);
        insert(symbol, symTable.currentScope->root);
    } else {
        // VarDec LB INT RB
        Node *sizeNode = child->next->next;
        if (sizeNode->value.value.int_val <= 0) {
            report_error(INVALID_LVALUE_ASSIGNMENT, sizeNode->line, "Array size must be positive");
            return;
        }

        Type arrayType = (Type)malloc(sizeof(struct Type_));
        arrayType->kind = ARRAY;
        arrayType->u.array.elem = type;
        arrayType->u.array.size = sizeNode->value.value.int_val;

        check_varDec(child, arrayType);
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
        if (strcmp(child->value.value.str_val, "int") == 0) {
            type->u.basic = INT;
        } else {
            type->u.basic = FLOAT;
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
                report_error(DUPLICATE_DEFINITION, child->line, "Duplicate definition");
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
        insert(symbol, symTable.globalStructRoot);
        
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
        report_error(UNDEFINED_STRUCTURE_USAGE, tag->line, "Undefined structure usage");
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
    if (defList->child == NULL) return NULL;

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

void check_funDec(Node *funDec, Type type, int isDefine) {
    // FunDec -> ID LP VarList RP
    //         | ID LP RP
    assert(funDec != NULL);
    Node *child = funDec->child;
    char *funcName = child->value.value.str_val;

    RBNode res = search(funcName, true);
    if (res != NULL) {
        assert(res->symbol->type->kind == FUNCTION);
        // Function already defined
        if (res->symbol->type->u.function.defined) {
            report_error(DUPLICATE_FUNCTION_DEFINITION, child->line, "Duplicate function definition");
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
    // Set function parameters and parameter number
    FieldList params = NULL;
    // TODO
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
