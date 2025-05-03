.data
_prompt: .asciiz "Enter an integer:"
_ret: .asciiz "\n"

.text
.globl main

read:
li $v0, 4
la $a0, _prompt
syscall
li $v0, 5
syscall
jr $ra

write:
li $v0, 1
syscall
li $v0, 4
la $a0, _ret
syscall
move $v0, $0
jr $ra

move Reg(v2 ), Reg(temp)
label1:
j label1
j label5
label2:
move Reg(t1 ), Reg(temp)
move Reg(temp1), Reg(temp)
div Reg(temp1), Reg(temp)
mflo Reg(temp)
move Reg(t2 ), Reg(temp)
move Reg(temp1), Reg(temp)
mul Reg(temp), Reg(temp1), Reg(temp)
move Reg(v2 ), Reg(temp)
move Reg(temp1), Reg(temp)
sub Reg(temp), Reg(temp1), Reg(temp)
j label2
j label4
label3:
move Reg(v1 ), Reg(temp)
move Reg(temp1), Reg(temp)
div Reg(temp1), Reg(temp)
mflo Reg(temp)
j label1
label4:
move Reg(t3 ), Reg(temp)
move Reg(temp1), Reg(temp)
mul Reg(temp), Reg(temp1), Reg(temp)
move Reg(v1 ), Reg(temp)
move Reg(temp1), Reg(temp)
add Reg(temp), Reg(temp1), Reg(temp)
j label1
label5:
li Reg(v0), 0
jr Reg(ra)
