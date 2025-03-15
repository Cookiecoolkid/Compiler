%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

#include "node.h"
#include "syntax.tab.h"

extern void yyerror(const char* msg);
extern int has_error;


int yycolumn = 1;
#define YY_USER_ACTION \
yylloc.first_line = yylloc.last_line = yylineno; \
yylloc.first_column = yycolumn; \
yylloc.last_column = yycolumn + yyleng - 1; \
yycolumn += yyleng;
%}

%option yylineno
%x IN_COMMENT

INT (0|[1-9][0-9]*|0[0-7]+|0[xX][0-9a-fA-F]+)
FLOAT [0-9]+"."[0-9]+|[0-9]+"."[0-9]*[eE][+-]?[0-9]+|[0-9]*"."[0-9]+[eE][+-]?[0-9]+
ID [a-zA-Z_][a-zA-Z0-9_]*
SEMI ";"
COMMA ","
ASSIGNOP "="
RELOP (">="|"<="|"=="|"!="|">"|"<")
PLUS "\+"
MINUS "-"
STAR "\*"
DIV "/"
AND "&&"
OR "\|\|"
DOT "\."
NOT "!"
TYPE ("int"|"float")
LP "\("
RP "\)"
LB "\["
RB "\]"
LC "\{"
RC "\}"
STRUCT "struct"
RETURN "return"
IF "if"
ELSE "else"
WHILE "while"


%%
{STRUCT} { yylval.node = create_node("STRUCT", yylineno, VALUE_OTHER); return STRUCT; }
{RETURN} { yylval.node = create_node("RETURN", yylineno, VALUE_OTHER); return RETURN; }
{IF}     { yylval.node = create_node("IF", yylineno, VALUE_OTHER); return IF; }
{ELSE}   { yylval.node = create_node("ELSE", yylineno, VALUE_OTHER); return ELSE; }
{WHILE}  { yylval.node = create_node("WHILE", yylineno, VALUE_OTHER); return WHILE; }
{TYPE}   { yylval.node = create_node("TYPE", yylineno, VALUE_STRING, strdup(yytext)); return TYPE; }
{INT}    { yylval.node = create_node("INT", yylineno, VALUE_INT, yytext); return INT; }
{FLOAT}  { yylval.node = create_node("FLOAT", yylineno, VALUE_FLOAT, atof(yytext)); return FLOAT; }
{ID}     { yylval.node = create_node("ID", yylineno, VALUE_STRING, strdup(yytext)); return ID; }

{SEMI}     { yylval.node = create_node("SEMI", yylineno, VALUE_OTHER); return SEMI; }
{COMMA}    { yylval.node = create_node("COMMA", yylineno, VALUE_OTHER); return COMMA; }
{ASSIGNOP} { yylval.node = create_node("ASSIGNOP", yylineno, VALUE_OTHER); return ASSIGNOP; }
{RELOP}    { yylval.node = create_node("RELOP", yylineno, VALUE_OTHER); return RELOP; } 
{PLUS}     { yylval.node = create_node("PLUS", yylineno, VALUE_OTHER); return PLUS; }
{MINUS}    { yylval.node = create_node("MINUS", yylineno, VALUE_OTHER); return MINUS; }
{STAR}     { yylval.node = create_node("STAR", yylineno, VALUE_OTHER); return STAR; }
{DIV} { yylval.node = create_node("DIV", yylineno, VALUE_OTHER); return DIV; }
{AND} { yylval.node = create_node("AND", yylineno, VALUE_OTHER); return AND; }
{OR}  { yylval.node = create_node("OR", yylineno, VALUE_OTHER); return OR; }
{DOT} { yylval.node = create_node("DOT", yylineno, VALUE_OTHER); return DOT; }
{NOT} { yylval.node = create_node("NOT", yylineno, VALUE_OTHER); return NOT; }
{LP}  { yylval.node = create_node("LP", yylineno, VALUE_OTHER); return LP; }
{RP}  { yylval.node = create_node("RP", yylineno, VALUE_OTHER); return RP; }
{LB}  { yylval.node = create_node("LB", yylineno, VALUE_OTHER); return LB; }
{RB}  { yylval.node = create_node("RB", yylineno, VALUE_OTHER); return RB; }
{LC}  { yylval.node = create_node("LC", yylineno, VALUE_OTHER); return LC; }
{RC}  { yylval.node = create_node("RC", yylineno, VALUE_OTHER); return RC; }

\/\/.*\n { /* Discard single-line comment */ }

"/*"             { BEGIN(IN_COMMENT); }
<IN_COMMENT>{
  "/*"           { has_error = 1; /* printf("Error type A at Line %d: Nested comments '%s'\n", yylineno, yytext); */ }
  "*"+"/"        { BEGIN(INITIAL); }
  "*"+           ;
  [^"/*"\n]+     ;
  [/]            ; 
  \n             ; 
}


[ \t] { /* Ignore white spaces */ }
[\n] { yycolumn = 1; }
. { 
    printf("Error type A at Line %d: Mysterious character \"%s\"\n", yylineno, yytext); 
    has_error = 1; 
  }

%%