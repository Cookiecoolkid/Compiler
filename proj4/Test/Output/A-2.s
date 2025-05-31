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
li $t0, 10
sw $t0, -84($fp)
subu $sp, $sp, 4
li $t0, 0
sw $t0, -88($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
move $t0, $v0
subu $sp, $sp, 4
move $t1, $t0
sw $t1, -96($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
move $t1, $v0
subu $sp, $sp, 4
move $t2, $t1
sw $t2, -104($fp)
lw $t2, -96($fp)
lw $t3, -84($fp)
bgt $t2, $t3, label3
j label1
label3 :
lw $t4, -104($fp)
li $t5, 0
bgt $t4, $t5, label0
j label1
label0 :
li $t6, 100
move $a0, $t6
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t7, -88($fp)
li $t7, 1
sw $t7, -88($fp)
j label2
label1 :
lw $t2, -96($fp)
lw $t3, -84($fp)
ble $t2, $t3, label7
j label5
label7 :
lw $t4, -104($fp)
li $t7, 0
blt $t4, $t7, label4
j label5
label4 :
li $s0, 200
move $a0, $s0
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $s1, -88($fp)
li $s1, 2
sw $s1, -88($fp)
j label6
label5 :
li $s1, 250
move $a0, $s1
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $s2, -88($fp)
li $s2, 3
sw $s2, -88($fp)
label6 :
label2 :
lw $t2, -96($fp)
li $s2, 0
beq $t2, $s2, label8
j label11
label11 :
lw $t4, -104($fp)
lw $t3, -84($fp)
beq $t4, $t3, label8
j label9
label8 :
li $s3, 300
move $a0, $s3
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $s4, -88($fp)
li $s5, 1
beq $s4, $s5, label12
j label14
label14 :
lw $s4, -88($fp)
li $s6, 3
beq $s4, $s6, label12
j label13
label12 :
li $s7, 310
move $a0, $s7
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
label13 :
j label10
label9 :
li $t8, 400
move $a0, $t8
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $s4, -88($fp)
li $t9, 2
beq $s4, $t9, label15
j label16
label15 :
sw $t0, -92($fp)
li $t0, 410
move $a0, $t0
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
label16 :
label10 :
lw $t2, -96($fp)
lw $t4, -104($fp)
subu $sp, $sp, 4
sw $t1, -100($fp)
add $t1, $t2, $t4
sw $t1, -108($fp)
sw $t2, -96($fp)
sw $t4, -104($fp)
lw $t1, -108($fp)
li $t2, 0
bgt $t1, $t2, label20
j label18
label20 :
lw $t4, -96($fp)
lw $t3, -84($fp)
bgt $t4, $t3, label17
j label21
label21 :
lw $t5, -104($fp)
li $t6, 0
blt $t5, $t6, label17
j label18
label17 :
li $t7, 500
move $a0, $t7
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
j label19
label18 :
li $s0, 600
move $a0, $s0
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
label19 :
li $s1, 0
move $v0, $s1
lw $ra, -8($fp)
lw $fp, -4($fp)
addi $sp, $sp, 80
jr $ra

