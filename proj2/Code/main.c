#include <stdio.h>
#include "syntax.tab.h"
#include "semantic.h"
extern int yylex();
// extern int lines, words, chars;
extern FILE *yyin;

extern int has_error;
extern struct Node* root;
extern void print_tree(struct Node *node, int indent);
extern void free_tree(struct Node *node);

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
      // print_tree(root, 0);
      check_semantic(root);
  }

  free_tree(root);
  return 0;
}