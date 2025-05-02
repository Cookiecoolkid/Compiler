#include <stdio.h>
#include "syntax.tab.h"
#include "semantic.h"
#include "translate.h"
#include "assembly.h"

extern int yylex();
// extern int lines, words, chars;
extern FILE *yyin;

extern int has_error;
extern struct Node* root;
extern void print_tree(struct Node *node, int indent);
extern void free_tree(struct Node *node);

int main(int argc, char **argv) {
  if (argc <= 3) {
    fprintf(stderr, "Usage: %s <input file> <intermediate code file> <output assembly file>\n", argv[0]);
    return 1;
  }

  if (!(yyin = fopen(argv[1], "r"))) {
    perror(argv[1]);
    return 1;
  }

  yyparse();

  FILE *intermediate_file = fopen(argv[2], "w");
  if (intermediate_file == NULL) {
    perror("Error creating intermediate code file");
    fclose(yyin);
    return 1;
  }

  FILE *assembly_file = fopen(argv[3], "w");
  if (assembly_file == NULL) {
    perror("Error creating assembly file");
    fclose(yyin);
    fclose(intermediate_file);
    return 1;
  }

  if (!has_error) {
    // print_tree(root, 0);
    check_semantic(root);
    translate_program(root, intermediate_file);
    fclose(intermediate_file);
    
    // 重新打开中间代码文件用于读取
    intermediate_file = fopen(argv[2], "r");
    if (intermediate_file == NULL) {
      perror("Error opening intermediate code file for reading");
      fclose(assembly_file);
      return 1;
    }
    
    // 将中间代码翻译为MIPS汇编
    translate_to_mips(intermediate_file, assembly_file);
  }

  fclose(intermediate_file);
  fclose(assembly_file);
  free_tree(root);
  return 0;
}
