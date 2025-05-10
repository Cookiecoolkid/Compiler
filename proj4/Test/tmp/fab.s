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
subu $sp, $sp, 8	# 分配栈帧
sw $fp, 4($sp)	# 保存旧帧指针
sw $ra, 0($sp)	# 保存返回地址
addiu $fp, $sp, 8	# 设置新的帧指针
li $t0, 0
li $t1, 1
li $t2, 0
addi $sp, $sp, -4	# READ temp0: 保存返回地址
sw $ra, 0($sp)	# READ temp0: 保存返回地址
jal read	# READ temp0: 调用read函数
lw $ra, 0($sp)	# READ temp0: 恢复返回地址
addi $sp, $sp, 4	# READ temp0: 释放栈空间
move $t3, $v0	# READ temp0: 将返回值存储到temp0
move $t4, $t3
label0 :
blt $t2, $t4, label1
j label2	# GOTO label2
label1 :
add $t5, $t0, $t1	# in handle_binary_op: temp1 := a_ + b_
move $t6, $t5
move $a0, $t1	# WRITE b_: 将值移动到$a0
subu $sp, $sp, 4	# WRITE b_: 保存返回地址
sw $ra, 0($sp)	# WRITE b_: 保存返回地址
jal write	# WRITE b_: 调用write函数
lw $ra, 0($sp)	# WRITE b_: 恢复返回地址
addi $sp, $sp, 4	# WRITE b_: 释放栈空间
move $t0, $t1
move $t1, $t6
li $t7, 1	# in get_operand_reg: load immediate �,��
add $s0, $t2, $t7	# in handle_binary_op: temp2 := i_ + #1
move $t2, $s0
j label0	# GOTO label0
label2 :
li $t7, 0	# in get_operand_reg: load immediate (null)
move $v0, $t7	# RETURN #0: 设置返回值
lw $ra, -8($fp)	# RETURN #0: 恢复返回地址
lw $fp, -4($fp)	# RETURN #0: 恢复帧指针
move $sp, $fp	# RETURN #0: 释放栈空间
jr $ra	# RETURN #0: 返回

