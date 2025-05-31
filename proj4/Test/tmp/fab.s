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
subu $sp, $sp, 4
li $t0, 1
sw $t0, -88($fp)
subu $sp, $sp, 4
li $t0, 0
sw $t0, -92($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
subu $sp, $sp, 4
move $t0, $v0
subu $sp, $sp, 4
move $t1, $t0
sw $t1, -100($fp)
label0 :
lw $t1, -92($fp)
lw $t2, -100($fp)
blt $t1, $t2, label1
j label2
label1 :
lw $t3, -84($fp)
lw $t4, -88($fp)
subu $sp, $sp, 4
add $t5, $t3, $t4
sw $t5, -104($fp)
sw $t3, -84($fp)
sw $t4, -88($fp)
subu $sp, $sp, 4
lw $t4, -104($fp)
move $t3, $t4
sw $t3, -108($fp)
lw $t3, -88($fp)
move $a0, $t3
subu $sp, $sp, 4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t5, -84($fp)
lw $t3, -88($fp)
move $t5, $t3
sw $t5, -84($fp)
lw $t3, -88($fp)
lw $t5, -108($fp)
move $t3, $t5
sw $t3, -88($fp)
lw $t1, -92($fp)
li $t3, 1
subu $sp, $sp, 4
add $t6, $t1, $t3
sw $t6, -112($fp)
sw $t1, -92($fp)
lw $t1, -92($fp)
lw $t3, -112($fp)
move $t1, $t3
sw $t1, -92($fp)
j label0
label2 :
li $t1, 0
move $v0, $t1
lw $ra, -8($fp)
lw $fp, -4($fp)
addi $sp, $sp, 80
jr $ra

