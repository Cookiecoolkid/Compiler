#include "rb_tree.h"
#include "node.h"

enum ErrorType {
    UNDEFINED_VARIABLE,          // 错误类型 1：变量在使用时未经定义
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
    DUPLICATE_STRUCTURE_FIELD,   // 错误类型 15：结构体中域名重复定义
    NAME_CONFLICT_STRUCTURE_VARIABLE, // 错误类型 16：结构体的名字与前面定义过的结构体或变量的名字重复
    UNDEFINED_STRUCTURE_USAGE,   // 错误类型 17：直接使用未定义过的结构体来定义变量
    UNDEFINED_FUNCTION_DECLARATION, // 错误类型 18：函数进行了声明，但没有被定义
    CONFLICTING_FUNCTION_DECLARATION // 错误类型 19：函数的多次声明互相冲突
};

void check_semantic(Node *root) {
  // Root is "Program"
  // Program -> ExtDefList
  assert(root != NULL && root->child != NULL);
  Node *extDefList = root->child;

  check_extDefList(extDefList);
}

void check_extDefList(Node *extDefList) {
  // ExtDefList -> ExtDef ExtDefList
  //             | empty
  assert(extDefList != NULL);
  if (extDefList->child == NULL) return;
  Node *extDef = extDefList->child;
  Node *nextExtDefList = extDef->next;
  check_extDef(extDef);
  check_extDefList(nextExtDefList);
}

void check_extDef(Node *extDef) {
  // ExtDef -> Specifier ExtDecList SEMI
  //         | Specifier SEMI
  //         | Specifier FunDec CompSt
  //         | Specifier FunDec SEMI
  assert(extDef != NULL);

  int childNum = get_child_num(extDef);
  assert(childNum == 2 || childNum == 3);
  Node *specifier = extDef->child;
  Node *secondChild = specifier->next;
  Type type = check_specifier(specifier);


  // TODO TODO
  if (secondChild->next == NULL) {
    // Specifier SEMI
    return;
  }
  assert(childNum == 3);
  Node *thirdChild = secondChild->next;
  if (strcmp(secondChild->name, "ExDecList") == 0) {
    check_extDecList(secondChild, type);
  } else if (strcmp(thirdChild->name, "CompSt") == 0) {
    // Defining a function
    check_funDec(secondChild, type, 1);
    check_compSt(thirdChild, type);
  } else {
    // Function declaration
    check_funDec(secondChild, type, 0);
  }
}

void check_extDecList(Node *extDecList, Type type) {
  // ExtDecList -> VarDec
  //             | VarDec COMMA ExtDecList
  assert(extDecList != NULL);
  Node *varDec = extDecList->child;
  check_varDec(varDec, type);
  if (varDec->next != NULL) {
    check_extDecList(varDec->next->next, type);
  }
}

Type check_specifier(Node *specifier) {
  // Specifier -> TYPE
  //            | StructSpecifier
  assert(specifier != NULL);
  Node *child = specifier->child;
  if (strcmp(child->name, "TYPE") == 0) {
    // Basic type
    Type type = (Type)malloc(sizeof(struct Type_));
    type->kind = BASIC;
    if (strcmp(child->value.value.str_val, "int") == 0) {
      type->u.basic = INT;
    } else {
      type->u.basic = FLOAT;
    }
    return type;
  } else {
    // StructSpecifier
    // 在这里 check_structSpecifier 需要检查是结构体的定义(Type = Struct)还是结构体变量的声明(Type = Basic)
    // 对于每一个结构体定义，都需要在符号表中插入一个新的结构体符号
    // 对于每一个结构体变量声明，需要检查结构体是否已经定义过，如果没有定义过则报错，其 basic 数值为对应结构体类型的 ID
    return check_structSpecifier(child);
  }
}

Type check_structSpecifier(Node *structSpecifier) {
  // StructSpecifier -> STRUCT OptTag LC DefList RC
  //                  | STRUCT Tag
  assert(structSpecifier != NULL);
  int childNum = get_child_num(structSpecifier);
  assert(childNum == 2 || childNum == 5);
  Node *child = structSpecifier->child;
  if (childNum == 2) {
    // STRUCT Tag
    // 在符号表中查找是否有对应的结构体定义，如果没有则报错
    // 返回对应结构体的 Type
    return check_tag(child->next);
  } else {
    // STRUCT OptTag LC DefList RC
    // 在符号表中插入一个新的结构体符号
    // 返回对应结构体的 Type
    // TIP 结构体等价不看 OptTag（Name），只看其中成员类型是否一致（不论顺序）
    char *name = check_optTag(child->next);
    return check_defList(child->next->next->next, name);
  }
}

char *check_optTag(Node *optTag) {
  // OptTag -> ID
  //         | empty
  assert(optTag != NULL);
  if (optTag->child == NULL) return NULL;
  return optTag->child->value.value.str_val;
}

void report_error(enum ErrorType type, int line, const char *msg) {
    printf("Error type %d at Line %d: %s\n", type, line, msg);
}