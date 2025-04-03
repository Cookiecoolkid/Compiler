#ifndef _RB_TREE_H
#define _RB_TREE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

// 定义类型
typedef struct Type_* Type;
typedef struct FieldList_* FieldList;
typedef struct Symbol_* Symbol;
typedef struct RBNode_* RBNode;

// 定义颜色枚举
enum Color { RED, BLACK };

// 定义种类枚举
enum Kind { BASIC, ARRAY, STRUCTURE, FUNCTION };

// 定义基本类型枚举
enum BasicType { INT_, FLOAT_ };

// // 定义全局结构体ID
#define BASIC_TYPE_NUM 2
typedef unsigned int struct_t;  
// struct_t structID;

// 定义符号结构体
struct Symbol_ {
    char* name;
    Type type;
};

// 定义类型结构体
struct Type_ {
    enum Kind kind;
    union {
        int basic;
        struct { Type elem; int size; } array;
        struct { int ID; FieldList struct_members; } structure;
        struct { FieldList params; Type ret; int paramNum; int defined; int declare_lineno; } 
                 function;
    } u;
};

// 定义字段列表结构体
struct FieldList_ {
    char* name;
    Type type;
    FieldList tail;
};

// 定义红黑树节点结构体
struct RBNode_ {
    Symbol symbol;
    RBNode left;
    RBNode right;
    RBNode parent;
    enum Color color;
};

// 定义作用域链表节点结构体
typedef struct ScopeRBNode {
    RBNode root; // 当前作用域的红黑树根节点
    struct ScopeRBNode* next; // 指向下一个作用域
} ScopeRBNode;

// 定义全局符号表结构体
typedef struct {
    ScopeRBNode* currentScope; // 当前作用域
    RBNode globalStructRoot; // 全局结构体定义的根节点
    RBNode globalFuncRoot; // 全局函数定义的根节点
} SymbolTable;


// 函数声明
ScopeRBNode* createScope();
RBNode createRBNode(Symbol symbol);
void updateRoot(RBNode node);
void leftRotate(RBNode node);
void rightRotate(RBNode node);
void fixViolation(RBNode node);
void printTree(RBNode node);
void printScopeChain();
void initSymbolTable();
void enterScope();
void exitScope();

/* ================ Public API ================ */
void insert(Symbol symbol);
RBNode search(char* name, bool isDef);
RBNode searchRBTree(RBNode root, char* name);
RBNode searchByStructID(RBNode node, struct_t structID);

Symbol createSymbol(const char* name, Type type);
Type createBasicType(int basicType);
Type createArrayType(Type elem, int size);
Type createStructType(FieldList struct_members);


#endif // _RB_TREE_H