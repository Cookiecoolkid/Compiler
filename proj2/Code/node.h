#pragma once

typedef enum {
    VALUE_INT,
    VALUE_FLOAT,
    VALUE_STRING,
    VALUE_OTHER
} ValueType;

typedef struct {
    ValueType type;
    union {
        int int_val;
        float float_val;
        char *str_val;
    } value;
} NodeValue;

typedef struct Node {
    char *name;
    int line;
    NodeValue value;
    struct Node *next;
    struct Node *child;
} Node;

Node *create_node(const char *name, int line, ValueType type, ...);
void link_nodes(Node *parent, ...);
void print_tree(Node *node, int indent);
void free_tree(Node *node);
int get_child_num(Node *node);