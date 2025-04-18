#include "rb_tree.h"
#include <string.h>
#include <stdbool.h>

char* strdup(const char* s);

// 全局符号表实例
SymbolTable symTable;
struct_t structID;

// 函数声明
ScopeRBNode* createScope();
RBNode createRBNode(Symbol symbol);
void updateRoot(RBNode node);
void leftRotate(RBNode node);
void rightRotate(RBNode node);
void fixViolation(RBNode node);
void printTree(RBNode node);
void printScopeChain();

// 添加辅助函数的声明
Symbol createSymbol(const char* name, Type type);
FieldList createFieldList(const char* name, Type type);
Type createBasicType(int basicType);
Type createArrayType(Type elem, int size);
Type createStructType(FieldList struct_members);
Type createFunctionType(FieldList params, Type retType, int paramNum);

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
void updateRoot(RBNode node) {
    if (node->parent == NULL) {
        // 全局红黑树的根节点
        if (node->symbol->type->kind == STRUCTURE) {
            symTable.globalStructRoot = node;
        } else if (node->symbol->type->kind == FUNCTION) {
            symTable.globalFuncRoot = node;
        } else {
            symTable.currentScope->root = node;
        }
    }
}

// 左旋操作
void leftRotate(RBNode node) {
    RBNode rightChild = node->right;
    node->right = rightChild->left;
    if (rightChild->left != NULL) {
        rightChild->left->parent = node;
    }
    rightChild->parent = node->parent;
    if (node->parent == NULL) {
        updateRoot(rightChild);
    } else if (node == node->parent->left) {
        node->parent->left = rightChild;
    } else {
        node->parent->right = rightChild;
    }
    rightChild->left = node;
    node->parent = rightChild;
}

// 右旋操作
void rightRotate(RBNode node) {
    RBNode leftChild = node->left;
    node->left = leftChild->right;
    if (leftChild->right != NULL) {
        leftChild->right->parent = node;
    }
    leftChild->parent = node->parent;
    if (node->parent == NULL) {
        updateRoot(leftChild);
    } else if (node == node->parent->right) {
        node->parent->right = leftChild;
    } else {
        node->parent->left = leftChild;
    }
    leftChild->right = node;
    node->parent = leftChild;
}

// 修复红黑树的性质
void fixViolation(RBNode node) {
    RBNode parent = NULL;
    RBNode grandparent = NULL;

    // 如果是全局红黑树，context为SymbolTable指针
    while (node != NULL && node->color == RED && node->parent != NULL && node->parent->color == RED) {
        parent = node->parent;
        grandparent = parent->parent;

        if (grandparent == NULL) {
            break; // 到达根节点
        }

        // 父节点是祖父节点的左孩子
        if (parent == grandparent->left) {
            RBNode uncle = (grandparent->right != NULL) ? grandparent->right : NULL;

            // 情况1：叔叔是红色
            if (uncle != NULL && uncle->color == RED) {
                grandparent->color = RED;
                parent->color = BLACK;
                uncle->color = BLACK;
                node = grandparent;
            } else {
                // 情况2：叔叔是黑色，当前节点是右孩子
                if (node == parent->right) {
                    leftRotate(parent);
                    node = parent;
                    parent = node->parent;
                    grandparent = parent->parent;
                }

                // 情况3：叔叔是黑色，当前节点是左孩子
                rightRotate(grandparent);
                parent->color = BLACK;
                grandparent->color = RED;
                node = parent;
            }
        } else {
            // 父节点是祖父节点的右孩子
            RBNode uncle = (grandparent->left != NULL) ? grandparent->left : NULL;

            // 情况1：叔叔是红色
            if (uncle != NULL && uncle->color == RED) {
                grandparent->color = RED;
                parent->color = BLACK;
                uncle->color = BLACK;
                node = grandparent;
            } else {
                // 情况2：叔叔是黑色，当前节点是左孩子
                if (node == parent->left) {
                    rightRotate(parent);
                    node = parent;
                    parent = node->parent;
                    grandparent = parent->parent;
                }

                // 情况3：叔叔是黑色，当前节点是右孩子
                leftRotate(grandparent);
                parent->color = BLACK;
                grandparent->color = RED;
                node = parent;
            }
        }
    }

    // 确保根节点是黑色
    if (symTable.globalStructRoot != NULL && symTable.globalStructRoot->parent == NULL) {
        symTable.globalStructRoot->color = BLACK;
    }
    if (symTable.globalFuncRoot != NULL && symTable.globalFuncRoot->parent == NULL) {
        symTable.globalFuncRoot->color = BLACK;
    }
}

