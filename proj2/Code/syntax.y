%locations
%{
#include "lex.yy.c"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "node.h"

Node *root = NULL;
int has_error = 0;


%}

%union {
  struct Node* node;
}

%type <node> Program ExtDefList ExtDecList ExtDef Specifier FunDec CompSt StmtList Stmt Def DefList DecList Dec Exp Args
%type <node> StructSpecifier OptTag Tag VarDec VarList ParamDec

%token <node> STRUCT
%token <node> RETURN
%token <node> IF
%token <node> ELSE
%token <node> WHILE
%token <node> TYPE
%token <node> INT
%token <node> FLOAT
%token <node> ID
%token <node> SEMI
%token <node> COMMA
%token <node> ASSIGNOP
%token <node> RELOP
%token <node> PLUS
%token <node> MINUS
%token <node> STAR
%token <node> DIV
%token <node> AND
%token <node> OR
%token <node> DOT
%token <node> NOT
%token <node> LP
%token <node> RP
%token <node> LB
%token <node> RB
%token <node> LC
%token <node> RC

%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT
%left DOT
%left LB RB
%left LP RP
%left LC RC
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%%

/* ------------------------- Program ---------------------------*/

Program: ExtDefList {
    $$ = create_node("Program", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, NULL);
    root = $$;
};

/* ------------------------- ExtDefList ---------------------------*/

ExtDefList: ExtDef ExtDefList {
    $$ = create_node("ExtDefList", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, NULL);
}
| /* empty */ {
    $$ = create_node("", 0, VALUE_OTHER);
    link_nodes($$, NULL);
};

/* ------------------------- ExtDef ---------------------------*/

ExtDef: Specifier ExtDecList SEMI {
    $$ = create_node("ExtDef", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, NULL);
}
| Specifier SEMI {
    $$ = create_node("ExtDef", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, NULL);
}
| Specifier FunDec CompSt {
    $$ = create_node("ExtDef", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, NULL);
}
| Specifier error SEMI {
    /* yyerror("ExtDef syntax error"); */
};

/* ------------------------- ExtDecList ---------------------------*/

ExtDecList: VarDec {
    $$ = create_node("ExtDecList", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, NULL);
}
| VarDec COMMA ExtDecList {
    $$ = create_node("ExtDecList", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $3, NULL);
};

/* ------------------------- Specifier ---------------------------*/

Specifier: TYPE {
    $$ = create_node("Specifier", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, NULL);
}
| StructSpecifier {
    $$ = create_node("Specifier", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, NULL);
};

/* ------------------------- StructSpecifier ---------------------------*/

StructSpecifier: STRUCT OptTag LC DefList RC {
    $$ = create_node("StructSpecifier", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, $4, $5, NULL);
}
| STRUCT Tag {
    $$ = create_node("StructSpecifier", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, NULL);
}
| STRUCT OptTag LC error RC {
    /* ("StructSpecifier syntax error"); */
}
| STRUCT error LC DefList RC {
    /* ("StructSpecifier syntax error"); */
}
| STRUCT error {
    /* ("StructSpecifier syntax error"); */
}

/* ------------------------- OptTag ---------------------------*/

OptTag: ID {
    $$ = create_node("OptTag", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, NULL);
}
| /* empty */{
    $$ = create_node("OptTag", 0, VALUE_OTHER);
    link_nodes($$, NULL);
};

/* ------------------------- Tag ---------------------------*/

Tag: ID {
    $$ = create_node("Tag", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, NULL);
};

/* ------------------------- VarDec ---------------------------*/

VarDec: ID {
    $$ = create_node("VarDec", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, NULL);
}
| VarDec LB INT RB {
    $$ = create_node("VarDec", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, $4, NULL);
};

/* ------------------------- FunDec ---------------------------*/

FunDec: ID LP VarList RP {
    $$ = create_node("FunDec", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, $4, NULL);
}
| ID LP RP {
    $$ = create_node("FunDec", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, NULL);
}
| ID LP error RP {
    /* yyerror("FunDec syntax error"); */
};

/* ------------------------- VarList ---------------------------*/

VarList: ParamDec COMMA VarList {
    $$ = create_node("VarList", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $3, NULL);
}
| ParamDec {
    $$ = create_node("VarList", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, NULL);
};

