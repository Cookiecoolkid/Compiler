# Compiler
Simple C(C--) Compiler

[NJU Principles and Techniques of Compilers Course Website](https://cs.nju.edu.cn/tiantan/courses/compiler-2025/index.html)

## Build
```bash
cd proj*
make
./parser [args]
```

## Lexical Analysis ✅
- 基于正则表达式以及上下文无关文法
- 使用Flex实现词法分析器，支持C--语言的所有词法单元

## Syntax Analysis ✅
- 基于递归下降分析
- 使用Bison实现语法分析器，构建抽象语法树(AST)

## Semantic Analysis ✅
- 基于符号表实现语义分析，支持变量作用域和类型检查
- 使用红黑树实现符号表，支持高效的符号查找和管理

## Intermediate Code Generation/Optimization ✅
- 基于AST生成三地址中间代码
- 基本块划分、控制流图构建、公共子表达式消除、常量折叠、活跃变量分析、死代码消除、循环不变代码外提、归纳变量强度削减

## Target Code Generation/Optimization Implementing ✅
- 基于中间代码生成mips32汇编代码
- 实现寄存器分配、指令选择和栈帧管理
