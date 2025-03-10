#include <stdio.h>
#include "syntax.tab.h"
extern int yylex();
// extern int lines, words, chars;
extern FILE *yyin;

extern int has_error;
extern struct Node* root;  // 根节点

int main(int argc, char **argv) {
  if (argc <= 1) {
      fprintf(stderr, "Usage: %s <input file>\n", argv[0]);
      return 1;
  }

  if (!(yyin = fopen(argv[1], "r"))) {
      perror(argv[1]);
      return 1;
  }

  yyparse();

  if (!has_error) {
      print_tree(root, 0);
  }

  free_tree(root);
  return 0;
}

/*
这有助于我们不借助正则表达式来实现某些功能
1 %%
2 "//" {
3 char c = input();
4 while (c != '\n') c = input();
5 }
 */

/*
缓冲区来优化一个个读入的效率
1 YY_BUFFER_STATE bp;
2 FILE* f;
3 f = fopen(…, "r");
4 bp = yy_create_buffer(f, YY_BUF_SIZE);
5 yy_switch_to_buffer(bp);
6 …
7 yy_flush_buffer(bp);
8 …
9 yy_delete_buffer(bp);
 */

/*
Flex 库函数 unput(char c)可以将指定的字符放回输入缓冲区中，这对于宏定义等功能的实现
是很方便的。例如，假设之前定义过一个宏#define BUFFER_LEN 1024，当在输入文件中遇到字
符串 BUFFER_LEN 时，下面这段代码将该宏所对应的内容放回输入缓冲区：
1 char* p = macro_contents("BUFFER_LEN"); // p = "1024"
2 char* q = p + strlen(p);
3 while (q > p) unput(*--q); // push back right-to-left
*/

/*
TIP
例如，我们在为字符串常量书写正则表达式时，往往会写成由一对双引号引起来的所有内容
\"[^\"]*\"，但有时候被双引号引起来的内容里面也可能出现跟在转义符号之后的双引号，例
如”This is an\”example\ ””。那么如何使用 Flex 处理这种情况呢？方法之一就是借助于 yyless
和 yymore：
1 %%
2 \"[^\"]*\" {
3 if (yytext[yyleng - 2] == '\\') {
4 yyless(yyleng - 1);
5 yymore();
6 } else {
7  // process the string
8 }
9 }
*/

/*
TIP
6. Flex 宏 REJECT：
Flex 宏 REJECT 可以帮助我们识别那些互相重叠的模式。当我们执行 REJECT 之后，Flex 会
进行一系列的操作，这些操作的结果相当于将 yytext 放回输入之内，然后去试图匹配当前规则之
后的那些规则。例如，考虑下面这段 Flex 源代码：
1 %%
2 pink { npink++; REJECT; }
3 ink { nink++; REJECT; }
4 pin { npin++; REJECT; }
*/