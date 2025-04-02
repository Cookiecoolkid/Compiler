#ifndef _SEMANTIC_H
#define _SEMANTIC_H

#include "rb_tree.h"
#include "node.h"

// 错误类型枚举
enum ErrorType {
    UNDEFINED_VARIABLE = 1,          // 错误类型 1：变量在使用时未经定义
    UNDEFINED_FUNCTION_CALL,     // 错误类型 2：函数在调用时未经定义
    DUPLICATE_DEFINITION,        // 错误类型 3：变量出现重复定义，或变量与前面定义过的结构体名字重复
    DUPLICATE_FUNCTION_DEFINITION, // 错误类型 4：函数出现重复定义
    TYPE_MISMATCH_ASSIGNMENT,    // 错误类型 5：赋值号两边的表达式类型不匹配
    INVALID_LVALUE_ASSIGNMENT,   // 错误类型 6：赋值号左边出现一个只有右值的表达式
    OPERATION_TYPE_MISMATCH,     // 错误类型 7：操作数类型不匹配或操作数类型与操作符不匹配
    RETURN_TYPE_MISMATCH,        // 错误类型 8：return 语句的返回类型与函数定义的返回类型不匹配
    FUNCTION_ARGUMENT_MISMATCH,  // 错误类型 9：函数调用时实参与形参的数目或类型不匹配
    ARRAY_ACCESS_ON_NON_ARRAY,   // 错误类型 10：对非数组型变量使用“ [...] ”（数组访问）操作符
    FUNCTION_CALL_ON_NON_FUNCTION,// 错误类型 11：对普通变量使用“(…)”或“()”（函数调用）操作符
    NON_INTEGER_ARRAY_INDEX,     // 错误类型 12：数组访问操作符“ [...] ”中出现非整数
    STRUCTURE_FIELD_ON_NON_STRUCTURE, // 错误类型 13：对非结构体型变量使用“.”操作符
    UNDEFINED_STRUCTURE_FIELD,   // 错误类型 14：访问结构体中未定义过的域
    DUPLICATE_STRUCTURE_FIELD,   // 错误类型 15：结构体中域名重复定义或者在结构体中使用等号初始化
    NAME_CONFLICT_STRUCTURE_VARIABLE, // 错误类型 16：结构体的名字与前面定义过的结构体或变量的名字重复
    UNDEFINED_STRUCTURE_USAGE,   // 错误类型 17：直接使用未定义过的结构体来定义变量
    UNDEFINED_FUNCTION_DECLARATION, // 错误类型 18：函数进行了声明，但没有被定义
    CONFLICTING_FUNCTION_DECLARATION // 错误类型 19：函数的多次声明互相冲突
};

// 函数声明
void check_func_declared(RBNode funcRoot);
void report_error(enum ErrorType type, int line, const char *msg);

void check_semantic(Node *root);
void check_extDefList(Node *extDefList);
void check_extDef(Node *extDef);
void check_extDecList(Node *extDecList, Type type);
Type check_specifier(Node *specifier);
Type check_structSpecifier(Node *structSpecifier);
Type check_tag(Node *tag);
char *check_optTag(Node *optTag);
void check_defList(Node *defList, FieldList fields);
Type check_funDec(Node *funDec, Type type, int isDefine);
void check_compSt(Node *compSt, Type type);
void check_decList(Node *decList, Type type, FieldList fields);
void check_dec(Node *dec, Type type, FieldList fields);
FieldList check_varDec(Node *varDec, Type type, int isParam);
Type check_exp(Node *exp);
void check_args(Node *args, FieldList params);
void check_stmt(Node *stmt, Type type);
void check_stmtList(Node *stmtList, Type type);
void check_def(Node *def, FieldList fields);
FieldList check_paramDec(Node *paramDec);
void check_varList(Node *varList, FieldList *params, int *paramNum);




#endif // _SEMANTIC_H