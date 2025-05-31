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

calculateInnerLoopLimit:
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
sub $t2, $t0, $t1
sw $t2, -92($fp)
sw $t0, -84($fp)
sw $t1, -88($fp)
lw $t0, -92($fp)
li $t1, 1
subu $sp, $sp, 4
sub $t2, $t0, $t1
sw $t2, -96($fp)
sw $t0, -92($fp)
subu $sp, $sp, 4
lw $t1, -96($fp)
move $t0, $t1
sw $t0, -100($fp)
lw $t0, -100($fp)
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

main:
subu $sp, $sp, 80
sw $fp, 76($sp)
sw $ra, 72($sp)
addiu $fp, $sp, 80
subu $sp, $sp, 4
subu $sp, $sp, 80
subu $sp, $sp, 4
li $t0, 5
sw $t0, -168($fp)
subu $sp, $sp, 4
li $t0, 0
sw $t0, -172($fp)
subu $sp, $sp, 4
li $t0, 0
sw $t0, -176($fp)
label0 :
lw $t0, -172($fp)
lw $t1, -168($fp)
blt $t0, $t1, label1
j label2
label1 :
subu $sp, $sp, 4
addi $t3, $fp, -84
move $t2, $t3
sw $t2, -180($fp)
lw $t0, -172($fp)
li $t2, 4
subu $sp, $sp, 4
mul $t4, $t0, $t2
sw $t4, -184($fp)
sw $t0, -172($fp)
lw $t0, -184($fp)
lw $t2, -180($fp)
subu $sp, $sp, 4
add $t4, $t0, $t2
sw $t4, -188($fp)
sw $t0, -184($fp)
sw $t2, -180($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
move $t0, $v0
lw $t2, -188($fp)
sw $t0, 4($t2)
sw $t2, -188($fp)
lw $t2, -172($fp)
li $t4, 1
subu $sp, $sp, 4
add $t5, $t2, $t4
sw $t5, -196($fp)
sw $t2, -172($fp)
lw $t2, -172($fp)
lw $t4, -196($fp)
move $t2, $t4
sw $t2, -172($fp)
j label0
label2 :
lw $t2, -172($fp)
li $t2, 0
sw $t2, -172($fp)
label3 :
lw $t2, -172($fp)
lw $t1, -168($fp)
blt $t2, $t1, label4
j label5
label4 :
subu $sp, $sp, 4
addi $t3, $fp, -84
move $t5, $t3
sw $t5, -200($fp)
lw $t2, -172($fp)
li $t5, 4
subu $sp, $sp, 4
mul $t6, $t2, $t5
sw $t6, -204($fp)
sw $t2, -172($fp)
lw $t2, -204($fp)
lw $t5, -200($fp)
subu $sp, $sp, 4
add $t6, $t2, $t5
sw $t6, -208($fp)
sw $t2, -204($fp)
sw $t5, -200($fp)
lw $t2, -208($fp)
subu $sp, $sp, 4
lw $t5, 4($t2)
sw $t5, -212($fp)
lw $t5, -212($fp)
move $a0, $t5
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t6, -172($fp)
li $t7, 1
subu $sp, $sp, 4
add $s0, $t6, $t7
sw $s0, -216($fp)
sw $t6, -172($fp)
lw $t6, -172($fp)
lw $t7, -216($fp)
move $t6, $t7
sw $t6, -172($fp)
j label3
label5 :
lw $t6, -172($fp)
li $t6, 0
sw $t6, -172($fp)
lw $t1, -168($fp)
li $t6, 1
subu $sp, $sp, 4
sub $s0, $t1, $t6
sw $s0, -220($fp)
sw $t1, -168($fp)
subu $sp, $sp, 4
lw $t6, -220($fp)
move $t1, $t6
sw $t1, -224($fp)
label6 :
lw $t1, -172($fp)
lw $s0, -224($fp)
blt $t1, $s0, label7
j label8
label7 :
lw $s1, -176($fp)
li $s1, 0
sw $s1, -176($fp)
lw $t1, -172($fp)
subu $sp, $sp, 4
sw $t1, 0($sp)
lw $s1, -168($fp)
subu $sp, $sp, 4
sw $s1, 0($sp)
jal calculateInnerLoopLimit
addi $sp, $sp, 8
subu $sp, $sp, 4
move $s2, $v0
subu $sp, $sp, 4
move $s3, $s2
sw $s3, -232($fp)
label9 :
lw $s3, -176($fp)
lw $s4, -232($fp)
blt $s3, $s4, label10
j label11
label10 :
subu $sp, $sp, 4
addi $t3, $fp, -84
move $s5, $t3
sw $s5, -236($fp)
lw $s3, -176($fp)
li $s5, 4
subu $sp, $sp, 4
mul $s6, $s3, $s5
sw $s6, -240($fp)
sw $s3, -176($fp)
lw $s3, -240($fp)
lw $s5, -236($fp)
subu $sp, $sp, 4
add $s6, $s3, $s5
sw $s6, -244($fp)
sw $s3, -240($fp)
sw $s5, -236($fp)
lw $s3, -244($fp)
subu $sp, $sp, 4
lw $s5, 4($s3)
sw $s5, -248($fp)
subu $sp, $sp, 4
addi $t3, $fp, -84
move $s5, $t3
sw $s5, -252($fp)
lw $s5, -176($fp)
li $s6, 1
subu $sp, $sp, 4
add $s7, $s5, $s6
sw $s7, -256($fp)
sw $s5, -176($fp)
lw $s5, -256($fp)
li $s6, 4
subu $sp, $sp, 4
mul $s7, $s5, $s6
sw $s7, -260($fp)
sw $s5, -256($fp)
lw $s5, -260($fp)
lw $s6, -252($fp)
subu $sp, $sp, 4
add $s7, $s5, $s6
sw $s7, -264($fp)
sw $s5, -260($fp)
sw $s6, -252($fp)
lw $s5, -264($fp)
subu $sp, $sp, 4
lw $s6, 4($s5)
sw $s6, -268($fp)
lw $s6, -248($fp)
lw $s7, -268($fp)
bgt $s6, $s7, label12
j label13
label12 :
subu $sp, $sp, 4
addi $t3, $fp, -84
move $t8, $t3
sw $t8, -272($fp)
lw $t8, -176($fp)
li $t9, 4
subu $sp, $sp, 4
sw $t0, -192($fp)
mul $t0, $t8, $t9
sw $t0, -276($fp)
sw $t8, -176($fp)
lw $t0, -276($fp)
lw $t8, -272($fp)
subu $sp, $sp, 4
add $t9, $t0, $t8
sw $t9, -280($fp)
sw $t0, -276($fp)
sw $t8, -272($fp)
lw $t0, -280($fp)
subu $sp, $sp, 4
lw $t8, 4($t0)
sw $t8, -284($fp)
subu $sp, $sp, 4
lw $t9, -284($fp)
move $t8, $t9
sw $t8, -288($fp)
subu $sp, $sp, 4
addi $t3, $fp, -84
move $t8, $t3
sw $t8, -292($fp)
lw $t8, -176($fp)
sw $t4, -196($fp)
li $t4, 4
subu $sp, $sp, 4
sw $t2, -208($fp)
mul $t2, $t8, $t4
sw $t2, -296($fp)
sw $t8, -176($fp)
lw $t2, -296($fp)
lw $t4, -292($fp)
subu $sp, $sp, 4
add $t8, $t2, $t4
sw $t8, -300($fp)
sw $t2, -296($fp)
sw $t4, -292($fp)
subu $sp, $sp, 4
addi $t3, $fp, -84
move $t2, $t3
sw $t2, -304($fp)
lw $t2, -176($fp)
li $t4, 1
subu $sp, $sp, 4
add $t8, $t2, $t4
sw $t8, -308($fp)
sw $t2, -176($fp)
lw $t2, -308($fp)
li $t4, 4
subu $sp, $sp, 4
mul $t8, $t2, $t4
sw $t8, -312($fp)
sw $t2, -308($fp)
lw $t2, -312($fp)
lw $t4, -304($fp)
subu $sp, $sp, 4
add $t8, $t2, $t4
sw $t8, -316($fp)
sw $t2, -312($fp)
sw $t4, -304($fp)
lw $t2, -316($fp)
subu $sp, $sp, 4
lw $t4, 4($t2)
sw $t4, -320($fp)
lw $t4, -300($fp)
lw $t8, -320($fp)
sw $t8, 4($t4)
sw $t4, -300($fp)
subu $sp, $sp, 4
addi $t3, $fp, -84
move $t4, $t3
sw $t4, -324($fp)
lw $t4, -176($fp)
sw $t5, -212($fp)
li $t5, 1
subu $sp, $sp, 4
sw $t7, -216($fp)
add $t7, $t4, $t5
sw $t7, -328($fp)
sw $t4, -176($fp)
lw $t4, -328($fp)
li $t5, 4
subu $sp, $sp, 4
mul $t7, $t4, $t5
sw $t7, -332($fp)
sw $t4, -328($fp)
lw $t4, -332($fp)
lw $t5, -324($fp)
subu $sp, $sp, 4
add $t7, $t4, $t5
sw $t7, -336($fp)
sw $t4, -332($fp)
sw $t5, -324($fp)
lw $t4, -336($fp)
lw $t5, -288($fp)
sw $t5, 4($t4)
sw $t4, -336($fp)
label13 :
lw $t4, -176($fp)
li $t7, 1
subu $sp, $sp, 4
sw $t6, -220($fp)
add $t6, $t4, $t7
sw $t6, -340($fp)
sw $t4, -176($fp)
lw $t4, -176($fp)
lw $t6, -340($fp)
move $t4, $t6
sw $t4, -176($fp)
j label9
label11 :
subu $sp, $sp, 4
addi $t3, $fp, -84
move $t4, $t3
sw $t4, -344($fp)
li $t4, 0
li $t7, 4
subu $sp, $sp, 4
sw $s0, -224($fp)
mul $s0, $t4, $t7
sw $s0, -348($fp)
lw $t4, -348($fp)
lw $t7, -344($fp)
subu $sp, $sp, 4
add $s0, $t4, $t7
sw $s0, -352($fp)
sw $t4, -348($fp)
sw $t7, -344($fp)
lw $t4, -352($fp)
subu $sp, $sp, 4
lw $t7, 4($t4)
sw $t7, -356($fp)
lw $t7, -356($fp)
move $a0, $t7
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
addi $t3, $fp, -84
move $s0, $t3
sw $s0, -360($fp)
li $s0, 1
sw $t1, -172($fp)
li $t1, 4
subu $sp, $sp, 4
sw $s1, -168($fp)
mul $s1, $s0, $t1
sw $s1, -364($fp)
lw $t1, -364($fp)
lw $s0, -360($fp)
subu $sp, $sp, 4
add $s1, $t1, $s0
sw $s1, -368($fp)
sw $t1, -364($fp)
sw $s0, -360($fp)
lw $t1, -368($fp)
subu $sp, $sp, 4
lw $s0, 4($t1)
sw $s0, -372($fp)
lw $s0, -372($fp)
move $a0, $s0
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
addi $t3, $fp, -84
move $s1, $t3
sw $s1, -376($fp)
li $s1, 2
sw $s2, -228($fp)
li $s2, 4
subu $sp, $sp, 4
sw $s4, -232($fp)
mul $s4, $s1, $s2
sw $s4, -380($fp)
lw $s1, -380($fp)
lw $s2, -376($fp)
subu $sp, $sp, 4
add $s4, $s1, $s2
sw $s4, -384($fp)
sw $s1, -380($fp)
sw $s2, -376($fp)
lw $s1, -384($fp)
subu $sp, $sp, 4
lw $s2, 4($s1)
sw $s2, -388($fp)
lw $s2, -388($fp)
move $a0, $s2
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
addi $t3, $fp, -84
move $s4, $t3
sw $s4, -392($fp)
li $s4, 3
sw $s3, -244($fp)
li $s3, 4
subu $sp, $sp, 4
sw $s5, -264($fp)
mul $s5, $s4, $s3
sw $s5, -396($fp)
lw $s3, -396($fp)
lw $s4, -392($fp)
subu $sp, $sp, 4
add $s5, $s3, $s4
sw $s5, -400($fp)
sw $s3, -396($fp)
sw $s4, -392($fp)
lw $s3, -400($fp)
subu $sp, $sp, 4
lw $s4, 4($s3)
sw $s4, -404($fp)
lw $s4, -404($fp)
move $a0, $s4
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
addi $t3, $fp, -84
move $s5, $t3
sw $s5, -408($fp)
li $s5, 4
sw $s6, -248($fp)
li $s6, 4
subu $sp, $sp, 4
sw $s7, -268($fp)
mul $s7, $s5, $s6
sw $s7, -412($fp)
lw $s5, -412($fp)
lw $s6, -408($fp)
subu $sp, $sp, 4
add $s7, $s5, $s6
sw $s7, -416($fp)
sw $s5, -412($fp)
sw $s6, -408($fp)
lw $s5, -416($fp)
subu $sp, $sp, 4
lw $s6, 4($s5)
sw $s6, -420($fp)
lw $s6, -420($fp)
move $a0, $s6
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $s7, -172($fp)
sw $t0, -280($fp)
li $t0, 1
subu $sp, $sp, 4
sw $t9, -284($fp)
add $t9, $s7, $t0
sw $t9, -424($fp)
sw $s7, -172($fp)
lw $t0, -172($fp)
lw $s7, -424($fp)
move $t0, $s7
sw $t0, -172($fp)
j label6
label8 :
lw $t0, -172($fp)
li $t0, 0
sw $t0, -172($fp)
label14 :
lw $t0, -172($fp)
lw $t9, -168($fp)
blt $t0, $t9, label15
j label16
label15 :
subu $sp, $sp, 4
sw $t2, -316($fp)
addi $t3, $fp, -84
move $t2, $t3
sw $t2, -428($fp)
lw $t0, -172($fp)
li $t2, 4
subu $sp, $sp, 4
sw $t8, -320($fp)
mul $t8, $t0, $t2
sw $t8, -432($fp)
sw $t0, -172($fp)
lw $t0, -432($fp)
lw $t2, -428($fp)
subu $sp, $sp, 4
add $t8, $t0, $t2
sw $t8, -436($fp)
sw $t0, -432($fp)
sw $t2, -428($fp)
lw $t0, -436($fp)
subu $sp, $sp, 4
lw $t2, 4($t0)
sw $t2, -440($fp)
lw $t2, -440($fp)
move $a0, $t2
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t8, -172($fp)
sw $t5, -288($fp)
li $t5, 1
subu $sp, $sp, 4
sw $t6, -340($fp)
add $t6, $t8, $t5
sw $t6, -444($fp)
sw $t8, -172($fp)
lw $t5, -172($fp)
lw $t6, -444($fp)
move $t5, $t6
sw $t5, -172($fp)
j label14
label16 :
li $t5, 0
move $v0, $t5
lw $ra, -8($fp)
lw $fp, -4($fp)
addi $sp, $sp, 80
jr $ra

