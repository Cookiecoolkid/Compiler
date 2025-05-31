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
li $t0, 1
sw $t0, -84($fp)
subu $sp, $sp, 4
li $t0, 2
sw $t0, -88($fp)
subu $sp, $sp, 4
li $t0, 3
sw $t0, -92($fp)
lw $t0, -88($fp)
lw $t1, -92($fp)
subu $sp, $sp, 4
mul $t2, $t0, $t1
sw $t2, -96($fp)
sw $t0, -88($fp)
sw $t1, -92($fp)
lw $t0, -84($fp)
lw $t1, -96($fp)
subu $sp, $sp, 4
add $t2, $t0, $t1
sw $t2, -100($fp)
sw $t0, -84($fp)
sw $t1, -96($fp)
subu $sp, $sp, 4
lw $t1, -100($fp)
move $t0, $t1
sw $t0, -104($fp)
