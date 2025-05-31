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
subu $sp, $sp, 80
sw $fp, 76($sp)
sw $ra, 72($sp)
addiu $fp, $sp, 80
subu $sp, $sp, 4
li $t0, 0
sw $t0, -84($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
move $t0, $v0
subu $sp, $sp, 4
move $t1, $t0
sw $t1, -92($fp)
subu $sp, $sp, 4
li $t1, 1
sw $t1, -96($fp)
label0 :
lw $t1, -96($fp)
lw $t2, -92($fp)
ble $t1, $t2, label1
j label2
label1 :
subu $sp, $sp, 4
li $t3, 1
sw $t3, -100($fp)
label3 :
lw $t3, -100($fp)
lw $t2, -92($fp)
ble $t3, $t2, label4
j label5
label4 :
lw $t1, -96($fp)
li $t4, 10
subu $sp, $sp, 4
mul $t5, $t1, $t4
sw $t5, -104($fp)
sw $t1, -96($fp)
lw $t1, -104($fp)
lw $t3, -100($fp)
subu $sp, $sp, 4
add $t4, $t1, $t3
sw $t4, -108($fp)
sw $t1, -104($fp)
sw $t3, -100($fp)
subu $sp, $sp, 4
lw $t3, -108($fp)
move $t1, $t3
sw $t1, -112($fp)
lw $t1, -96($fp)
lw $t4, -100($fp)
subu $sp, $sp, 4
add $t5, $t1, $t4
sw $t5, -116($fp)
sw $t1, -96($fp)
sw $t4, -100($fp)
subu $sp, $sp, 4
lw $t4, -116($fp)
move $t1, $t4
sw $t1, -120($fp)
lw $t1, -120($fp)
li $t5, 2
subu $sp, $sp, 4
div $t1, $t5
mflo $t6
sw $t6, -124($fp)
sw $t1, -120($fp)
lw $t1, -124($fp)
li $t5, 2
subu $sp, $sp, 4
mul $t6, $t1, $t5
sw $t6, -128($fp)
sw $t1, -124($fp)
lw $t1, -128($fp)
lw $t5, -120($fp)
beq $t1, $t5, label6
j label7
label6 :
lw $t6, -84($fp)
lw $t7, -112($fp)
subu $sp, $sp, 4
add $s0, $t6, $t7
sw $s0, -132($fp)
sw $t6, -84($fp)
sw $t7, -112($fp)
lw $t6, -84($fp)
lw $t7, -132($fp)
move $t6, $t7
sw $t6, -84($fp)
label7 :
lw $t6, -100($fp)
li $s0, 1
subu $sp, $sp, 4
add $s1, $t6, $s0
sw $s1, -136($fp)
sw $t6, -100($fp)
lw $t6, -100($fp)
lw $s0, -136($fp)
move $t6, $s0
sw $t6, -100($fp)
j label3
label5 :
lw $t6, -96($fp)
li $s1, 1
subu $sp, $sp, 4
add $s2, $t6, $s1
sw $s2, -140($fp)
sw $t6, -96($fp)
lw $t6, -96($fp)
lw $s1, -140($fp)
move $t6, $s1
sw $t6, -96($fp)
j label0
label2 :
lw $t6, -84($fp)
move $a0, $t6
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

