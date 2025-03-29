#ifndef _RB_TREE_H
#define _RB_TREE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Type_* Type;
typedef struct FieldList_* FieldList;
typedef struct Symbol_* Symbol;
typedef struct RBNode_* RBNode;
enum Color { RED, BLACK };
enum Kind { BASIC, ARRAY, STRUCTURE, FUNCTION };

// 定义符号类型
struct Symbol_ {
    char* name;
    Type type;
};

// 定义类型
struct Type_ {
    enum Kind kind;
    union {
        int basic;
        struct { Type elem; int size; } array;
        FieldList structure;
        struct { FieldList params; Type ret; int paramNum; int defined; int declared; } function;
    } u;
};

// 定义字段列表
struct FieldList_ {
    char* name;
    Type type;
    FieldList tail;
};

// 定义红黑树节点
struct RBNode_ {
    Symbol symbol;
    RBNode left;
    RBNode right;
    RBNode parent;
    enum Color color;
};

// 定义作用域链表节点
typedef struct ScopeRBNode {
    RBNode root; // 当前作用域的红黑树根节点
    struct ScopeRBNode* next; // 指向下一个作用域
} ScopeRBNode;

// 定义全局符号表
typedef struct {
    ScopeRBNode* currentScope; // 当前作用域
    RBNode globalStructRoot; // 全局结构体定义的根节点
    RBNode globalFuncRoot; // 全局函数定义的根节点
} SymbolTable;

// 创建新作用域
ScopeRBNode* createScope() {
    ScopeRBNode* newScope = (ScopeRBNode*)malloc(sizeof(ScopeRBNode));
    newScope->root = NULL;
    newScope->next = NULL;
    return newScope;
}

// 创建新节点
RBNode createRBNode(Symbol symbol) {
    RBNode newRBNode = (RBNode)malloc(sizeof(struct RBNode_));
    newRBNode->symbol = symbol;
    newRBNode->left = NULL;
    newRBNode->right = NULL;
    newRBNode->parent = NULL;
    newRBNode->color = RED; // 新节点默认为红色
    return newRBNode;
}

// 辅助函数：更新根节点
void updateRoot(RBNode node, void* context) {
    if (node->parent == NULL) {
        if (context == NULL) {
            // 全局红黑树的根节点
            SymbolTable* symTable = (SymbolTable*)context;
            if (node->symbol->type->kind == STRUCTURE) {
                symTable->globalStructRoot = node;
            } else if (node->symbol->type->kind == FUNCTION) {
                symTable->globalFuncRoot = node;
            }
        } else {
            // 局部作用域的根节点
            ScopeRBNode* scope = (ScopeRBNode*)context;
            scope->root = node;
        }
    }
}

// 左旋操作
void leftRotate(RBNode node, void* context) {
    RBNode rightChild = node->right;
    node->right = rightChild->left;
    if (rightChild->left != NULL) {
        rightChild->left->parent = node;
    }
    rightChild->parent = node->parent;
    if (node->parent == NULL) {
        updateRoot(rightChild, context);
    } else if (node == node->parent->left) {
        node->parent->left = rightChild;
    } else {
        node->parent->right = rightChild;
    }
    rightChild->left = node;
    node->parent = rightChild;
}

// 右旋操作
void rightRotate(RBNode node, void* context) {
    RBNode leftChild = node->left;
    node->left = leftChild->right;
    if (leftChild->right != NULL) {
        leftChild->right->parent = node;
    }
    leftChild->parent = node->parent;
    if (node->parent == NULL) {
        updateRoot(leftChild, context);
    } else if (node == node->parent->right) {
        node->parent->right = leftChild;
    } else {
        node->parent->left = leftChild;
    }
    leftChild->right = node;
    node->parent = leftChild;
}

// 修复红黑树的性质
void fixViolation(RBNode node, void* context) {
    RBNode parent = NULL;
    RBNode grandparent = NULL;
    ScopeRBNode* scope = NULL;

    // 如果是全局红黑树，context为SymbolTable指针
    if (node->parent == NULL) {
        // 根节点必须是黑色
        node->color = BLACK;
        return;
    }

    if (node->symbol->type->kind == STRUCTURE || node->symbol->type->kind == FUNCTION) {
        scope = NULL; // 全局红黑树没有scope
    } else {
        scope = (ScopeRBNode*)context;
    }

    while ((node != NULL) && (node->color == RED) && (node->parent->color == RED)) {
        parent = node->parent;
        grandparent = node->parent->parent;

        // 父节点是祖父节点的左孩子
        if (parent == grandparent->left) {
            RBNode uncle = grandparent->right;

            // 情况1：叔叔是红色
            if (uncle != NULL && uncle->color == RED) {
                grandparent->color = RED;
                parent->color = BLACK;
                uncle->color = BLACK;
                node = grandparent;
            } else {
                // 情况2：叔叔是黑色，当前节点是右孩子
                if (node == parent->right) {
                    leftRotate(parent, scope);
                    node = parent;
                    parent = node->parent;
                }

                // 情况3：叔叔是黑色，当前节点是左孩子
                rightRotate(grandparent, scope);
                parent->color = BLACK;
                grandparent->color = RED;
                node = parent;
            }
        } else {
            // 父节点是祖父节点的右孩子
            RBNode uncle = grandparent->left;

            // 情况1：叔叔是红色
            if (uncle != NULL && uncle->color == RED) {
                grandparent->color = RED;
                parent->color = BLACK;
                uncle->color = BLACK;
                node = grandparent;
            } else {
                // 情况2：叔叔是黑色，当前节点是左孩子
                if (node == parent->left) {
                    rightRotate(parent, scope);
                    node = parent;
                    parent = node->parent;
                }

                // 情况3：叔叔是黑色，当前节点是右孩子
                leftRotate(grandparent, scope);
                parent->color = BLACK;
                grandparent->color = RED;
                node = parent;
            }
        }
    }

    // 确保根节点是黑色
    if (scope != NULL) {
        scope->root->color = BLACK;
    } else {
        // 全局红黑树的根节点
        if (node->parent == NULL) {
            node->color = BLACK;
        }
    }
}

