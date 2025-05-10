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

fact:
subu $sp, $sp, 80
sw $fp, 76($sp)
sw $ra, 72($sp)
addiu $fp, $sp, 80
sw $t0, -12($fp)
sw $t1, -16($fp)
sw $t2, -20($fp)
sw $t3, -24($fp)
sw $t4, -28($fp)
sw $t5, -32($fp)
sw $t6, -36($fp)
sw $t7, -40($fp)
sw $s0, -44($fp)
sw $s1, -48($fp)
sw $s2, -52($fp)
sw $s3, -56($fp)
sw $s4, -60($fp)
sw $s5, -64($fp)
sw $s6, -68($fp)
sw $s7, -72($fp)
sw $t8, -76($fp)
sw $t9, -80($fp)
lw $t0, 0($fp)
li $t1, 1
beq $t0, $t1, label0
j label1
label0 :
move $v0, $t0
lw $t9, -80($fp)
lw $t8, -76($fp)
lw $s7, -72($fp)
lw $s6, -68($fp)
lw $s5, -64($fp)
lw $s4, -60($fp)
lw $s3, -56($fp)
lw $s2, -52($fp)
lw $s1, -48($fp)
lw $s0, -44($fp)
lw $t7, -40($fp)
lw $t6, -36($fp)
lw $t5, -32($fp)
lw $t4, -28($fp)
lw $t3, -24($fp)
lw $t2, -20($fp)
lw $t1, -16($fp)
lw $t0, -12($fp)
lw $ra, -8($fp)
lw $fp, -4($fp)
addi $sp, $sp, 80
jr $ra
label1 :
li $t2, 1
sub $t3, $t0, $t2
subu $sp, $sp, 4
sw $t3, 0($sp)
jal fact
move $t2, $v0
mul $t4, $t0, $t2
move $v0, $t4
lw $t9, -80($fp)
lw $t8, -76($fp)
lw $s7, -72($fp)
lw $s6, -68($fp)
lw $s5, -64($fp)
lw $s4, -60($fp)
lw $s3, -56($fp)
lw $s2, -52($fp)
lw $s1, -48($fp)
lw $s0, -44($fp)
lw $t7, -40($fp)
lw $t6, -36($fp)
lw $t5, -32($fp)
lw $t4, -28($fp)
lw $t3, -24($fp)
lw $t2, -20($fp)
lw $t1, -16($fp)
lw $t0, -12($fp)
lw $ra, -8($fp)
lw $fp, -4($fp)
addi $sp, $sp, 80
jr $ra
main:
subu $sp, $sp, 80
sw $fp, 76($sp)
sw $ra, 72($sp)
addiu $fp, $sp, 80
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
move $t5, $v0
move $t6, $t5
li $t7, 1
bgt $t6, $t7, label3
j label4
label3 :
subu $sp, $sp, 4
sw $t6, 0($sp)
jal fact
move $s0, $v0
move $s1, $s0
j label5
label4 :
li $s1, 1
label5 :
move $a0, $s1
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $s2, 0
move $v0, $s2
lw $ra, -8($fp)
lw $fp, -4($fp)
addi $sp, $sp, 80
jr $ra
