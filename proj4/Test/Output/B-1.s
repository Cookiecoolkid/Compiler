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

calculateBase:
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
li $t1, 50
bgt $t0, $t1, label0
j label1
label0 :
li $t2, 2
subu $sp, $sp, 4
div $t0, $t2
mflo $t3
sw $t3, -88($fp)
sw $t0, -84($fp)
subu $sp, $sp, 4
lw $t2, -88($fp)
move $t0, $t2
sw $t0, -92($fp)
lw $t0, -92($fp)
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

j label2
label1 :
lw $t3, -84($fp)
li $t4, 10
subu $sp, $sp, 4
add $t5, $t3, $t4
sw $t5, -96($fp)
sw $t3, -84($fp)
lw $t0, -92($fp)
lw $t3, -96($fp)
move $t0, $t3
sw $t0, -92($fp)
lw $t0, -92($fp)
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

label2 :
determineIndex:
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
add $t2, $t0, $t1
sw $t2, -92($fp)
sw $t0, -84($fp)
sw $t1, -88($fp)
lw $t0, -92($fp)
li $t1, 5
subu $sp, $sp, 4
div $t0, $t1
mflo $t2
sw $t2, -96($fp)
sw $t0, -92($fp)
subu $sp, $sp, 4
lw $t1, -96($fp)
move $t0, $t1
sw $t0, -100($fp)
lw $t0, -100($fp)
li $t2, 0
blt $t0, $t2, label3
j label4
label3 :
li $t3, 0
move $v0, $t3
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
lw $t0, -100($fp)
li $t4, 4
bgt $t0, $t4, label5
j label6
label5 :
li $t5, 4
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

