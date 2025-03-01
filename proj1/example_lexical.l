%{
#include <stdio.h>
#include <stdlib.h>

int chars = 0;  // 总字符数
int words = 0;  // 单词数
int lines = 0;  // 行数
%}

letter [a-zA-Z]
digit [0-9]

%%

{letter}+      { words++; chars += yyleng; }  // 匹配单词
{digit}+       { words++; chars += yyleng; }  // 匹配数字
[ \t]+         { /* 忽略多余的空格 */ chars += yyleng; }  // 匹配空格
\n             { lines++; chars++; }  // 匹配换行符
.              { chars++; }  // 匹配其他字符

%%

int yywrap() {
    return 1;
}