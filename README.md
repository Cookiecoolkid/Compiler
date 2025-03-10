# Compiler


## Build Lab1
```bash
flex lexical.l
bison -d syntax.y
gcc main.c syntax.tab.c -lfl -o scanner
```