%{
#include "lex.yy.c"
#include <stdio.h>

%locations
// Global variables for tracking indent and error flags
int indent = 0;
%}

/* Declare types for tokens */
%union {
  int type_int;
  float type_float;
  char *type_str;
}

%token STRUCT
%token RETURN
%token IF
%token ELSE
%token WHILE
%token TYPE
%token <type_int> INT
%token <type_float> FLOAT
%token <type_str> ID
%token SEMI
%token COMMA
%token ASSIGNOP
%token RELOP
%token PLUS
%token MINUS
%token STAR
%token DIV
%token AND
%token OR
%token DOT
%token NOT
%token LP
%token RP
%token LB
%token RB
%token LC
%token RC

%token UMINUS

// %type <type_float> Exp

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%right ASSIGNOP NOT UMINUS
%left LP RP LC RC 
%left DOT 
%left OR AND 
%left RELOP 
%left PLUS MINUS 
%left STAR DIV


%%

Program: ExtDefList { print_node("Program", @1.first_line); }
         ;
ExtDefList: ExtDef ExtDefList { print_node("ExtDefList", @1.first_line); }
            | /* empty */
            ;
ExtDef: Specifier ExtDecList SEMI 
         | Specifier SEMI
         | Specifier FunDec CompSt
          ;
ExtDecList: VarDec 
            | VarDec COMMA ExtDecList
            ;
Specifier: TYPE
          | StructSpecifier
          ;
StructSpecifier: STRUCT OptTag LC DefList RC
                | STRUCT Tag
                ;
OptTag: ID
        | /* empty */
        ;
Tag: ID
    ;
VarDec: ID
        | VarDec LB INT RB
        ;
FunDec: ID LP VarList RP
        | ID LP RP
        ;
VarList: ParamDec COMMA VarList
        | ParamDec
        ;
ParamDec: Specifier VarDec
          ;
CompSt: LC DefList StmtList RC
        ;
StmtList: Stmt StmtList
          | /* empty */
          ;
Stmt: Exp SEMI
        | CompSt
        | RETURN Exp SEMI
        | IF LP Exp RP Stmt %prec LOWER_THAN_ELSE
        | IF LP Exp RP Stmt ELSE Stmt
        | WHILE LP Exp RP Stmt
        ;
DefList: Def DefList
        | /* empty */
        ;
Def: Specifier DecList SEMI
        ;
DecList: Dec
        | Dec COMMA DecList
        ;
Dec: VarDec
        | VarDec ASSIGNOP Exp
        ;
Exp : Exp ASSIGNOP Exp
        | Exp AND Exp
        | Exp OR Exp
        | Exp RELOP Exp
        | Exp PLUS Exp
        | Exp MINUS Exp
        | Exp STAR Exp
        | Exp DIV Exp
        | LP Exp RP
        | UMINUS Exp
        | NOT Exp
        | ID LP Args RP
        | ID LP RP
        | Exp LB Exp RB
        | Exp DOT ID
        | ID
        | INT
        | FLOAT
        ; 
Args: Exp COMMA Args
        | Exp
        ;

%%

// Helper function for printing nodes with correct indentation
void print_node(const char *name, int line) {
  for (int i = 0; i < indent; i++) {
    printf("  ");
  }
  printf("%s (%d)\n", name, line);
  indent += 2;
}

// Additional print functions for lexical tokens
void print_token(const char *name, const char *value, int line) {
  printf("  %s: %s\n", name, value);
}