// 插入节点到红黑树
void insert(Symbol symbol, void* context) {
    RBNode newRBNode = createRBNode(symbol);
    RBNode current = NULL;
    RBNode parent = NULL;
    ScopeRBNode* scope = NULL;

    // 判断符号类型
    if (symbol->type->kind == STRUCTURE || symbol->type->kind == FUNCTION) {
        // 结构体或函数插入到全局红黑树
        if (symbol->type->kind == STRUCTURE) {
            current = ((SymbolTable*)context)->globalStructRoot;
            ((SymbolTable*)context)->globalStructRoot = newRBNode;
        } else {
            current = ((SymbolTable*)context)->globalFuncRoot;
            ((SymbolTable*)context)->globalFuncRoot = newRBNode;
        }
    } else {
        // 普通变量插入到当前作用域
        scope = (ScopeRBNode*)context;
        current = scope->root;
    }

    // 找到插入位置
    while (current != NULL) {
        parent = current;
        if (strcmp(newRBNode->symbol->name, current->symbol->name) < 0) {
            current = current->left;
        } else {
            current = current->right;
        }
    }

    newRBNode->parent = parent;

    if (parent == NULL) {
        if (symbol->type->kind == STRUCTURE) {
            ((SymbolTable*)context)->globalStructRoot = newRBNode;
        } else if (symbol->type->kind == FUNCTION) {
            ((SymbolTable*)context)->globalFuncRoot = newRBNode;
        } else {
            scope->root = newRBNode;
        }
    } else if (strcmp(newRBNode->symbol->name, parent->symbol->name) < 0) {
        parent->left = newRBNode;
    } else {
        parent->right = newRBNode;
    }

    // 修复红黑树性质
    if (symbol->type->kind == STRUCTURE || symbol->type->kind == FUNCTION) {
        fixViolation(newRBNode, NULL);
    } else {
        fixViolation(newRBNode, scope);
    }
}
// 查找符号（支持嵌套作用域）
RBNode search(char* name, SymbolTable* symTable) {
    ScopeRBNode* current = symTable->currentScope;
    while (current != NULL) {
        RBNode currentTree = current->root;
        while (currentTree != NULL) {
            int cmp = strcmp(name, currentTree->symbol->name);
            if (cmp == 0) {
                return currentTree;
            } else if (cmp < 0) {
                currentTree = currentTree->left;
            } else {
                currentTree = currentTree->right;
            }
        }
        current = current->next; // 未找到，递归查找外层作用域
    }
    // 检查全局结构体和函数定义
    RBNode structRBNode = symTable->globalStructRoot;
    while (structRBNode != NULL) {
        if (strcmp(name, structRBNode->symbol->name) == 0) {
            return structRBNode;
        }
        structRBNode = structRBNode->right;
    }
    RBNode funcRBNode = symTable->globalFuncRoot;
    while (funcRBNode != NULL) {
        if (strcmp(name, funcRBNode->symbol->name) == 0) {
            return funcRBNode;
        }
        funcRBNode = funcRBNode->right;
    }
    return NULL; // 未找到
}

// 打印树（中序遍历）
void printTree(RBNode node) {
    if (node != NULL) {
        printTree(node->left);
        printf("Symbol: %s, Color: %s\n", node->symbol->name, node->color == RED ? "RED" : "BLACK");
        printTree(node->right);
    }
}

// 打印作用域链
void printScopeChain(SymbolTable* symTable) {
    ScopeRBNode* current = symTable->currentScope;
    while (current != NULL) {
        printf("Current Scope:\n");
        printTree(current->root);
        current = current->next;
    }
    printf("Global Structs:\n");
    printTree(symTable->globalStructRoot);
    printf("Global Functions:\n");
    printTree(symTable->globalFuncRoot);
}

// 初始化符号表
void initSymbolTable(SymbolTable* symTable) {
    symTable->currentScope = createScope();
    symTable->globalStructRoot = NULL;
    symTable->globalFuncRoot = NULL;
}

// 进入新作用域
void enterScope(SymbolTable* symTable) {
    ScopeRBNode* newScope = createScope();
    newScope->next = symTable->currentScope;
    symTable->currentScope = newScope;
}

// 退出当前作用域
void exitScope(SymbolTable* symTable) {
    if (symTable->currentScope->next != NULL) {
        ScopeRBNode* oldScope = symTable->currentScope;
        symTable->currentScope = symTable->currentScope->next;
        free(oldScope);
    }
}

#endif // _RB_TREE_H