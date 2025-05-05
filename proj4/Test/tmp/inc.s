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
subu $sp, $sp, 40
sw $ra, 36($sp)
sw $fp, 32($sp)
addi $fp, $sp, 40
sw $s0, 28($sp)
sw $s1, 24($sp)
sw $s2, 20($sp)
sw $s3, 16($sp)
sw $s4, 12($sp)
sw $s5, 8($sp)
sw $s6, 4($sp)
sw $s7, 0($sp)
lw $t0, 0($fp)
lw $t1, 0($fp)
li $t2, 1
add $t3, $t1, $t2
lw $t2, 8($fp)
move $t2, $t3
lw $s7, 0($sp)
lw $s6, 4($sp)
lw $s5, 8($sp)
lw $s4, 12($sp)
lw $s3, 16($sp)
lw $s2, 20($sp)
lw $s1, 24($sp)
lw $s0, 28($sp)
lw $ra, 36($sp)
lw $fp, 32($sp)
move $v0, $t2
addi $sp, $sp, 40
jr $ra

main:
subu $sp, $sp, 52
sw $ra, 48($sp)
sw $fp, 44($sp)
addi $fp, $sp, 52
sw $s0, 40($sp)
sw $s1, 36($sp)
sw $s2, 32($sp)
sw $s3, 28($sp)
sw $s4, 24($sp)
sw $s5, 20($sp)
sw $s6, 16($sp)
sw $s7, 12($sp)
li $t4, 2
li $t5, 2
mul $t6, $t4, $t5
lw $t4, 16($fp)
move $t4, $t6
sw $t4, 0($sp)
sw $t1, 0($sp)
sw $t2, 8($sp)
sw $t3, 4($sp)
sw $t4, 16($sp)
sw $t6, 12($sp)
jal inc
lw $t1, 0($sp)
lw $t2, 8($sp)
lw $t3, 4($sp)
lw $t4, 16($sp)
lw $t6, 12($sp)
lw $t5, 20($fp)
move $t5, $v0
lw $t7, 24($fp)
move $t7, $t5
move $a0, $t7
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $s7, 12($sp)
lw $s6, 16($sp)
lw $s5, 20($sp)
lw $s4, 24($sp)
lw $s3, 28($sp)
lw $s2, 32($sp)
lw $s1, 36($sp)
lw $s0, 40($sp)
lw $ra, 48($sp)
lw $fp, 44($sp)
lw $s0, 28($fp)
move $v0, $s0
addi $sp, $sp, 52
jr $ra

