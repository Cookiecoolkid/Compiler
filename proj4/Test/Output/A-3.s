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
li $t2, 10
sw $t2, 4($t0)
sw $t0, -176($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t0, $t1
sw $t0, -180($fp)
li $t0, 4
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
li $t3, 50
sw $t3, 4($t0)
sw $t0, -188($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
move $t0, $v0
subu $sp, $sp, 4
move $t4, $t0
sw $t4, -196($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
move $t4, $v0
subu $sp, $sp, 4
move $t5, $t4
sw $t5, -204($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t5, $t1
sw $t5, -208($fp)
lw $t5, -204($fp)
li $t6, 4
subu $sp, $sp, 4
mul $t7, $t5, $t6
sw $t7, -212($fp)
sw $t5, -204($fp)
lw $t5, -212($fp)
lw $t6, -208($fp)
subu $sp, $sp, 4
add $t7, $t5, $t6
sw $t7, -216($fp)
sw $t5, -212($fp)
sw $t6, -208($fp)
lw $t5, -216($fp)
lw $t6, -196($fp)
sw $t6, 4($t5)
sw $t5, -216($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
move $t5, $v0
subu $sp, $sp, 4
move $t7, $t5
sw $t7, -224($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t7, $t1
sw $t7, -228($fp)
li $t7, 0
li $s0, 4
subu $sp, $sp, 4
mul $s1, $t7, $s0
sw $s1, -232($fp)
lw $t7, -232($fp)
lw $s0, -228($fp)
subu $sp, $sp, 4
add $s1, $t7, $s0
sw $s1, -236($fp)
sw $t7, -232($fp)
sw $s0, -228($fp)
lw $t7, -236($fp)
subu $sp, $sp, 4
lw $s0, 4($t7)
sw $s0, -240($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $s0, $t1
sw $s0, -244($fp)
lw $s0, -204($fp)
li $s1, 4
subu $sp, $sp, 4
mul $s2, $s0, $s1
sw $s2, -248($fp)
sw $s0, -204($fp)
lw $s0, -248($fp)
lw $s1, -244($fp)
subu $sp, $sp, 4
add $s2, $s0, $s1
sw $s2, -252($fp)
sw $s0, -248($fp)
sw $s1, -244($fp)
lw $s0, -252($fp)
subu $sp, $sp, 4
lw $s1, 4($s0)
sw $s1, -256($fp)
lw $s1, -240($fp)
lw $s2, -256($fp)
subu $sp, $sp, 4
add $s3, $s1, $s2
sw $s3, -260($fp)
sw $s1, -240($fp)
sw $s2, -256($fp)
subu $sp, $sp, 4
lw $s2, -260($fp)
move $s1, $s2
sw $s1, -264($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $s1, $t1
sw $s1, -268($fp)
lw $s1, -224($fp)
li $s3, 4
subu $sp, $sp, 4
mul $s4, $s1, $s3
sw $s4, -272($fp)
sw $s1, -224($fp)
lw $s1, -272($fp)
lw $s3, -268($fp)
subu $sp, $sp, 4
add $s4, $s1, $s3
sw $s4, -276($fp)
sw $s1, -272($fp)
sw $s3, -268($fp)
lw $s1, -276($fp)
subu $sp, $sp, 4
lw $s3, 4($s1)
sw $s3, -280($fp)
lw $s3, -264($fp)
lw $s4, -280($fp)
subu $sp, $sp, 4
mul $s5, $s3, $s4
sw $s5, -284($fp)
sw $s3, -264($fp)
sw $s4, -280($fp)
subu $sp, $sp, 4
lw $s4, -284($fp)
move $s3, $s4
sw $s3, -288($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $s3, $t1
sw $s3, -292($fp)
li $s3, 0
li $s5, 4
subu $sp, $sp, 4
mul $s6, $s3, $s5
sw $s6, -296($fp)
lw $s3, -296($fp)
lw $s5, -292($fp)
subu $sp, $sp, 4
add $s6, $s3, $s5
sw $s6, -300($fp)
sw $s3, -296($fp)
sw $s5, -292($fp)
lw $s3, -300($fp)
subu $sp, $sp, 4
lw $s5, 4($s3)
sw $s5, -304($fp)
lw $s5, -304($fp)
move $a0, $s5
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
addi $t1, $fp, -84
move $s6, $t1
sw $s6, -308($fp)
lw $s6, -204($fp)
li $s7, 4
subu $sp, $sp, 4
mul $t8, $s6, $s7
sw $t8, -312($fp)
sw $s6, -204($fp)
lw $s6, -312($fp)
lw $s7, -308($fp)
subu $sp, $sp, 4
add $t8, $s6, $s7
sw $t8, -316($fp)
sw $s6, -312($fp)
sw $s7, -308($fp)
lw $s6, -316($fp)
subu $sp, $sp, 4
lw $s7, 4($s6)
sw $s7, -320($fp)
lw $s7, -320($fp)
move $a0, $s7
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t8, $t1
sw $t8, -324($fp)
lw $t8, -224($fp)
li $t9, 4
subu $sp, $sp, 4
mul $t2, $t8, $t9
sw $t2, -328($fp)
sw $t8, -224($fp)
lw $t2, -328($fp)
lw $t8, -324($fp)
subu $sp, $sp, 4
add $t9, $t2, $t8
sw $t9, -332($fp)
sw $t2, -328($fp)
sw $t8, -324($fp)
lw $t2, -332($fp)
subu $sp, $sp, 4
lw $t8, 4($t2)
sw $t8, -336($fp)
lw $t8, -336($fp)
move $a0, $t8
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t9, $t1
sw $t9, -340($fp)
li $t9, 4
li $t3, 4
subu $sp, $sp, 4
sw $t0, -192($fp)
mul $t0, $t9, $t3
sw $t0, -344($fp)
lw $t0, -344($fp)
lw $t3, -340($fp)
subu $sp, $sp, 4
add $t9, $t0, $t3
sw $t9, -348($fp)
sw $t0, -344($fp)
sw $t3, -340($fp)
lw $t0, -348($fp)
subu $sp, $sp, 4
lw $t3, 4($t0)
sw $t3, -352($fp)
lw $t3, -352($fp)
move $a0, $t3
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t9, -288($fp)
move $a0, $t9
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
sw $t4, -200($fp)
li $t4, 0
move $v0, $t4
lw $ra, -8($fp)
lw $fp, -4($fp)
addi $sp, $sp, 80
jr $ra

