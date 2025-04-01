#include "rb_tree.h"
#include <string.h>
#include <stdbool.h>

// 全局符号表实例
SymbolTable symTable;
struct_t structID;

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
            if (node->symbol->type->kind == STRUCTURE) {
                symTable.globalStructRoot = node;
            } else if (node->symbol->type->kind == FUNCTION) {
                symTable.globalFuncRoot = node;
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
            current = symTable.globalStructRoot;
            symTable.globalStructRoot = newRBNode;
        } else {
            current = symTable.globalFuncRoot;
            symTable.globalFuncRoot = newRBNode;
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
            symTable.globalStructRoot = newRBNode;
        } else if (symbol->type->kind == FUNCTION) {
            symTable.globalFuncRoot = newRBNode;
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
RBNode search(char* name, bool isDef) {
    if (!isDef) {
      ScopeRBNode* current = symTable.currentScope;
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
      return NULL;
    }
    // 检查全局结构体和函数定义
    // FIXME: should I add arg to differentiate struct and func?(when funcName == structName)
    RBNode structRBNode = symTable.globalStructRoot;
    while (structRBNode != NULL) {
        if (strcmp(name, structRBNode->symbol->name) == 0) {
            return structRBNode;
        }
        structRBNode = structRBNode->right;
    }
    RBNode funcRBNode = symTable.globalFuncRoot;
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
void printScopeChain() {
    ScopeRBNode* current = symTable.currentScope;
    while (current != NULL) {
        printf("Current Scope:\n");
        printTree(current->root);
        current = current->next;
    }
    printf("Global Structs:\n");
    printTree(symTable.globalStructRoot);
    printf("Global Functions:\n");
    printTree(symTable.globalFuncRoot);
}

/* ====================== Symbol Table and Scope ====================== */

// 初始化符号表
void initSymbolTable() {
    symTable.currentScope = createScope();
    symTable.globalStructRoot = NULL;
    symTable.globalFuncRoot = NULL;
}

// 进入新作用域
void enterScope() {
    ScopeRBNode* newScope = createScope();
    newScope->next = symTable.currentScope;
    symTable.currentScope = newScope;
}

// 退出当前作用域
void exitScope() {
    if (symTable.currentScope->next != NULL) {
        ScopeRBNode* oldScope = symTable.currentScope;
        symTable.currentScope = symTable.currentScope->next;
        free(oldScope);
    }
}


/* ====================== Create Symbol and Type ====================== */
// 辅助函数：创建符号
Symbol createSymbol(const char* name, Type type) {
    Symbol newSymbol = (Symbol)malloc(sizeof(struct Symbol_));
    newSymbol->name = strdup(name);
    newSymbol->type = type;
    return newSymbol;
}

FieldList createFieldList(const char* name, Type type) {
    FieldList newField = (FieldList)malloc(sizeof(struct FieldList_));
    newField->name = strdup(name);
    newField->type = type;
    newField->tail = NULL;
    return newField;
}

// 辅助函数：创建基本类型
Type createBasicType(int basicType) {
    Type newType = (Type)malloc(sizeof(struct Type_));
    newType->kind = BASIC;
    newType->u.basic = basicType;
    return newType;
}

// 辅助函数：创建结构体类型
Type createStructType(FieldList fields) {
    Type newType = (Type)malloc(sizeof(struct Type_));
    newType->kind = STRUCTURE;
    newType->u.structure.struct_members = fields;
    return newType;
}

// 辅助函数：创建函数类型
Type createFunctionType(FieldList params, Type retType, int paramNum) {
    Type newType = (Type)malloc(sizeof(struct Type_));
    newType->kind = FUNCTION;
    newType->u.function.params = params;
    newType->u.function.ret = retType;
    newType->u.function.paramNum = paramNum;
    newType->u.function.defined = 0;
    newType->u.function.declared = 0;
    return newType;
}

void appendFieldList(FieldList* fl, FieldList newField) {
    if (*fl == NULL) {
        *fl = newField;
    } else {
        FieldList current = *fl;
        while (current->tail != NULL) {
            current = current->tail;
        }
        current->tail = newField;
    }
}