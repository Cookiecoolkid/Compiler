.data
newline: .asciiz "\n"

.text
.globl main

inc:
move Reg(a_), Reg(a0)
move Reg(temp0 ), Reg(temp)
move Reg(temp1), Reg(temp)
add Reg(temp), Reg(temp1), Reg(temp)
move Reg(b_ ), Reg(temp)
move Reg(v0), Reg(b_)
jr Reg(ra)
main:
move Reg(temp1 ), Reg(temp)
move Reg(temp1), Reg(temp)
mul Reg(temp), Reg(temp1), Reg(temp)
move Reg(lcVar_ ), Reg(temp)
move Reg(a0), Reg(lcVar_)
jal inc
move Reg(temp), Reg(v0)
move Reg(rcVar_ ), Reg(temp)
li Reg(v0), 0
jr Reg(ra)