/* ------------------------- ParamDec ---------------------------*/

ParamDec: Specifier VarDec {
    $$ = create_node("ParamDec", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, NULL);
};

/* ------------------------- CompSt ---------------------------*/

CompSt: LC DefList StmtList RC {
    $$ = create_node("CompSt", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, $4, NULL);
}
| LC error StmtList RC {
    /*yyerror("CompSt syntax error");*/
};

/* ------------------------- StmtList ---------------------------*/

StmtList: Stmt StmtList {
    $$ = create_node("StmtList", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, NULL);
}
| /* empty */{
    $$ = create_node("", 0, VALUE_OTHER);
    link_nodes($$, NULL);
};

/* ------------------------- Stmt ---------------------------*/

Stmt: Exp SEMI {
    $$ = create_node("Stmt", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, NULL);
}
| CompSt {
    $$ = create_node("Stmt", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, NULL);
}
| RETURN Exp SEMI {
    $$ = create_node("Stmt", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, NULL);
}
| IF LP Exp RP Stmt %prec LOWER_THAN_ELSE {
    $$ = create_node("Stmt", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, $4, $5, NULL);
}
| IF LP Exp RP Stmt ELSE Stmt {
    $$ = create_node("Stmt", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, $4, $5, $6, $7, NULL);
}
| WHILE LP Exp RP Stmt {
    $$ = create_node("Stmt", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, $4, $5, NULL);
}
| error SEMI {
    /*yyerror("Stmt syntax error");*/
}
| RETURN error SEMI {
    /*yyerror("Stmt syntax error");*/
}
| IF LP error RP Stmt {
    /*yyerror("Stmt syntax error");*/
}
| IF LP error RP Stmt ELSE Stmt {
    /*yyerror("Stmt syntax error");*/
}
| WHILE LP error RP Stmt {
    /*yyerror("Stmt syntax error");*/
}
| Exp error {
    /*yyerror("Stmt syntax error");*/
}
| RETURN Exp error {
    /*yyerror("Stmt syntax error");*/
}

/* ------------------------- DefList ---------------------------*/

DefList: Def DefList {
    $$ = create_node("DefList", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, NULL);
}
| /* empty */ {
    $$ = create_node("", 0, VALUE_OTHER);
    link_nodes($$, NULL);
};

/* ------------------------- Def ---------------------------*/

Def: Specifier DecList SEMI { 
    $$ = create_node("Def", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, NULL);
}
| Specifier error SEMI {
    /*yyerror("Def syntax error");*/
};

/* ------------------------- DecList ---------------------------*/

DecList: Dec {
    $$ = create_node("DecList", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, NULL);
}
| Dec COMMA DecList {
    $$ = create_node("DecList", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $3, NULL);
};

/* ------------------------- Dec ---------------------------*/

Dec: VarDec {
    $$ = create_node("Dec", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, NULL);
}
| VarDec ASSIGNOP Exp {
    $$ = create_node("Dec", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, NULL);
};

/* ------------------------- Exp ---------------------------*/

Exp: Exp ASSIGNOP Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, NULL);
}
| Exp AND Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, NULL);
}
| Exp OR Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, NULL);
}
| Exp RELOP Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, NULL);
}
| Exp PLUS Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, NULL);
}
| Exp MINUS Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, NULL);
}
| Exp STAR Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, NULL);
}
| Exp DIV Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, NULL);
}
| LP Exp RP {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, NULL);
}
| MINUS Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, NULL);
}
| NOT Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, NULL);
}
| ID LP Args RP {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, $4, NULL);
}
| ID LP RP {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, NULL);
}
| Exp LB Exp RB {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, $4, NULL);
}
| Exp DOT ID {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $2, $3, NULL);
}
| ID {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, NULL);
}
| INT {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, NULL);
}
| FLOAT {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, NULL);
}
| Exp ASSIGNOP error {
    /* yyerror("Exp syntax error"); */
}
| Exp AND error {
    /* yyerror("Exp syntax error"); */
}
| Exp OR error {
    /* yyerror("Exp syntax error"); */
}
| Exp RELOP error {
    /* yyerror("Exp syntax error"); */
}
| Exp PLUS error {
    /* yyerror("Exp syntax error"); */
}
| Exp MINUS error {
    /* yyerror("Exp syntax error"); */
}
| Exp STAR error {
    /* yyerror("Exp syntax error"); */
}
| Exp DIV error {
    /* yyerror("Exp syntax error"); */
}
| NOT error {
    /* yyerror("Exp syntax error"); */
};

