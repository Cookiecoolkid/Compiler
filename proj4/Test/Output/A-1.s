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
li $t0, 100# in process_expression: initialVal_ := #100
sw $t0, -100($fp)
li $t0, 7# in process_expression: input1_ := #7
sw $t0, -104($fp)
li $t0, 12# in process_expression: input2_ := #12
sw $t0, -108($fp)
lw $t0, -104($fp)
li $t1, 5
add $t2, $t0, $t1# in handle_binary_op: temp0 := input1_ + #5
sw $t2, -112($fp)
lw $t2, -100($fp)
li $t3, 50
div $t2, $t3
mflo $t4# in handle_binary_op: temp1 := initialVal_ / #50 (get quotient)
sw $t4, -116($fp)
lw $t4, -108($fp)
lw $t5, -116($fp)
sub $t6, $t4, $t5# in handle_binary_op: temp2 := input2_ - temp1
sw $t6, -120($fp)
lw $t6, -112($fp)
lw $t7, -120($fp)
mul $s0, $t6, $t7# in handle_binary_op: temp3 := temp0 * temp2
sw $s0, -124($fp)
lw $s1, -124($fp)
move $s0, $s1# in process_expression: intermediateCalc_ := temp3
sw $s0, -128($fp)
lw $s0, -128($fp)
add $s2, $s0, $t0# in handle_binary_op: temp4 := intermediateCalc_ + input1_
sw $s2, -132($fp)
lw $s3, -132($fp)
move $s2, $s3# in process_expression: reusedVar_ := temp4
sw $s2, -136($fp)
lw $s2, -136($fp)
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
sub $s4, $s2, $t4# in handle_binary_op: temp5 := reusedVar_ - input2_
sw $s4, -140($fp)
lw $s4, -140($fp)
li $s5, 3
mul $s6, $s4, $s5# in handle_binary_op: temp6 := temp5 * #3
sw $s6, -144($fp)
lw $s7, -144($fp)
move $s6, $s7# in process_expression: finalResult_ := temp6
sw $s6, -148($fp)
lw $s6, -148($fp)
li $t8, 2
div $s6, $t8
mflo $t9# in handle_binary_op: temp7 := finalResult_ / #2 (get quotient)
sw $t9, -152($fp)
lw $t9, -152($fp)
move $s2, $t9# in process_expression: reusedVar_ := temp7
sw $s2, -136($fp)
lw $s2, -136($fp)
move $a0, $s2# WRITE reusedVar_: 将值移动到$a0
subu $sp, $sp, 4# WRITE reusedVar_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE reusedVar_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE reusedVar_: 恢复返回地址
li $t1, 10
sw $t2, -100($fp)
mul $t2, $t4, $t1# in handle_binary_op: temp8 := input2_ * #10
sw $t2, -156($fp)
lw $t3, -156($fp)
move $t2, $t3# in process_expression: lateAssignVar_ := temp8
sw $t2, -160($fp)
lw $t2, -160($fp)
move $a0, $t2# WRITE lateAssignVar_: 将值移动到$a0
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
sw $t5, -116($fp)
li $t5, 0
move $v0, $t5# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