label6 :
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
addi $t1, $fp, -84
move $t0, $t1
sw $t0, -168($fp)
li $t0, 0
li $t2, 4
subu $sp, $sp, 4
mul $t3, $t0, $t2
sw $t3, -172($fp)
lw $t0, -172($fp)
lw $t2, -168($fp)
subu $sp, $sp, 4
add $t3, $t0, $t2
sw $t3, -176($fp)
sw $t0, -172($fp)
sw $t2, -168($fp)
lw $t0, -176($fp)
li $t2, 1
sw $t2, 4($t0)
sw $t0, -176($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t0, $t1
sw $t0, -180($fp)
li $t0, 1
li $t3, 4
subu $sp, $sp, 4
mul $t4, $t0, $t3
sw $t4, -184($fp)
lw $t0, -184($fp)
lw $t3, -180($fp)
subu $sp, $sp, 4
add $t4, $t0, $t3
sw $t4, -188($fp)
sw $t0, -184($fp)
sw $t3, -180($fp)
lw $t0, -188($fp)
li $t3, 2
sw $t3, 4($t0)
sw $t0, -188($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t0, $t1
sw $t0, -192($fp)
li $t0, 2
li $t4, 4
subu $sp, $sp, 4
mul $t5, $t0, $t4
sw $t5, -196($fp)
lw $t0, -196($fp)
lw $t4, -192($fp)
subu $sp, $sp, 4
add $t5, $t0, $t4
sw $t5, -200($fp)
sw $t0, -196($fp)
sw $t4, -192($fp)
lw $t0, -200($fp)
li $t4, 3
sw $t4, 4($t0)
sw $t0, -200($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t0, $t1
sw $t0, -204($fp)
li $t0, 3
li $t5, 4
subu $sp, $sp, 4
mul $t6, $t0, $t5
sw $t6, -208($fp)
lw $t0, -208($fp)
lw $t5, -204($fp)
subu $sp, $sp, 4
add $t6, $t0, $t5
sw $t6, -212($fp)
sw $t0, -208($fp)
sw $t5, -204($fp)
lw $t0, -212($fp)
li $t5, 4
sw $t5, 4($t0)
sw $t0, -212($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t0, $t1
sw $t0, -216($fp)
li $t0, 4
li $t6, 4
subu $sp, $sp, 4
mul $t7, $t0, $t6
sw $t7, -220($fp)
lw $t0, -220($fp)
lw $t6, -216($fp)
subu $sp, $sp, 4
add $t7, $t0, $t6
sw $t7, -224($fp)
sw $t0, -220($fp)
sw $t6, -216($fp)
lw $t0, -224($fp)
li $t6, 5
sw $t6, 4($t0)
sw $t0, -224($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
move $t0, $v0
subu $sp, $sp, 4
move $t7, $t0
sw $t7, -232($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
move $t7, $v0
subu $sp, $sp, 4
move $s0, $t7
sw $s0, -240($fp)
lw $s0, -232($fp)
subu $sp, $sp, 4
sw $s0, 0($sp)
jal calculateBase
addi $sp, $sp, 4
subu $sp, $sp, 4
move $s1, $v0
subu $sp, $sp, 4
move $s2, $s1
sw $s2, -248($fp)
lw $s2, -240($fp)
subu $sp, $sp, 4
sw $s2, 0($sp)
lw $s3, -248($fp)
subu $sp, $sp, 4
sw $s3, 0($sp)
jal determineIndex
addi $sp, $sp, 8
subu $sp, $sp, 4
move $s4, $v0
subu $sp, $sp, 4
move $s5, $s4
sw $s5, -256($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $s5, $t1
sw $s5, -260($fp)
lw $s5, -256($fp)
li $s6, 4
subu $sp, $sp, 4
mul $s7, $s5, $s6
sw $s7, -264($fp)
sw $s5, -256($fp)
lw $s5, -264($fp)
lw $s6, -260($fp)
subu $sp, $sp, 4
add $s7, $s5, $s6
sw $s7, -268($fp)
sw $s5, -264($fp)
sw $s6, -260($fp)
lw $s5, -268($fp)
subu $sp, $sp, 4
lw $s6, 4($s5)
sw $s6, -272($fp)
subu $sp, $sp, 4
lw $s7, -272($fp)
move $s6, $s7
sw $s6, -276($fp)
lw $s3, -248($fp)
li $s6, 30
bgt $s3, $s6, label10
j label8
label10 :
lw $s2, -240($fp)
li $t8, 0
bgt $s2, $t8, label7
j label8
label7 :
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t9, $t1
sw $t9, -280($fp)
lw $t9, -256($fp)
li $t2, 4
subu $sp, $sp, 4
mul $t3, $t9, $t2
sw $t3, -284($fp)
sw $t9, -256($fp)
lw $t2, -284($fp)
lw $t3, -280($fp)
subu $sp, $sp, 4
add $t9, $t2, $t3
sw $t9, -288($fp)
sw $t2, -284($fp)
sw $t3, -280($fp)
lw $t2, -288($fp)
lw $s3, -248($fp)
sw $s3, 4($t2)
sw $t2, -288($fp)
j label9
label8 :
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t2, $t1
sw $t2, -292($fp)
lw $t2, -256($fp)
li $t3, 4
subu $sp, $sp, 4
mul $t9, $t2, $t3
sw $t9, -296($fp)
sw $t2, -256($fp)
lw $t2, -296($fp)
lw $t3, -292($fp)
subu $sp, $sp, 4
add $t9, $t2, $t3
sw $t9, -300($fp)
sw $t2, -296($fp)
sw $t3, -292($fp)
lw $t2, -276($fp)
li $t3, 2
subu $sp, $sp, 4
mul $t9, $t2, $t3
sw $t9, -304($fp)
sw $t2, -276($fp)
lw $t2, -300($fp)
lw $t3, -304($fp)
sw $t3, 4($t2)
sw $t2, -300($fp)
label9 :
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t2, $t1
sw $t2, -308($fp)
lw $t2, -256($fp)
li $t9, 4
subu $sp, $sp, 4
mul $t4, $t2, $t9
sw $t4, -312($fp)
sw $t2, -256($fp)
lw $t2, -312($fp)
lw $t4, -308($fp)
subu $sp, $sp, 4
add $t9, $t2, $t4
sw $t9, -316($fp)
sw $t2, -312($fp)
sw $t4, -308($fp)
lw $t2, -316($fp)
subu $sp, $sp, 4
lw $t4, 4($t2)
sw $t4, -320($fp)
subu $sp, $sp, 4
lw $t9, -320($fp)
move $t4, $t9
sw $t4, -324($fp)
lw $t4, -256($fp)
move $a0, $t4
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t5, -276($fp)
move $a0, $t5
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t6, -324($fp)
move $a0, $t6
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
sw $t0, -228($fp)
li $t0, 0
move $v0, $t0
lw $ra, -8($fp)
lw $fp, -4($fp)
addi $sp, $sp, 80
jr $ra