/* ------------------------- Args ---------------------------*/

Args: Exp COMMA Args {
    $$ = create_node("Args", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, $3, NULL);
}
| Exp {
    $$ = create_node("Args", @1.first_line, VALUE_OTHER);
    link_nodes($$, $1, NULL);
};
%%

Node *create_node(const char *name, int line, ValueType type, ...) {
    Node *new_node = (Node *)malloc(sizeof(Node));
    new_node->name = strdup(name);
    new_node->line = line;
    new_node->value.type = type;

    va_list args;
    va_start(args, type);

    switch (type) {
        case VALUE_INT: {
            char *str_val = va_arg(args, char *);
            int int_val = 0;

            // 检查 str_val 是否为 NULL
            if (str_val != NULL) { 
                if (str_val[0] == '0' && (str_val[1] == 'x' || str_val[1] == 'X')) {
                    int_val = (int)strtol(str_val, NULL, 16);
                } else if (str_val[0] == '0' && str_val[1] != '\0') {
                    int_val = (int)strtol(str_val, NULL, 8);
                } else {
                    int_val = atoi(str_val);
                }
            }

            new_node->value.value.int_val = int_val;
            break;
        }
        case VALUE_FLOAT:
            new_node->value.value.float_val = va_arg(args, double);
            break;
        case VALUE_STRING:
            new_node->value.value.str_val = va_arg(args, char *);
            break;
        case VALUE_OTHER:
            // VALUE_OTHER 类型不需要额外的值
            break;
    }

    va_end(args);

    new_node->next = NULL;
    new_node->child = NULL;
    return new_node;
}

void link_nodes(Node *parent, ...) {
    va_list args;
    va_start(args, parent);

    Node *current = parent;
    while (1) {
        Node *child = va_arg(args, Node *);
        if (child == NULL) break;

        if (current->child == NULL) {
            current->child = child;
        } else {
            current->next = child;
            current = child;
        }
    }

    va_end(args);
}

int is_unit_token(const char *name) {
    static const char *unit_tokens[] = {
        "ID", "LP", "RP", "LB", "RB", "LC", "RC", "SEMI", "COMMA", 
        "ASSIGNOP", "RELOP", "PLUS", "MINUS", "STAR", "DIV", 
        "AND", "OR", "DOT", "NOT", "TYPE", "INT", "FLOAT", "STRUCT",
        "RETURN", "IF", "ELSE", "WHILE", ""
    };

    for (int i = 0; unit_tokens[i] != NULL; i++) {
        if (strcmp(name, unit_tokens[i]) == 0) {
            return 1;
        }
    }
    return 0;
}


void print_tree(Node *node, int indent) {
    if (!node) return;

    // 如果是 "empty" 节点，直接返回，不打印任何内容
    if (strcmp(node->name, "") == 0) {
        return;
    }

    // 打印缩进
    for (int i = 0; i < indent; i++) printf(" ");

    // 打印节点名称
    printf("%s", node->name);

    // 如果不是单元 token，打印行号
    if (!is_unit_token(node->name)) {
        printf(" (%d)", node->line);
    }

    // 如果有值，打印值
    if (node->value.type == VALUE_INT) {
        printf(": %d", node->value.value.int_val);
    } else if (node->value.type == VALUE_FLOAT) {
        printf(": %f", node->value.value.float_val);
    } else if (node->value.type == VALUE_STRING) {
        printf(": %s", node->value.value.str_val);
    }
    printf("\n");

    // 递归打印子节点
    Node *child = node->child;
    while (child) {
        print_tree(child, indent + 2);
        child = child->next;
    }
}

void free_tree(Node *node) {
    if (!node) return;

    Node *child = node->child;
    while (child) {
        Node *temp = child;
        child = child->next;
        free_tree(temp);
    }

    free(node->name);
    if (node->value.type == VALUE_STRING) {
        free(node->value.value.str_val);
    }
    free(node);
}

void yyerror(const char* msg) {
    fprintf(stdout, "Error type B at line %d: %s.\n", yylineno, msg);
    has_error = 1;
}