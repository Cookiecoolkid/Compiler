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
li $t0, 0
li $t1, 1
li $t2, 0
addi $sp, $sp, -4# READ temp0: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp0: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp0: 恢复返回地址
move $t3, $v0# READ temp0: 将返回值存储到temp0
move $t4, $t3
label0 :
blt $t2, $t4, label1
j label2# GOTO label2
label1 :
add $t5, $t0, $t1# in handle_binary_op: temp1 := a_ + b_
sw $t5, -100($fp)
# in spill_variable: store temp1 to stack
lw $t6, -100($fp)
# in load_variable: load temp1 from stack
move $t5, $t6
move $a0, $t1# WRITE b_: 将值移动到$a0
subu $sp, $sp, 4# WRITE b_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE b_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE b_: 恢复返回地址
move $t0, $t1
move $t1, $t5
li $t7, 1# in get_operand_reg: load immediate 1
add $s0, $t2, $t7# in handle_binary_op: temp2 := i_ + #1
sw $s0, -108($fp)
# in spill_variable: store temp2 to stack
lw $s0, -108($fp)
# in load_variable: load temp2 from stack
move $t2, $s0
j label0# GOTO label0
label2 :
li $s1, 0# in get_operand_reg: load immediate 0
move $v0, $s1# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

