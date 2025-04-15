#include "rb_tree.h"
#include "helper.h"
#include <assert.h>

// 比较两个结构体类型是否一致（成员顺序无关）
int compareStructTypes(Type t1, Type t2) {
    if (t1->kind != t2->kind) {
        return 0;
    }

    if (t1->kind != STRUCTURE || t2->kind != STRUCTURE) {
        return 0;
    }

    // 比较结构体的字段列表（成员顺序无关）
    return compareFieldListsUnordered(t1->u.structure.struct_members, t2->u.structure.struct_members);
}

// 比较两个字段列表是否一致（成员顺序无关）
int compareFieldListsUnordered(FieldList fl1, FieldList fl2) {
    // 如果两个字段列表都为空，认为一致
    if (fl1 == NULL && fl2 == NULL) {
        return 1;
    }

    // 如果一个为空，另一个不为空，认为不一致
    if (fl1 == NULL || fl2 == NULL) {
        return 0;
    }

    // 比较字段列表的长度
    int len1 = getFieldListLength(fl1);
    int len2 = getFieldListLength(fl2);
    if (len1 != len2) {
        return 0;
    }

    // 将字段列表转换为数组并排序
    FieldList* arr1 = fieldListToArray(fl1, len1);
    FieldList* arr2 = fieldListToArray(fl2, len2);

    // 对数组排序
    qsort(arr1, len1, sizeof(FieldList), compareFieldsForSort);
    qsort(arr2, len2, sizeof(FieldList), compareFieldsForSort);

    // 逐项比较排序后的数组
    for (int i = 0; i < len1; i++) {
        if (!compareTypesEquals(arr1[i]->type, arr2[i]->type)) {
            free(arr1);
            free(arr2);
            return 0;
        }
    }

    free(arr1);
    free(arr2);
    return 1;
}


// 比较两个字段列表是否一致
int compareFieldListsEquals(FieldList fl1, FieldList fl2) {
    // 如果两个字段列表都为空，认为一致
    if (fl1 == NULL && fl2 == NULL) {
        return 1;
    }

    // 如果一个为空，另一个不为空，认为不一致
    if (fl1 == NULL || fl2 == NULL) {
        return 0;
    }

    // 比较当前字段的类型
    if (!compareTypesEquals(fl1->type, fl2->type)) {
        return 0;
    }

    // 递归比较下一个字段
    return compareFieldListsEquals(fl1->tail, fl2->tail);
}

// 比较两个类型是否一致（递归）
int compareTypesEquals(Type t1, Type t2) {
    if (t1->kind != t2->kind) {
        return 0;
    }

    switch (t1->kind) {
        case BASIC:
            return t1->u.basic == t2->u.basic;
        case ARRAY:
            return t1->u.array.size == t2->u.array.size && compareTypesEquals(t1->u.array.elem, t2->u.array.elem);
        case STRUCTURE:
            return compareFieldListsUnordered(t1->u.structure.struct_members, t2->u.structure.struct_members);
        case FUNCTION:
            return compareFieldLists(t1->u.function.params, t2->u.function.params) && compareTypesEquals(t1->u.function.ret, t2->u.function.ret);
        default:
            return 0;
    }
}

/* =================================================================================== */

// 将字段列表转换为数组
FieldList* fieldListToArray(FieldList fl, int len) {
    FieldList* arr = (FieldList*)malloc(len * sizeof(FieldList)); // 分配一个指针数组
    int index = 0;
    while (fl != NULL) {
        arr[index++] = fl; // 将字段指针存入数组
        fl = fl->tail;
    }
    return arr; // 返回指针数组
}


// 比较两个字段的大小（用于排序）
int compareFieldsForSort(const void* a, const void* b) {
    FieldList f1 = *(FieldList*)a;
    FieldList f2 = *(FieldList*)b;
    return compareTypes(f1->type, f2->type);
}

// 比较两个类型的大小（用于排序）
int compareTypes(Type t1, Type t2) {
    // 定义类型优先级：BASIC < ARRAY < STRUCTURE < FUNCTION
    if (t1->kind != t2->kind) {
        if (t1->kind < t2->kind) {
            return -1;
        } else {
            return 1;
        }
    }

    switch (t1->kind) {
        case BASIC:
            return t1->u.basic - t2->u.basic;
        case ARRAY:
            if (t1->u.array.size != t2->u.array.size) {
                return t1->u.array.size - t2->u.array.size;
            }
            return compareTypes(t1->u.array.elem, t2->u.array.elem);
        case STRUCTURE:
            // 比较结构体的字段列表
            return compareFieldLists(t1->u.structure.struct_members, t2->u.structure.struct_members);
        case FUNCTION:
            // 比较函数的参数列表和返回类型
            if (!compareFieldLists(t1->u.function.params, t2->u.function.params)) {
                return 1;
            }
            return compareTypes(t1->u.function.ret, t2->u.function.ret);
        default:
            return 0;
    }
}
// 相等返回 0，小于返回负数，大于返回正数
int compareFieldLists(FieldList fl1, FieldList fl2) {
    // 如果两个字段列表都为空，认为相等
    if (fl1 == NULL && fl2 == NULL) {
        return 0;
    }

    // 如果一个为空，另一个不为空，认为不相等
    if (fl1 == NULL || fl2 == NULL) {
        return fl1 == NULL ? -1 : 1;
    }

    // 比较字段列表的长度
    int len1 = getFieldListLength(fl1);
    int len2 = getFieldListLength(fl2);
    if (len1 != len2) {
        return len1 - len2;
    }

    // 逐项比较字段
    while (fl1 != NULL && fl2 != NULL) {
        // 比较字段的类型
        int typeCompare = compareTypes(fl1->type, fl2->type);
        if (typeCompare != 0) {
            return typeCompare;
        }
        fl1 = fl1->tail;
        fl2 = fl2->tail;
    }

    return 0;
}

// 获取字段列表的长度
int getFieldListLength(FieldList fl) {
    int count = 0;
    while (fl != NULL) {
        count++;
        fl = fl->tail;
    }
    return count;
}

int calculateTypeSize(Type type) {
    switch (type->kind) {
        case BASIC: 
            return 4; // int, float 大小为4字节
        case ARRAY:
            return type->u.array.size * calculateTypeSize(type->u.array.elem);
        case STRUCTURE: {
            int size = 0;
            FieldList field = type->u.structure.struct_members;
            while (field != NULL) {
                size += calculateTypeSize(field->type);
                field = field->tail;
            }
            return size;
        }
        case FUNCTION:
            assert(0); // 函数类型不计算大小
        default:
            assert(0); // 未知类型
    }
    return 0;
}

int calculateFieldOffset(FieldList field, const char* name) {
    int offset = 0;
    while (field != NULL) {
        if (strcmp(field->name, name) == 0) {
            return offset;
        }
        offset += calculateTypeSize(field->type);
        field = field->tail;
    }
    return -1; // 未找到字段
}