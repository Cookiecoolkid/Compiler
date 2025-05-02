| 中间代码             | MIPS32 指令              |
| ---------------- | -------------------------- |
| LABEL x:         | x:                         |
| x := #k          | li reg(x), k               |
| x := y           | move reg(x), reg(y)        |
| x := y + #k      | addi reg(x), reg(y), k     |
| x := y + z       | add reg(x), reg(y), reg(z) |
| x := y - #k      | addi reg(x), reg(y), -k    |
| x := y - z       | sub reg(x), reg(y), reg(z) |
| x := y \* z      | mul reg(x), reg(y), reg(z) |
| x := y / z       | div reg(y), reg(z)         |
|                  | mflo reg(x)                |
| x := \*y         | lw reg(x), 0(reg(y))       |
| \*x = y          | sw reg(y), 0(reg(x))       |
| GOTO x           | j x                        |
| x := CALL f      | jal f                      |
|                  | move reg(x), $v0           |
| RETURN x         | move $v0, reg(x)           |
|                  | jr $ra                     |
| IF x == y GOTO z | beq reg(x), reg(y), z      |
| IF x != y GOTO z | bne reg(x), reg(y), z      |
| IF x > y GOTO z  | bgt reg(x), reg(y), z      |
| IF x < y GOTO z  | blt reg(x), reg(y), z      |
| IF x >= y GOTO z | bge reg(x), reg(y), z      |
| IF x <= y GOTO z | ble reg(x), reg(y), z      |
