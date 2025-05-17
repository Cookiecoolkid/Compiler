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
li $t0, 100
li $t1, 7
li $t2, 12
li $t3, 5# in get_operand_reg: load immediate 5
add $t4, $t1, $t3# in handle_binary_op: temp0 := input1_ + #5
sw $t4, -92($fp)
li $t4, 50# in get_operand_reg: load immediate 50
div $t0, $t4
mflo $t5# in handle_binary_op: temp1 := initialVal_ / #50 (get quotient)
sw $t5, -96($fp)
lw $t5, -96($fp)
sub $t6, $t2, $t5# in handle_binary_op: temp2 := input2_ - temp1
sw $t6, -100($fp)
lw $t6, -92($fp)
lw $t7, -100($fp)
mul $s0, $t6, $t7# in handle_binary_op: temp3 := temp0 * temp2
sw $s0, -104($fp)
lw $s1, -104($fp)
move $s0, $s1
add $s2, $s0, $t1# in handle_binary_op: temp4 := intermediateCalc_ + input1_
sw $s2, -112($fp)
lw $s3, -112($fp)
move $s2, $s3
move $a0, $s2# WRITE reusedVar_: 将值移动到$a0
subu $sp, $sp, 4# WRITE reusedVar_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE reusedVar_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE reusedVar_: 恢复返回地址
move $a0, $s0# WRITE intermediateCalc_: 将值移动到$a0
subu $sp, $sp, 4# WRITE intermediateCalc_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE intermediateCalc_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE intermediateCalc_: 恢复返回地址
sub $s4, $s2, $t2# in handle_binary_op: temp5 := reusedVar_ - input2_
sw $s4, -120($fp)
lw $s4, -120($fp)
li $s5, 3# in get_operand_reg: load immediate 3
mul $s6, $s4, $s5# in handle_binary_op: temp6 := temp5 * #3
sw $s6, -124($fp)
lw $s7, -124($fp)
move $s6, $s7
li $t8, 2# in get_operand_reg: load immediate 2
div $s6, $t8
mflo $t9# in handle_binary_op: temp7 := finalResult_ / #2 (get quotient)
sw $t9, -132($fp)
lw $t9, -132($fp)
move $s2, $t9
move $a0, $s2# WRITE reusedVar_: 将值移动到$a0
subu $sp, $sp, 4# WRITE reusedVar_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE reusedVar_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE reusedVar_: 恢复返回地址
li $t3, 10# in get_operand_reg: load immediate 10
mul $t0, $t2, $t3# in handle_binary_op: temp8 := input2_ * #10
sw $t0, -136($fp)
lw $t4, -136($fp)
move $t0, $t4
move $a0, $t0# WRITE lateAssignVar_: 将值移动到$a0
subu $sp, $sp, 4# WRITE lateAssignVar_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE lateAssignVar_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE lateAssignVar_: 恢复返回地址
move $a0, $s6# WRITE finalResult_: 将值移动到$a0
subu $sp, $sp, 4# WRITE finalResult_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE finalResult_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE finalResult_: 恢复返回地址
li $t5, 0# in get_operand_reg: load immediate 0
move $v0, $t5# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

