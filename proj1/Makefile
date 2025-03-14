# Makefile for Compiler Project 1

# Compiler and flags
CC = gcc
CFLAGS = -g
LEX = flex
YACC = bison -d

# Source files
LEX_SRC = lexical.l
YACC_SRC = syntax.y
MAIN_SRC = main.c

# Generated files
LEX_OUT = lex.yy.c
YACC_OUT = syntax.tab.c syntax.tab.h
YACC_OUT_SRC = syntax.tab.c

# Target executable
TARGET = scanner

# Default target
all: $(TARGET)

# Rule to generate lex.yy.c from lexical.l
$(LEX_OUT): $(LEX_SRC)
	$(LEX) -o $(LEX_OUT) $(LEX_SRC)

# Rule to generate syntax.tab.c and syntax.tab.h from syntax.y
$(YACC_OUT): $(YACC_SRC)
	$(YACC) -o syntax.tab.c syntax.y

# Rule to compile and link the target executable
$(TARGET): $(MAIN_SRC) $(LEX_OUT) $(YACC_OUT)
	$(CC) $(CFLAGS) -o $(TARGET) $(MAIN_SRC) $(YACC_OUT_SRC) -lfl

# Clean rule to remove generated files
clean:
	rm -f $(LEX_OUT) $(YACC_OUT) $(TARGET)