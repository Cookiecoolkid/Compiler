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

inc:
subu $sp, $sp, 80# FUNCTION inc: 分配栈帧
sw $fp, 76($sp)# FUNCTION inc: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION inc: 保存返回地址
addiu $fp, $sp, 80# FUNCTION inc: 设置新的帧指针
sw $t0, -12($fp)# FUNCTION inc: 保存寄存器 $t0
sw $t1, -16($fp)# FUNCTION inc: 保存寄存器 $t1
sw $t2, -20($fp)# FUNCTION inc: 保存寄存器 $t2
sw $t3, -24($fp)# FUNCTION inc: 保存寄存器 $t3
sw $t4, -28($fp)# FUNCTION inc: 保存寄存器 $t4
sw $t5, -32($fp)# FUNCTION inc: 保存寄存器 $t5
sw $t6, -36($fp)# FUNCTION inc: 保存寄存器 $t6
sw $t7, -40($fp)# FUNCTION inc: 保存寄存器 $t7
sw $s0, -44($fp)# FUNCTION inc: 保存寄存器 $s0
sw $s1, -48($fp)# FUNCTION inc: 保存寄存器 $s1
sw $s2, -52($fp)# FUNCTION inc: 保存寄存器 $s2
sw $s3, -56($fp)# FUNCTION inc: 保存寄存器 $s3
sw $s4, -60($fp)# FUNCTION inc: 保存寄存器 $s4
sw $s5, -64($fp)# FUNCTION inc: 保存寄存器 $s5
sw $s6, -68($fp)# FUNCTION inc: 保存寄存器 $s6
sw $s7, -72($fp)# FUNCTION inc: 保存寄存器 $s7
sw $t8, -76($fp)# FUNCTION inc: 保存寄存器 $t8
sw $t9, -80($fp)# FUNCTION inc: 保存寄存器 $t9
lw $t0, 0($fp)# PARAM a_: 读取第1个参数
li $t1, 1# in get_operand_reg: load immediate 1
add $t2, $t0, $t1# in handle_binary_op: temp0 := a_ + #1
move $t3, $t2
move $v0, $t3# RETURN b_: 设置返回值
lw $t9, -80($fp)# RETURN b_: 恢复寄存器$t9
lw $t8, -76($fp)# RETURN b_: 恢复寄存器$t8
lw $s7, -72($fp)# RETURN b_: 恢复寄存器$s7
lw $s6, -68($fp)# RETURN b_: 恢复寄存器$s6
lw $s5, -64($fp)# RETURN b_: 恢复寄存器$s5
lw $s4, -60($fp)# RETURN b_: 恢复寄存器$s4
lw $s3, -56($fp)# RETURN b_: 恢复寄存器$s3
lw $s2, -52($fp)# RETURN b_: 恢复寄存器$s2
lw $s1, -48($fp)# RETURN b_: 恢复寄存器$s1
lw $s0, -44($fp)# RETURN b_: 恢复寄存器$s0
lw $t7, -40($fp)# RETURN b_: 恢复寄存器$t7
lw $t6, -36($fp)# RETURN b_: 恢复寄存器$t6
lw $t5, -32($fp)# RETURN b_: 恢复寄存器$t5
lw $t4, -28($fp)# RETURN b_: 恢复寄存器$t4
lw $t3, -24($fp)# RETURN b_: 恢复寄存器$t3
lw $t2, -20($fp)# RETURN b_: 恢复寄存器$t2
lw $t1, -16($fp)# RETURN b_: 恢复寄存器$t1
lw $t0, -12($fp)# RETURN b_: 恢复寄存器$t0
lw $ra, -8($fp)# RETURN b_: 恢复返回地址
lw $fp, -4($fp)# RETURN b_: 恢复帧指针
addi $sp, $sp, 80
jr $ra

main:
subu $sp, $sp, 80# FUNCTION main: 分配栈帧
sw $fp, 76($sp)# FUNCTION main: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION main: 保存返回地址
addiu $fp, $sp, 80# FUNCTION main: 设置新的帧指针
li $t4, 2# in get_operand_reg: load immediate 2
li $t5, 2# in get_operand_reg: load immediate 2
mul $t6, $t4, $t5# in handle_binary_op: temp1 := #2 * #2
move $t7, $t6
subu $sp, $sp, 4# ARG lcVar_: 压栈参数
sw $t7, 0($sp)
jal inc# CALL inc: 调用函数
move $s0, $v0# CALL inc: 保存返回值
move $s1, $s0
move $a0, $s1# WRITE rcVar_: 将值移动到$a0
subu $sp, $sp, 4# WRITE rcVar_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE rcVar_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE rcVar_: 恢复返回地址
li $s2, 0# in get_operand_reg: load immediate 0
move $v0, $s2# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

