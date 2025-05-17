#ifndef ASSEMBLY_H
#define ASSEMBLY_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

// 将中间代码翻译为MIPS汇编代码
void translate_to_mips(FILE *input, FILE *output);


#endif // ASSEMBLY_H
