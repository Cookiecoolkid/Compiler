#ifndef __HELPER_H
#define __HELPER_H

#include "rb_tree.h"
#include "command.h"

/* ================ Struct Compare ================ */
int compareStructTypes(Type t1, Type t2);
int compareFieldListsUnordered(FieldList fl1, FieldList fl2);
int compareFieldLists(FieldList fl1, FieldList fl2);
int compareFieldListsEquals(FieldList fl1, FieldList fl2);
int compareTypes(Type t1, Type t2);
int compareTypesEquals(Type t1, Type t2);
int getFieldListLength(FieldList fl);
int compareFieldsForSort(const void* a, const void* b);
FieldList* fieldListToArray(FieldList fl, int len);

void appendFieldList(FieldList* fl, FieldList newField);
FieldList searchFieldList(FieldList fl, const char* name);

/* ================ Size and Offset ================ */
int calculateTypeSize(Type type);
int calculateFieldOffset(FieldList field, const char* name);
int calculateStructSizeByName(const char* name);

/* ================ Relation Op ================= */
relop str2relop(const char* str);

#endif // __HELPER_H
