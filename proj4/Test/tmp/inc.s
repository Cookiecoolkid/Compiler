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
subu $sp, $sp, 80
sw $fp, 76($sp)
sw $ra, 72($sp)
addiu $fp, $sp, 80
lw $t0, 0($fp)
li $t1, 1
add $t2, $t0, $t1
move $t1, $t2
move $v0, $t1
lw $t2, -20($fp)
lw $t1, -16($fp)
lw $t0, -12($fp)
lw $ra, -8($fp)
lw $fp, -4($fp)
move $sp, $fp
jr $ra
main:
subu $sp, $sp, 8
sw $fp, 4($sp)
sw $ra, 0($sp)
addiu $fp, $sp, 8
li $t3, 2
li $t4, 2
mul $t5, $t3, $t4
move $t3, $t5
subu $sp, $sp, 4
sw $t3, 0($sp)
jal inc
move $t4, $v0
move $t6, $t4
move $a0, $t6
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $t7, 0
move $v0, $t7
lw $ra, -8($fp)
lw $fp, -4($fp)
move $sp, $fp
jr $ra
