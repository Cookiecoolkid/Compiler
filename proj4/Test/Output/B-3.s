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

getNextValue:
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
subu $sp, $sp, 4
lw $t1, 4($fp)
sw $t1, -88($fp)
subu $sp, $sp, 4
lw $t2, 8($fp)
sw $t2, -92($fp)
li $t3, 2
subu $sp, $sp, 4
div $t0, $t3
mflo $t4
sw $t4, -96($fp)
sw $t0, -84($fp)
lw $t0, -96($fp)
li $t3, 2
subu $sp, $sp, 4
mul $t4, $t0, $t3
sw $t4, -100($fp)
sw $t0, -96($fp)
lw $t0, -100($fp)
lw $t3, -84($fp)
beq $t0, $t3, label0
j label1
label0 :
lw $t3, -84($fp)
li $t4, 5
subu $sp, $sp, 4
add $t5, $t3, $t4
sw $t5, -104($fp)
sw $t3, -84($fp)
subu $sp, $sp, 4
lw $t4, -104($fp)
move $t3, $t4
sw $t3, -108($fp)
j label2
label1 :
lw $t3, -84($fp)
li $t5, 3
subu $sp, $sp, 4
mul $t6, $t3, $t5
sw $t6, -112($fp)
sw $t3, -84($fp)
lw $t3, -108($fp)
lw $t5, -112($fp)
move $t3, $t5
sw $t3, -108($fp)
label2 :
lw $t3, -108($fp)
subu $sp, $sp, 4
add $t6, $t1, $t3
sw $t6, -116($fp)
sw $t1, -88($fp)
sw $t3, -108($fp)
lw $t1, -116($fp)
move $v0, $t1
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

checkComplexCondition:
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
subu $sp, $sp, 4
lw $t1, 4($fp)
sw $t1, -88($fp)
li $t2, 50
bgt $t0, $t2, label5
j label4
label5 :
li $t3, 5
blt $t1, $t3, label3
j label4
label3 :
li $t4, 1
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

label4 :
li $t5, 10
blt $t0, $t5, label8
j label7
label8 :
li $t6, 0
bgt $t1, $t6, label6
j label7
label6 :
li $t7, 1
move $v0, $t7
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

