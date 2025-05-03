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

main:
addiu $sp, $sp, -0
lw $t0, 0($sp)
lw $t1, 4($sp)
move $t0, $t1
sw $t0, 0($sp)
lw $t2, 8($sp)
lw $t3, 12($sp)
move $t2, $t3
sw $t2, 8($sp)
add $t4, $t0, $t2
sw $t4, 16($sp)
lw $t5, 20($sp)
move $t5, $t4
sw $t5, 20($sp)
lw $t6, 24($sp)
move $v0, $t6
jr $ra

