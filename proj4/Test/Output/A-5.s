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

processHelper:
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
subu $sp, $sp, 4
lw $t0, 0($fp)
sw $t0, -84($fp)
li $t1, 0
blt $t0, $t1, label0
j label1
label0 :
li $t2, 2
subu $sp, $sp, 4
mul $t3, $t0, $t2
sw $t3, -88($fp)
sw $t0, -84($fp)
lw $t0, -88($fp)
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
lw $t2, -84($fp)
li $t3, 10
subu $sp, $sp, 4
add $t4, $t2, $t3
sw $t4, -92($fp)
sw $t2, -84($fp)
lw $t2, -92($fp)
move $v0, $t2
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

recursiveWithHelperCall:
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
subu $sp, $sp, 4
lw $t0, 0($fp)
sw $t0, -84($fp)
li $t1, 0
ble $t0, $t1, label2
j label3
label2 :
li $t2, 0
move $v0, $t2
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

j label4
label3 :
subu $sp, $sp, 4
sw $t0, 0($sp)
jal processHelper
addi $sp, $sp, 4
subu $sp, $sp, 4
move $t3, $v0
subu $sp, $sp, 4
move $t4, $t3
sw $t4, -92($fp)
li $t4, 2
subu $sp, $sp, 4
sub $t5, $t0, $t4
sw $t5, -96($fp)
sw $t0, -84($fp)
lw $t0, -96($fp)
subu $sp, $sp, 4
sw $t0, 0($sp)
jal recursiveWithHelperCall
addi $sp, $sp, 4
subu $sp, $sp, 4
move $t4, $v0
subu $sp, $sp, 4
move $t5, $t4
sw $t5, -104($fp)
lw $t5, -92($fp)
lw $t6, -104($fp)
subu $sp, $sp, 4
add $t7, $t5, $t6
sw $t7, -108($fp)
sw $t5, -92($fp)
sw $t6, -104($fp)
lw $t5, -108($fp)
move $v0, $t5
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

label4 :
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
subu $sp, $sp, 4
move $t0, $v0
subu $sp, $sp, 4
move $t1, $t0
sw $t1, -88($fp)
lw $t1, -88($fp)
subu $sp, $sp, 4
sw $t1, 0($sp)
jal recursiveWithHelperCall
addi $sp, $sp, 4
subu $sp, $sp, 4
move $t2, $v0
subu $sp, $sp, 4
move $t3, $t2
sw $t3, -96($fp)
lw $t3, -96($fp)
move $a0, $t3
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $t4, 0
move $v0, $t4
lw $ra, -8($fp)
lw $fp, -4($fp)
addi $sp, $sp, 80
jr $ra

