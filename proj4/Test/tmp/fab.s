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
li $t0, 0# in process_expression: a_ := #0
sw $t0, -256($fp)
li $t0, 1# in process_expression: b_ := #1
sw $t0, -260($fp)
li $t0, 0# in process_expression: i_ := #0
sw $t0, -264($fp)
addi $sp, $sp, -4# READ temp0: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp0: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp0: 恢复返回地址
move $t0, $v0# READ temp0: 将返回值存储到temp0
move $t1, $t0# in process_expression: n_ := temp0
sw $t1, -272($fp)
label0 :
lw $t1, -264($fp)
lw $t2, -272($fp)
blt $t1, $t2, label1
j label2# GOTO label2
label1 :
lw $t3, -256($fp)
lw $t4, -260($fp)
add $t5, $t3, $t4# in handle_binary_op: temp1 := a_ + b_
sw $t5, -276($fp)
lw $t6, -276($fp)
move $t5, $t6# in process_expression: c_ := temp1
sw $t5, -280($fp)
move $a0, $t4# WRITE b_: 将值移动到$a0
subu $sp, $sp, 4# WRITE b_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE b_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE b_: 恢复返回地址
move $t3, $t4# in process_expression: a_ := b_
sw $t3, -256($fp)
lw $t3, -280($fp)
move $t4, $t3# in process_expression: b_ := c_
sw $t4, -260($fp)
li $t4, 1
add $t5, $t1, $t4# in handle_binary_op: temp2 := i_ + #1
sw $t5, -284($fp)
lw $t5, -284($fp)
move $t1, $t5# in process_expression: i_ := temp2
sw $t1, -264($fp)
j label0# GOTO label0
label2 :
li $t1, 0
move $v0, $t1# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

