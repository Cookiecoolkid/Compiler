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

inc:
lw $t0, temp0_addr
lw $t1, a__addr
addi $t0, $t1, 1
lw $t2, b__addr
move $t2, $t0
move $v0, $t2
jr $ra

main:
lw $t3, #2_addr
mul $t4, $t3, $t3
lw $t5, lcVar__addr
move $t5, $t4
jal inc
lw $t6, temp2_addr
move $t6, $v0
lw $t7, rcVar__addr
move $t7, $t6
lw $s0, #0_addr
move $v0, $s0
jr $ra

