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

fact:
subu $sp, $sp, 80	# 分配栈帧
sw $fp, 76($sp)	# 保存旧帧指针
sw $ra, 72($sp)	# 保存返回地址
addiu $fp, $sp, 80	# 设置新的帧指针
sw $t0, -12($fp)	# 保存寄存器 $t0
sw $t1, -16($fp)	# 保存寄存器 $t1
sw $t2, -20($fp)	# 保存寄存器 $t2
sw $t3, -24($fp)	# 保存寄存器 $t3
sw $t4, -28($fp)	# 保存寄存器 $t4
sw $t5, -32($fp)	# 保存寄存器 $t5
sw $t6, -36($fp)	# 保存寄存器 $t6
sw $t7, -40($fp)	# 保存寄存器 $t7
sw $s0, -44($fp)	# 保存寄存器 $s0
sw $s1, -48($fp)	# 保存寄存器 $s1
sw $s2, -52($fp)	# 保存寄存器 $s2
sw $s3, -56($fp)	# 保存寄存器 $s3
sw $s4, -60($fp)	# 保存寄存器 $s4
sw $s5, -64($fp)	# 保存寄存器 $s5
sw $s6, -68($fp)	# 保存寄存器 $s6
sw $s7, -72($fp)	# 保存寄存器 $s7
sw $t8, -76($fp)	# 保存寄存器 $t8
sw $t9, -80($fp)	# 保存寄存器 $t9
lw $t0, 0($fp)	# 读取第1个参数 n_
beq $t0, $t1, label0
j label1	# GOTO label1
label0 :
move $v0, $t0	# RETURN n_: 设置返回值
lw $t9, -80($fp)	# RETURN n_: 恢复寄存器$t9
lw $t8, -76($fp)	# RETURN n_: 恢复寄存器$t8
lw $s7, -72($fp)	# RETURN n_: 恢复寄存器$s7
lw $s6, -68($fp)	# RETURN n_: 恢复寄存器$s6
lw $s5, -64($fp)	# RETURN n_: 恢复寄存器$s5
lw $s4, -60($fp)	# RETURN n_: 恢复寄存器$s4
lw $s3, -56($fp)	# RETURN n_: 恢复寄存器$s3
lw $s2, -52($fp)	# RETURN n_: 恢复寄存器$s2
lw $s1, -48($fp)	# RETURN n_: 恢复寄存器$s1
lw $s0, -44($fp)	# RETURN n_: 恢复寄存器$s0
lw $t7, -40($fp)	# RETURN n_: 恢复寄存器$t7
lw $t6, -36($fp)	# RETURN n_: 恢复寄存器$t6
lw $t5, -32($fp)	# RETURN n_: 恢复寄存器$t5
lw $t4, -28($fp)	# RETURN n_: 恢复寄存器$t4
lw $t3, -24($fp)	# RETURN n_: 恢复寄存器$t3
lw $t2, -20($fp)	# RETURN n_: 恢复寄存器$t2
lw $t1, -16($fp)	# RETURN n_: 恢复寄存器$t1
lw $t0, -12($fp)	# RETURN n_: 恢复寄存器$t0
lw $ra, -8($fp)	# RETURN n_: 恢复返回地址
lw $fp, -4($fp)	# RETURN n_: 恢复帧指针
move $sp, $fp	# RETURN n_: 释放栈空间
jr $ra	# RETURN n_: 返回

label1 :
li $t2, 1	# in get_operand_reg: load immediate �,��
sub $t3, $t0, $t2	# in handle_binary_op: temp0 := n_ - #1
subu $sp, $sp, 4	# 压栈参数 temp0
sw $t3, 0($sp)
jal fact	# 调用函数 fact
addi $sp, $sp, 4	# 清理参数栈空间
move $t2, $v0	# 保存返回值
mul $t4, $t0, $t2	# in handle_binary_op: temp2 := n_ * temp1
move $v0, $t4	# RETURN temp2: 设置返回值
lw $t9, -80($fp)	# RETURN temp2: 恢复寄存器$t9
lw $t8, -76($fp)	# RETURN temp2: 恢复寄存器$t8
lw $s7, -72($fp)	# RETURN temp2: 恢复寄存器$s7
lw $s6, -68($fp)	# RETURN temp2: 恢复寄存器$s6
lw $s5, -64($fp)	# RETURN temp2: 恢复寄存器$s5
lw $s4, -60($fp)	# RETURN temp2: 恢复寄存器$s4
lw $s3, -56($fp)	# RETURN temp2: 恢复寄存器$s3
lw $s2, -52($fp)	# RETURN temp2: 恢复寄存器$s2
lw $s1, -48($fp)	# RETURN temp2: 恢复寄存器$s1
lw $s0, -44($fp)	# RETURN temp2: 恢复寄存器$s0
lw $t7, -40($fp)	# RETURN temp2: 恢复寄存器$t7
lw $t6, -36($fp)	# RETURN temp2: 恢复寄存器$t6
lw $t5, -32($fp)	# RETURN temp2: 恢复寄存器$t5
lw $t4, -28($fp)	# RETURN temp2: 恢复寄存器$t4
lw $t3, -24($fp)	# RETURN temp2: 恢复寄存器$t3
lw $t2, -20($fp)	# RETURN temp2: 恢复寄存器$t2
lw $t1, -16($fp)	# RETURN temp2: 恢复寄存器$t1
lw $t0, -12($fp)	# RETURN temp2: 恢复寄存器$t0
lw $ra, -8($fp)	# RETURN temp2: 恢复返回地址
lw $fp, -4($fp)	# RETURN temp2: 恢复帧指针
move $sp, $fp	# RETURN temp2: 释放栈空间
jr $ra	# RETURN temp2: 返回

main:
subu $sp, $sp, 8	# 分配栈帧
sw $fp, 4($sp)	# 保存旧帧指针
sw $ra, 0($sp)	# 保存返回地址
addiu $fp, $sp, 8	# 设置新的帧指针
addi $sp, $sp, -4	# READ temp3: 保存返回地址
sw $ra, 0($sp)	# READ temp3: 保存返回地址
jal read	# READ temp3: 调用read函数
lw $ra, 0($sp)	# READ temp3: 恢复返回地址
addi $sp, $sp, 4	# READ temp3: 释放栈空间
move $t5, $v0	# READ temp3: 将返回值存储到temp3
move $t6, $t5
bgt $t6, $t1, label3
j label4	# GOTO label4
label3 :
subu $sp, $sp, 4	# 压栈参数 m_
sw $t6, 0($sp)
jal fact	# 调用函数 fact
addi $sp, $sp, 4	# 清理参数栈空间
move $t7, $v0	# 保存返回值
move $s0, $t7
j label5	# GOTO label5
label4 :
li $s0, 1
label5 :
move $a0, $s0	# WRITE result_: 将值移动到$a0
subu $sp, $sp, 4	# WRITE result_: 保存返回地址
sw $ra, 0($sp)	# WRITE result_: 保存返回地址
jal write	# WRITE result_: 调用write函数
lw $ra, 0($sp)	# WRITE result_: 恢复返回地址
addi $sp, $sp, 4	# WRITE result_: 释放栈空间
li $s1, 0	# in get_operand_reg: load immediate (null)
move $v0, $s1	# RETURN #0: 设置返回值
lw $ra, -8($fp)	# RETURN #0: 恢复返回地址
lw $fp, -4($fp)	# RETURN #0: 恢复帧指针
move $sp, $fp	# RETURN #0: 释放栈空间
jr $ra	# RETURN #0: 返回

