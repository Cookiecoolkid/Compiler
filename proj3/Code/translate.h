#ifndef __TRANSLATE_H__
#define __TRANSLATE_H__

#include "command.h"
#include "rb_tree.h"


void translate_program(Node *root, FILE *file);
void translate_extDefList(Node *extDefList, FILE *file);
void translate_extDef(Node *extDef, FILE *file);
void translate_specifier(Node *specifier, FILE *file);
void translate_extDecList(Node *extDecList, FILE *file);
void translate_funDec(Node *funDec, FILE *file);
void translate_compSt(Node *compSt, FILE *file);
operand translate_varDec(Node *varDec, FILE *file, bool inRecursion);
void translate_structSpecifier(Node *structSpecifier, FILE *file);
void translate_optTag(Node *optTag, FILE *file);
void translate_tag(Node *tag, FILE *file);
void translate_defList(Node *defList, FILE *file);
void translate_def(Node *def, FILE *file);
void translate_decList(Node *decList, FILE *file);
void translate_dec(Node *dec, FILE *file);
void translate_varList(Node *varList, FILE *file);
void translate_paramDec(Node *paramDec, FILE *file);
void translate_stmtList(Node *stmtList, FILE *file);
void translate_stmt(Node *stmt, FILE *file);
operand translate_exp(Node *exp, FILE *file);
void translate_args(Node *args, FILE *file);

operand translate_cond(Node *cond, FILE *file, operand label1, operand label2);

#endif // __TRANSLATE_H__