label7 :
li $s0, 0
move $v0, $s0
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
subu $sp, $sp, 4
subu $sp, $sp, 80
subu $sp, $sp, 4
li $t0, 0
sw $t0, -168($fp)
subu $sp, $sp, 4
li $t0, 0
sw $t0, -172($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t0, $t1
sw $t0, -176($fp)
li $t0, 0
li $t2, 4
subu $sp, $sp, 4
mul $t3, $t0, $t2
sw $t3, -180($fp)
lw $t0, -180($fp)
lw $t2, -176($fp)
subu $sp, $sp, 4
add $t3, $t0, $t2
sw $t3, -184($fp)
sw $t0, -180($fp)
sw $t2, -176($fp)
lw $t0, -184($fp)
li $t2, 5
sw $t2, 4($t0)
sw $t0, -184($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t0, $t1
sw $t0, -188($fp)
li $t0, 1
li $t3, 4
subu $sp, $sp, 4
mul $t4, $t0, $t3
sw $t4, -192($fp)
lw $t0, -192($fp)
lw $t3, -188($fp)
subu $sp, $sp, 4
add $t4, $t0, $t3
sw $t4, -196($fp)
sw $t0, -192($fp)
sw $t3, -188($fp)
lw $t0, -196($fp)
li $t3, 8
sw $t3, 4($t0)
sw $t0, -196($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t0, $t1
sw $t0, -200($fp)
li $t0, 2
li $t4, 4
subu $sp, $sp, 4
mul $t5, $t0, $t4
sw $t5, -204($fp)
lw $t0, -204($fp)
lw $t4, -200($fp)
subu $sp, $sp, 4
add $t5, $t0, $t4
sw $t5, -208($fp)
sw $t0, -204($fp)
sw $t4, -200($fp)
lw $t0, -208($fp)
li $t4, 3
sw $t4, 4($t0)
sw $t0, -208($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t0, $t1
sw $t0, -212($fp)
li $t0, 3
li $t5, 4
subu $sp, $sp, 4
mul $t6, $t0, $t5
sw $t6, -216($fp)
lw $t0, -216($fp)
lw $t5, -212($fp)
subu $sp, $sp, 4
add $t6, $t0, $t5
sw $t6, -220($fp)
sw $t0, -216($fp)
sw $t5, -212($fp)
lw $t0, -220($fp)
li $t5, 12
sw $t5, 4($t0)
sw $t0, -220($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t0, $t1
sw $t0, -224($fp)
li $t0, 4
li $t6, 4
subu $sp, $sp, 4
mul $t7, $t0, $t6
sw $t7, -228($fp)
lw $t0, -228($fp)
lw $t6, -224($fp)
subu $sp, $sp, 4
add $t7, $t0, $t6
sw $t7, -232($fp)
sw $t0, -228($fp)
sw $t6, -224($fp)
lw $t0, -232($fp)
li $t6, 7
sw $t6, 4($t0)
sw $t0, -232($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
move $t0, $v0
subu $sp, $sp, 4
move $t7, $t0
sw $t7, -240($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
move $t7, $v0
subu $sp, $sp, 4
move $s0, $t7
sw $s0, -248($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
move $s0, $v0
subu $sp, $sp, 4
move $s1, $s0
sw $s1, -256($fp)
lw $s1, -256($fp)
li $s2, 5
bgt $s1, $s2, label9
j label10
label9 :
lw $s1, -256($fp)
li $s1, 5
sw $s1, -256($fp)
label10 :
lw $s1, -256($fp)
li $s3, 0
blt $s1, $s3, label11
j label12
label11 :
lw $s1, -256($fp)
li $s1, 0
sw $s1, -256($fp)
label12 :
label13 :
lw $s1, -168($fp)
lw $s4, -256($fp)
blt $s1, $s4, label14
j label15
label14 :
subu $sp, $sp, 4
addi $t1, $fp, -84
move $s5, $t1
sw $s5, -260($fp)
lw $s1, -168($fp)
li $s5, 4
subu $sp, $sp, 4
mul $s6, $s1, $s5
sw $s6, -264($fp)
sw $s1, -168($fp)
lw $s1, -264($fp)
lw $s5, -260($fp)
subu $sp, $sp, 4
add $s6, $s1, $s5
sw $s6, -268($fp)
sw $s1, -264($fp)
sw $s5, -260($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $s1, $t1
sw $s1, -272($fp)
lw $s1, -168($fp)
li $s5, 4
subu $sp, $sp, 4
mul $s6, $s1, $s5
sw $s6, -276($fp)
sw $s1, -168($fp)
lw $s1, -276($fp)
lw $s5, -272($fp)
subu $sp, $sp, 4
add $s6, $s1, $s5
sw $s6, -280($fp)
sw $s1, -276($fp)
sw $s5, -272($fp)
lw $s1, -280($fp)
subu $sp, $sp, 4
lw $s5, 4($s1)
sw $s5, -284($fp)
lw $s5, -240($fp)
subu $sp, $sp, 4
sw $s5, 0($sp)
lw $s6, -284($fp)
subu $sp, $sp, 4
sw $s6, 0($sp)
lw $s7, -168($fp)
subu $sp, $sp, 4
sw $s7, 0($sp)
jal getNextValue
addi $sp, $sp, 12
subu $sp, $sp, 4
move $t8, $v0
lw $t9, -268($fp)
sw $t8, 4($t9)
sw $t9, -268($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t9, $t1
sw $t9, -292($fp)
lw $s7, -168($fp)
li $t9, 4
subu $sp, $sp, 4
mul $t2, $s7, $t9
sw $t2, -296($fp)
sw $s7, -168($fp)
lw $t2, -296($fp)
lw $s7, -292($fp)
subu $sp, $sp, 4
add $t9, $t2, $s7
sw $t9, -300($fp)
sw $t2, -296($fp)
sw $s7, -292($fp)
lw $t2, -300($fp)
subu $sp, $sp, 4
lw $s7, 4($t2)
sw $s7, -304($fp)
lw $s7, -248($fp)
subu $sp, $sp, 4
sw $s7, 0($sp)
lw $t9, -304($fp)
subu $sp, $sp, 4
sw $t9, 0($sp)
jal checkComplexCondition
addi $sp, $sp, 8
subu $sp, $sp, 4
move $t3, $v0
li $t4, 1
beq $t3, $t4, label16
j label17
label16 :
lw $t5, -172($fp)
li $t6, 1
subu $sp, $sp, 4
sw $t0, -236($fp)
add $t0, $t5, $t6
sw $t0, -312($fp)
sw $t5, -172($fp)
lw $t0, -172($fp)
lw $t5, -312($fp)
move $t0, $t5
sw $t0, -172($fp)
label17 :
lw $t0, -168($fp)
li $t6, 1
subu $sp, $sp, 4
sw $t7, -244($fp)
add $t7, $t0, $t6
sw $t7, -316($fp)
sw $t0, -168($fp)
lw $t0, -168($fp)
lw $t6, -316($fp)
move $t0, $t6
sw $t0, -168($fp)
j label13
label15 :
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t0, $t1
sw $t0, -320($fp)
li $t0, 0
li $t7, 4
subu $sp, $sp, 4
sw $s0, -252($fp)
mul $s0, $t0, $t7
sw $s0, -324($fp)
lw $t0, -324($fp)
lw $t7, -320($fp)
subu $sp, $sp, 4
add $s0, $t0, $t7
sw $s0, -328($fp)
sw $t0, -324($fp)
sw $t7, -320($fp)
lw $t0, -328($fp)
subu $sp, $sp, 4
lw $t7, 4($t0)
sw $t7, -332($fp)
lw $t7, -332($fp)
move $a0, $t7
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $s4, -256($fp)
li $s0, 0
bgt $s4, $s0, label18
j label19
label18 :
subu $sp, $sp, 4
addi $t1, $fp, -84
move $s2, $t1
sw $s2, -336($fp)
lw $s4, -256($fp)
li $s2, 1
subu $sp, $sp, 4
sub $s3, $s4, $s2
sw $s3, -340($fp)
sw $s4, -256($fp)
lw $s2, -340($fp)
li $s3, 4
subu $sp, $sp, 4
mul $s4, $s2, $s3
sw $s4, -344($fp)
sw $s2, -340($fp)
lw $s2, -344($fp)
lw $s3, -336($fp)
subu $sp, $sp, 4
add $s4, $s2, $s3
sw $s4, -348($fp)
sw $s2, -344($fp)
sw $s3, -336($fp)
lw $s2, -348($fp)
subu $sp, $sp, 4
lw $s3, 4($s2)
sw $s3, -352($fp)
lw $s3, -352($fp)
move $a0, $s3
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
j label20
label19 :
subu $sp, $sp, 4
addi $t1, $fp, -84
move $s4, $t1
sw $s4, -356($fp)
li $s4, 0
sw $s1, -280($fp)
li $s1, 4
subu $sp, $sp, 4
sw $s5, -240($fp)
mul $s5, $s4, $s1
sw $s5, -360($fp)
lw $s1, -360($fp)
lw $s4, -356($fp)
subu $sp, $sp, 4
add $s5, $s1, $s4
sw $s5, -364($fp)
sw $s1, -360($fp)
sw $s4, -356($fp)
lw $s1, -364($fp)
subu $sp, $sp, 4
lw $s4, 4($s1)
sw $s4, -368($fp)
lw $s4, -368($fp)
move $a0, $s4
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
label20 :
lw $s5, -172($fp)
move $a0, $s5
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
sw $s6, -284($fp)
lw $s6, -168($fp)
move $a0, $s6
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
sw $t8, -288($fp)
li $t8, 0
move $v0, $t8
lw $ra, -8($fp)
lw $fp, -4($fp)
addi $sp, $sp, 80
jr $ra

