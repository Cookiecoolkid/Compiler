%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "syntax.tab.h"

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
{STRUCT} { return STRUCT; }
{RETURN} { return RETURN; }
{IF} { return IF; }
{ELSE} { return ELSE; }
{WHILE} { return WHILE; }

{TYPE} { return TYPE; }

{INT} { yylval.type_int = atoi(yytext); return INT; }

{FLOAT} { yylval.type_float = atof(yytext); return FLOAT; }

{ID} { yylval.type_str = strdup(yytext); return ID; }

{SEMI} { return SEMI; }

{COMMA} { return COMMA; }

{ASSIGNOP} { return ASSIGNOP; }

{RELOP} { return RELOP; }

{PLUS} { return PLUS; }
{MINUS} { return MINUS; }

{STAR} { return STAR; }
{DIV} { return DIV; }

{AND} { return AND; }
{OR} { return OR; }

{DOT} { return DOT; }

{NOT} { return NOT; }

{LP} { return LP; } 
{RP} { return RP; }

{LB} { return LB; }
{RB} { return RB; }

{LC} { return LC; }
{RC} { return RC; }

\/\/.*\n { /* Discard single-line comment */ }


"/*"             { BEGIN(IN_COMMENT); }
<IN_COMMENT>{
  "/*"           { printf("Error type A at Line %d: Nested comments '%s'\n", yylineno, yytext); }
  "*"+"/"        { BEGIN(INITIAL); }
  "*"+           ;
  [^"/*"\n]+     ; 
  [/]            ; 
  \n             ; 
}


[ \t] { /* Ignore white spaces */ }
[\n] { yycolumn = 1; }
. { printf("Error type A at Line %d: Mysterious character '%s'\n", yylineno, yytext); }

%%

yyerror(char *s) {
  fprintf(stderr, "syntax error: %s\n", s);
}