#include <stdio.h>
#include "syntax.tab.h"
#include "semantic.h"
#include "translate.h"
extern int yylex();
// extern int lines, words, chars;
extern FILE *yyin;

extern int has_error;
extern struct Node* root;
extern void print_tree(struct Node *node, int indent);
extern void free_tree(struct Node *node);

int main(int argc, char **argv) {
  if (argc <= 2) {
    fprintf(stderr, "Usage: %s <input file> <output file>\n", argv[0]);
    return 1;
  }

  if (!(yyin = fopen(argv[1], "r"))) {
    perror(argv[1]);
    return 1;
  }

  yyparse();

  FILE *file = fopen(argv[2], "w");
  if (file == NULL) {
    perror("Error creating output file");
    fclose(yyin);
    return 1;
  }
  if (!has_error) {
    // print_tree(root, 0);
    check_semantic(root);
    translate_program(root, file);
  }

  free_tree(root);
  return 0;
}