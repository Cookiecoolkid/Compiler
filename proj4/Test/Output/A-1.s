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
li $t0, 100
sw $t0, -84($fp)
subu $sp, $sp, 4
li $t0, 7
sw $t0, -88($fp)
subu $sp, $sp, 4
li $t0, 12
sw $t0, -92($fp)
lw $t0, -88($fp)
li $t1, 5
subu $sp, $sp, 4
add $t2, $t0, $t1
sw $t2, -96($fp)
sw $t0, -88($fp)
lw $t0, -84($fp)
li $t1, 50
subu $sp, $sp, 4
div $t0, $t1
mflo $t2
sw $t2, -100($fp)
sw $t0, -84($fp)
lw $t0, -92($fp)
lw $t1, -100($fp)
subu $sp, $sp, 4
sub $t2, $t0, $t1
sw $t2, -104($fp)
sw $t0, -92($fp)
sw $t1, -100($fp)
lw $t0, -96($fp)
lw $t1, -104($fp)
subu $sp, $sp, 4
mul $t2, $t0, $t1
sw $t2, -108($fp)
sw $t0, -96($fp)
sw $t1, -104($fp)
subu $sp, $sp, 4
lw $t1, -108($fp)
move $t0, $t1
sw $t0, -112($fp)
lw $t0, -112($fp)
lw $t2, -88($fp)
subu $sp, $sp, 4
add $t3, $t0, $t2
sw $t3, -116($fp)
sw $t0, -112($fp)
sw $t2, -88($fp)
subu $sp, $sp, 4
lw $t2, -116($fp)
move $t0, $t2
sw $t0, -120($fp)
lw $t0, -120($fp)
move $a0, $t0
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t3, -112($fp)
move $a0, $t3
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t0, -120($fp)
lw $t4, -92($fp)
subu $sp, $sp, 4
sub $t5, $t0, $t4
sw $t5, -124($fp)
sw $t0, -120($fp)
sw $t4, -92($fp)
lw $t0, -124($fp)
li $t4, 3
subu $sp, $sp, 4
mul $t5, $t0, $t4
sw $t5, -128($fp)
sw $t0, -124($fp)
subu $sp, $sp, 4
lw $t4, -128($fp)
move $t0, $t4
sw $t0, -132($fp)
lw $t0, -132($fp)
li $t5, 2
subu $sp, $sp, 4
div $t0, $t5
mflo $t6
sw $t6, -136($fp)
sw $t0, -132($fp)
lw $t0, -120($fp)
lw $t5, -136($fp)
move $t0, $t5
sw $t0, -120($fp)
lw $t0, -120($fp)
move $a0, $t0
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t6, -92($fp)
li $t7, 10
subu $sp, $sp, 4
mul $s0, $t6, $t7
sw $s0, -140($fp)
sw $t6, -92($fp)
subu $sp, $sp, 4
lw $t7, -140($fp)
move $t6, $t7
sw $t6, -144($fp)
lw $t6, -144($fp)
move $a0, $t6
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $s0, -132($fp)
move $a0, $s0
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $s1, 0
move $v0, $s1
lw $ra, -8($fp)
lw $fp, -4($fp)
addi $sp, $sp, 80
jr $ra

