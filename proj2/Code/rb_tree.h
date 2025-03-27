#ifndef _RB_TREE_H
#define _RB_TREE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Type_* Type;
typedef struct FieldList_* FieldList;
typedef struct Symbol_* Symbol;
typedef struct Node_* Node;
enum Color { RED, BLACK };

// 定义符号类型
struct Symbol_ {
  char* name;
  Type type;
};

// 定义类型
struct Type_ {
  enum { BASIC, ARRAY, STRUCTURE } kind;
  union {
    int basic;
    struct { Type elem; int size; } array;
    FieldList structure;
  } u;
};

// 定义字段列表
struct FieldList_ {
  char* name;
  Type type;
  FieldList tail;
};

// 定义红黑树节点
struct Node_ {
  Symbol symbol;
  Node left;
  Node right;
  Node parent;
  enum Color color;
};

// 全局变量，表示红黑树的根节点
Node root = NULL;

// 创建新节点
Node createNode(Symbol symbol) {
  Node newNode = (Node)malloc(sizeof(struct Node_));
  newNode->symbol = symbol;
  newNode->left = NULL;
  newNode->right = NULL;
  newNode->parent = NULL;
  newNode->color = RED; // 新节点默认为红色
  return newNode;
}

// 左旋操作
void leftRotate(Node node) {
  Node rightChild = node->right;
  node->right = rightChild->left;
  if (rightChild->left != NULL) {
    rightChild->left->parent = node;
  }
  rightChild->parent = node->parent;
  if (node->parent == NULL) {
    root = rightChild;
  } else if (node == node->parent->left) {
    node->parent->left = rightChild;
  } else {
    node->parent->right = rightChild;
  }
  rightChild->left = node;
  node->parent = rightChild;
}

// 右旋操作
void rightRotate(Node node) {
  Node leftChild = node->left;
  node->left = leftChild->right;
  if (leftChild->right != NULL) {
    leftChild->right->parent = node;
  }
  leftChild->parent = node->parent;
  if (node->parent == NULL) {
    root = leftChild;
  } else if (node == node->parent->right) {
    node->parent->right = leftChild;
  } else {
    node->parent->left = leftChild;
  }
  leftChild->right = node;
  node->parent = leftChild;
}

// 修复红黑树的性质
void fixViolation(Node node) {
  Node parent = NULL;
  Node grandparent = NULL;

  while ((node != root) && (node->color == RED) && (node->parent->color == RED)) {
    parent = node->parent;
    grandparent = node->parent->parent;

    // 父节点是祖父节点的左孩子
    if (parent == grandparent->left) {
      Node uncle = grandparent->right;

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
        }

        // 情况3：叔叔是黑色，当前节点是左孩子
        rightRotate(grandparent);
        parent->color = BLACK;
        grandparent->color = RED;
        node = parent;
      }
    } else {
      // 父节点是祖父节点的右孩子
      Node uncle = grandparent->left;

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
  root->color = BLACK;
}

// 插入节点到红黑树
void insert(Symbol symbol) {
  Node newNode = createNode(symbol);
  Node current = root;
  Node parent = NULL;

  // 找到插入位置
  while (current != NULL) {
    parent = current;
    if (strcmp(newNode->symbol->name, current->symbol->name) < 0) {
      current = current->left;
    } else {
      current = current->right;
    }
  }

  newNode->parent = parent;

  if (parent == NULL) {
    root = newNode;
  } else if (strcmp(newNode->symbol->name, parent->symbol->name) < 0) {
    parent->left = newNode;
  } else {
    parent->right = newNode;
  }

  // 修复红黑树性质
  fixViolation(newNode);
}

// 查找节点
Node search(char* name) {
  Node current = root;
  while (current != NULL) {
    int cmp = strcmp(name, current->symbol->name);
    if (cmp == 0) {
      return current;
    } else if (cmp < 0) {
      current = current->left;
    } else {
      current = current->right;
    }
  }
  return NULL; // 未找到
}

// 打印树（中序遍历）
void printTree(Node node) {
  if (node != NULL) {
    printTree(node->left);
    printf("Symbol: %s, Color: %s\n", node->symbol->name, node->color == RED ? "RED" : "BLACK");
    printTree(node->right);
  }
}

#endif // _RB_TREE_H