// 插入节点到红黑树
void insert(Symbol symbol) {
    RBNode newRBNode = createRBNode(symbol);
    RBNode current = NULL;
    RBNode parent = NULL;
    ScopeRBNode* scope = NULL;

    // 判断符号类型
    if (symbol->type->kind == STRUCTURE || symbol->type->kind == FUNCTION) {
        // 结构体或函数插入到全局红黑树
        if (symbol->type->kind == STRUCTURE) {
            current = symTable.globalStructRoot;
        } else {
            current = symTable.globalFuncRoot;
        }
    } else {
        // 普通变量插入到当前作用域
        scope = symTable.currentScope;
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
    fixViolation(newRBNode);
}

// 查找符号（支持嵌套作用域）
RBNode search(char* name, bool isDef) {
    if (!isDef) {
        // 查找局部作用域
        ScopeRBNode* current = symTable.currentScope;
        while (current != NULL) {
            RBNode currentTree = current->root;
            RBNode result = searchRBTree(currentTree, name);
            if (result != NULL) {
                return result;
            }
            current = current->next; // 未找到，递归查找外层作用域
        }
        return NULL;
    }
    // FIXME：检查 结构体和函数是否允许重名（C语言似乎可以）
    // 检查全局结构体定义
    RBNode structRBNode = symTable.globalStructRoot;
    RBNode result = searchRBTree(structRBNode, name);
    if (result != NULL) {
        return result;
    }
    // 结构体也可以使用 StructID 查询（若 name 找不到）
    struct_t structID = (struct_t)atoi(name);
    if (structID >= BASIC_TYPE_NUM) {
        result = searchByStructID(structRBNode, structID);
        if (result != NULL) {
            return result;
        }
    }

    // 检查全局函数定义
    RBNode funcRBNode = symTable.globalFuncRoot;
    result = searchRBTree(funcRBNode, name);
    if (result != NULL) {
        return result;
    }

    return NULL; // 未找到
}

RBNode searchByStructID (RBNode node, struct_t structID) {
    // 遍历所有全局结构体定义
    if (node == NULL) {
        return NULL;
    }
    if (node->left != NULL) {
        RBNode leftResult = searchByStructID(node->left, structID);
        if (leftResult != NULL) {
            return leftResult;
        }
    }
    if (node->symbol->type->kind == STRUCTURE && node->symbol->type->u.structure.ID == structID) {
        return node; // 找到匹配的结构体
    }
    if (node->right != NULL) {
        RBNode rightResult = searchByStructID(node->right, structID);
        if (rightResult != NULL) {
            return rightResult;
        }
    }

    return NULL;
}

// 辅助函数：在红黑树中查找符号
RBNode searchRBTree(RBNode root, char* name) {
    while (root != NULL) {
        int cmp = strcmp(name, root->symbol->name);
        if (cmp == 0) {
            return root; // 找到匹配的符号
        } else if (cmp < 0) {
            root = root->left; // 向左子树查找
        } else {
            root = root->right; // 向右子树查找
        }
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
    // 初始化全局符号表
    symTable.currentScope = createScope();
    symTable.globalStructRoot = NULL;
    symTable.globalFuncRoot = NULL;

    // 添加预定义的read函数
    Type readRetType = createBasicType(INT_);
    Type readFuncType = createFunctionType(NULL, readRetType, 0);
    readFuncType->u.function.defined = 1;
    Symbol readSymbol = createSymbol("read", readFuncType);
    insert(readSymbol);

    // 添加预定义的write函数
    Type writeParamType = createBasicType(INT_);
    FieldList writeParam = createFieldList("write_param", writeParamType);
    Type writeRetType = createBasicType(INT_);
    Type writeFuncType = createFunctionType(writeParam, writeRetType, 1);
    writeFuncType->u.function.defined = 1;
    Symbol writeSymbol = createSymbol("write", writeFuncType);
    insert(writeSymbol);

    structID = BASIC_TYPE_NUM; // 从 2 开始, 0 和 1 分别表示 INT 和 FLOAT
}

// 进入新作用域
void enterScope() {
    ScopeRBNode* newScope = createScope();
    newScope->root = NULL;
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
    newSymbol->isParam = false;  // 默认不是函数参数
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

// 辅助函数：创建数组类型
Type createArrayType(Type elemType, int size) {
    Type newType = (Type)malloc(sizeof(struct Type_));
    newType->kind = ARRAY;
    newType->u.array.elem = elemType;
    newType->u.array.size = size;
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
    newType->u.function.declare_lineno = 0;
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

FieldList searchFieldList(FieldList fl, const char* name) {
    FieldList current = fl;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return current;
        }
        current = current->tail;
    }
    return NULL;
}