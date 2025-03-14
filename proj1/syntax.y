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

Program: ExtDefList {
    $$ = create_node("Program", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    root = $$;
}
         ;

ExtDefList: ExtDef ExtDefList {
    $$ = create_node("ExtDefList", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
}
            | /* empty */
            {
    $$ = create_node("", 0, VALUE_OTHER);
}
            ;

ExtDef: Specifier ExtDecList SEMI {
    $$ = create_node("ExtDef", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;
}
         | Specifier SEMI {
    $$ = create_node("ExtDef", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
}
         | Specifier FunDec CompSt {
    $$ = create_node("ExtDef", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;
}
          ;

ExtDecList: VarDec {
    $$ = create_node("ExtDecList", @1.first_line, VALUE_OTHER);
    $$->child = $1;
}
            | VarDec COMMA ExtDecList {
    $$ = create_node("ExtDecList", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->next = $3;
}
            ;

Specifier: TYPE {
    $$ = create_node("Specifier", @1.first_line, VALUE_OTHER);
    $$->child = $1;
}
          | StructSpecifier {
    $$ = create_node("Specifier", @1.first_line, VALUE_OTHER);
    $$->child = $1;
}
          ;

StructSpecifier: STRUCT OptTag LC DefList RC {
    $$ = create_node("StructSpecifier", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;
    $$->child->next->next->next = $4;
    $$->child->next->next->next->next = $5;
}
                | STRUCT Tag {
    $$ = create_node("StructSpecifier", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
}
                ;

OptTag: ID {
    $$ = create_node("OptTag", @1.first_line, VALUE_OTHER);
    $$->child = $1;
}
        | /* empty */
        {
    $$ = create_node("OptTag", 0, VALUE_OTHER);
}
        ;

Tag: ID {
    $$ = create_node("Tag", @1.first_line, VALUE_OTHER);
    $$->child = $1;
}
    ;

VarDec: ID {
    $$ = create_node("VarDec", @1.first_line, VALUE_OTHER);
    $$->child = $1;
}
        | VarDec LB INT RB {
    $$ = create_node("VarDec", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;     
    $$->child->next->next->next = $4;
}
        ;

FunDec: ID LP VarList RP {
    $$ = create_node("FunDec", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;     
    $$->child->next->next->next = $4;
}
        | ID LP RP {
    $$ = create_node("FunDec", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;
}
        ;

VarList: ParamDec COMMA VarList {
    $$ = create_node("VarList", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;     
}
        | ParamDec {
    $$ = create_node("VarList", @1.first_line, VALUE_OTHER);
    $$->child = $1;
}
        ;

ParamDec: Specifier VarDec {
    $$ = create_node("ParamDec", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
}
          ;

CompSt: LC DefList StmtList RC {
    $$ = create_node("CompSt", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;     
    $$->child->next->next->next = $4;
}
        ;

StmtList: Stmt StmtList {
    $$ = create_node("StmtList", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
}
          | /* empty */
          {
    $$ = create_node("", 0, VALUE_OTHER);
}
          ;

Stmt: Exp SEMI {
    $$ = create_node("Stmt", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
}
        | CompSt {
    $$ = create_node("Stmt", @1.first_line, VALUE_OTHER);
    $$->child = $1;
}
        | RETURN Exp SEMI {
    $$ = create_node("Stmt", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;     
}
        | IF LP Exp RP Stmt %prec LOWER_THAN_ELSE {
    $$ = create_node("Stmt", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;     
    $$->child->next->next->next = $4;
    $$->child->next->next->next->next = $5;
}
        | IF LP Exp RP Stmt ELSE Stmt {
    $$ = create_node("Stmt", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;     
    $$->child->next->next->next = $4;
    $$->child->next->next->next->next = $5;
    $$->child->next->next->next->next->next = $6;
    $$->child->next->next->next->next->next->next = $7;
}
        | WHILE LP Exp RP Stmt {
    $$ = create_node("Stmt", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;     
    $$->child->next->next->next = $4;
    $$->child->next->next->next->next = $5;
}
        ;

DefList: Def DefList {
    $$ = create_node("DefList", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
}
        | /* empty */
        {
    $$ = create_node("", 0, VALUE_OTHER);
}

Def: Specifier DecList SEMI { 
        $$ = create_node("Def", @1.first_line, VALUE_OTHER);
        $$->child = $1;
        $$->child->next = $2;
        $$->child->next->next = $3;
}       
        ;

DecList: Dec {
    $$ = create_node("DecList", @1.first_line, VALUE_OTHER);
    $$->child = $1;
}
        | Dec COMMA DecList {
    $$ = create_node("DecList", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;
}
        ;

Dec: VarDec {
    $$ = create_node("Dec", @1.first_line, VALUE_OTHER);
    $$->child = $1;
}
        | VarDec ASSIGNOP Exp {
    $$ = create_node("Dec", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;
}
        ;

Exp: Exp ASSIGNOP Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;
}
        | Exp AND Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;
}
        | Exp OR Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;
}
        | Exp RELOP Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;
}
        | Exp PLUS Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;
}
        | Exp MINUS Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;
}
        | Exp STAR Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;
}
        | Exp DIV Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;
}
        | LP Exp RP {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;
}
        | MINUS Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
}
        | NOT Exp {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
}
        | ID LP Args RP {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;     
    $$->child->next->next->next = $4;
}
        | ID LP RP {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;     
}
        | Exp LB Exp RB {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;     
    $$->child->next->next->next = $4;
}
        | Exp DOT ID {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;     
}
        | ID {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
}
        | INT {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
}
        | FLOAT {
    $$ = create_node("Exp", @1.first_line, VALUE_OTHER);
    $$->child = $1;
}
        ;

Args: Exp COMMA Args {
    $$ = create_node("Args", @1.first_line, VALUE_OTHER);
    $$->child = $1;
    $$->child->next = $2;
    $$->child->next->next = $3;     
}
        | Exp {
    $$ = create_node("Args", @1.first_line, VALUE_OTHER);
    $$->child = $1;
}
        ;

%%

Node *create_node(const char *name, int line, ValueType type, ...) {
    Node *new_node = (Node *)malloc(sizeof(Node));
    new_node->name = strdup(name);
    new_node->line = line;
    new_node->value.type = type;

    va_list args;
    va_start(args, type);

    switch (type) {
        case VALUE_INT:
            new_node->value.value.int_val = va_arg(args, int);
            break;
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


int is_unit_token(const char *name) {
    static const char *unit_tokens[] = {
        "ID", "LP", "RP", "LB", "RB", "LC", "RC", "SEMI", "COMMA", 
        "ASSIGNOP", "RELOP", "PLUS", "MINUS", "STAR", "DIV", 
        "AND", "OR", "DOT", "NOT", "TYPE", "INT", "FLOAT", NULL
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
        printf(": %.2f", node->value.value.float_val);
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


/* void print_tree(Node *node, int indent) {
    if (!node) return;

    for (int i = 0; i < indent; i++) printf(" ");
    printf("%s (%d)", node->name, node->line);

    if (node->value.type == VALUE_INT) {
        printf(", Value: %d", node->value.value.int_val);
    } else if (node->value.type == VALUE_FLOAT) {
        printf(", Value: %.2f", node->value.value.float_val);
    } else if (node->value.type == VALUE_STRING) {
        printf(", Value: %s", node->value.value.str_val);
    }
    printf("\n");

    Node *child = node->child;
    while (child) {
        print_tree(child, indent + 2);
        child = child->next;
    }
} */

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
    fprintf(stderr, "Error type B at line %d: %s.\n", yylineno, msg);
    has_error = 1;
}