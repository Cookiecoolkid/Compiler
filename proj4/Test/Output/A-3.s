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
subu $sp, $sp, 80# FUNCTION main: 分配栈帧
sw $fp, 76($sp)# FUNCTION main: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION main: 保存返回地址
addiu $fp, $sp, 80# FUNCTION main: 设置新的帧指针
move $t0, $t1
li $t2, 0
li $t3, 4
mul $t4, $t2, $t3# in handle_binary_op: temp1 := #0 * #4
sw $t4, -88($fp)
lw $t4, -88($fp)
add $t5, $t4, $t0# in handle_binary_op: temp2 := temp1 + temp0
sw $t5, -92($fp)
li $t5, 10
move $t6, $t1
li $t7, 4
li $s0, 4
mul $s1, $t7, $s0# in handle_binary_op: temp4 := #4 * #4
sw $s1, -104($fp)
lw $s1, -104($fp)
add $s2, $s1, $t6# in handle_binary_op: temp5 := temp4 + temp3
sw $s2, -108($fp)
li $s2, 50
addi $sp, $sp, -4# READ temp6: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp6: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp6: 恢复返回地址
move $s3, $v0# READ temp6: 将返回值存储到temp6
move $s4, $s3
addi $sp, $sp, -4# READ temp7: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp7: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp7: 恢复返回地址
move $s5, $v0# READ temp7: 将返回值存储到temp7
move $s6, $s5
move $s7, $t1
li $t8, 4
mul $t9, $s6, $t8# in handle_binary_op: temp9 := index1_ * #4
sw $t9, -136($fp)
lw $t9, -136($fp)
add $t2, $t9, $s7# in handle_binary_op: temp10 := temp9 + temp8
sw $t2, -140($fp)
lw $t2, -140($fp)
move $t2, $s4
addi $sp, $sp, -4# READ temp11: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp11: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp11: 恢复返回地址
move $t3, $v0# READ temp11: 将返回值存储到temp11
move $t4, $t3
move $t0, $t1
li $t5, 0
li $t7, 4
mul $s0, $t5, $t7# in handle_binary_op: temp13 := #0 * #4
sw $s0, -156($fp)
lw $s0, -156($fp)
add $s1, $s0, $t0# in handle_binary_op: temp14 := temp13 + temp12
sw $s1, -160($fp)
lw $t6, -160($fp)
lw $s1, 0($t6)
move $s2, $t1
li $s3, 4
mul $s5, $s6, $s3# in handle_binary_op: temp17 := index1_ * #4
sw $s5, -172($fp)
lw $s5, -172($fp)
add $t8, $s5, $s2# in handle_binary_op: temp18 := temp17 + temp16
sw $t8, -176($fp)
lw $t9, -176($fp)
lw $t8, 0($t9)
add $s7, $s1, $t8# in handle_binary_op: temp20 := temp15 + temp19
sw $s7, -184($fp)
lw $t2, -184($fp)
move $s7, $t2
move $s4, $t1
li $t3, 4
mul $t5, $t4, $t3# in handle_binary_op: temp22 := index2_ * #4
sw $t5, -196($fp)
lw $t5, -196($fp)
add $t7, $t5, $s4# in handle_binary_op: temp23 := temp22 + temp21
sw $t7, -200($fp)
lw $s0, -200($fp)
lw $t7, 0($s0)
mul $t0, $s7, $t7# in handle_binary_op: temp25 := temp_ * temp24
sw $t0, -208($fp)
lw $t6, -208($fp)
move $t0, $t6
move $s6, $t1
li $s3, 0
li $s5, 4
mul $s2, $s3, $s5# in handle_binary_op: temp27 := #0 * #4
sw $s2, -220($fp)
lw $s2, -220($fp)
add $t9, $s2, $s6# in handle_binary_op: temp28 := temp27 + temp26
sw $t9, -224($fp)
lw $s1, -224($fp)
lw $t9, 0($s1)
move $a0, $t9# WRITE temp29: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp29: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp29: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp29: 恢复返回地址
move $t8, $t1
lw $t2, -128($fp)
li $t4, 4
mul $t3, $t2, $t4# in handle_binary_op: temp31 := index1_ * #4
sw $t3, -236($fp)
lw $t3, -236($fp)
add $t5, $t3, $t8# in handle_binary_op: temp32 := temp31 + temp30
sw $t5, -240($fp)
lw $s4, -240($fp)
lw $t5, 0($s4)
move $a0, $t5# WRITE temp33: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp33: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp33: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp33: 恢复返回地址
move $s0, $t1
li $s7, 4
mul $t7, $t4, $s7# in handle_binary_op: temp35 := index2_ * #4
sw $t7, -252($fp)
lw $t7, -252($fp)
add $t0, $t7, $s0# in handle_binary_op: temp36 := temp35 + temp34
sw $t0, -256($fp)
lw $t6, -256($fp)
lw $t0, 0($t6)
move $a0, $t0# WRITE temp37: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp37: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp37: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp37: 恢复返回地址
move $s3, $t1
li $s5, 4
li $s2, 4
mul $s6, $s5, $s2# in handle_binary_op: temp39 := #4 * #4
sw $s6, -268($fp)
lw $s6, -268($fp)
add $s1, $s6, $s3# in handle_binary_op: temp40 := temp39 + temp38
sw $s1, -272($fp)
lw $t9, -272($fp)
lw $s1, 0($t9)
move $a0, $s1# WRITE temp41: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp41: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp41: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp41: 恢复返回地址
lw $t2, -212($fp)
move $a0, $t2# WRITE calculatedVal_: 将值移动到$a0
subu $sp, $sp, 4# WRITE calculatedVal_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE calculatedVal_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE calculatedVal_: 恢复返回地址
li $t3, 0
move $v0, $t3# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

