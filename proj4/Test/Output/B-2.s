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

processGridValue:
subu $sp, $sp, 80# FUNCTION processGridValue: 分配栈帧
sw $fp, 76($sp)# FUNCTION processGridValue: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION processGridValue: 保存返回地址
addiu $fp, $sp, 80# FUNCTION processGridValue: 设置新的帧指针
sw $t0, -12($fp)# FUNCTION processGridValue: 保存寄存器 $t0
sw $t1, -16($fp)# FUNCTION processGridValue: 保存寄存器 $t1
sw $t2, -20($fp)# FUNCTION processGridValue: 保存寄存器 $t2
sw $t3, -24($fp)# FUNCTION processGridValue: 保存寄存器 $t3
sw $t4, -28($fp)# FUNCTION processGridValue: 保存寄存器 $t4
sw $t5, -32($fp)# FUNCTION processGridValue: 保存寄存器 $t5
sw $t6, -36($fp)# FUNCTION processGridValue: 保存寄存器 $t6
sw $t7, -40($fp)# FUNCTION processGridValue: 保存寄存器 $t7
sw $s0, -44($fp)# FUNCTION processGridValue: 保存寄存器 $s0
sw $s1, -48($fp)# FUNCTION processGridValue: 保存寄存器 $s1
sw $s2, -52($fp)# FUNCTION processGridValue: 保存寄存器 $s2
sw $s3, -56($fp)# FUNCTION processGridValue: 保存寄存器 $s3
sw $s4, -60($fp)# FUNCTION processGridValue: 保存寄存器 $s4
sw $s5, -64($fp)# FUNCTION processGridValue: 保存寄存器 $s5
sw $s6, -68($fp)# FUNCTION processGridValue: 保存寄存器 $s6
sw $s7, -72($fp)# FUNCTION processGridValue: 保存寄存器 $s7
sw $t8, -76($fp)# FUNCTION processGridValue: 保存寄存器 $t8
sw $t9, -80($fp)# FUNCTION processGridValue: 保存寄存器 $t9
lw $t0, 0($fp)# PARAM rowIdx_: 读取第1个参数
lw $t1, -4($fp)# PARAM colIdx_: 读取第2个参数
lw $t2, -8($fp)# PARAM factorParam_: 读取第3个参数
mul $t3, $t0, $t0# in handle_binary_op: temp0 := rowIdx_ * rowIdx_
sw $t3, -112($fp)
mul $t3, $t1, $t2# in handle_binary_op: temp1 := colIdx_ * factorParam_
sw $t3, -116($fp)
lw $t3, -112($fp)
lw $t4, -116($fp)
add $t5, $t3, $t4# in handle_binary_op: temp2 := temp0 + temp1
sw $t5, -120($fp)
lw $t6, -120($fp)
move $t5, $t6# in process_expression: gridResult_ := temp2
sw $t5, -124($fp)
lw $t5, -124($fp)
li $t7, 10
div $t5, $t7
mflo $s0# in handle_binary_op: temp3 := gridResult_ / #10 (get quotient)
sw $s0, -128($fp)
lw $s0, -128($fp)
li $s1, 10
mul $s2, $s0, $s1# in handle_binary_op: temp4 := temp3 * #10
sw $s2, -132($fp)
lw $s2, -132($fp)
beq $s2, $t5, label0
j label1# GOTO label1
label0 :
li $s3, 10
div $t5, $s3
mflo $s4# in handle_binary_op: temp5 := gridResult_ / #10 (get quotient)
sw $s4, -136($fp)
lw $s4, -136($fp)
move $v0, $s4# RETURN temp5: 设置返回值
lw $t9, -80($fp)# RETURN temp5: 恢复寄存器$t9
lw $t8, -76($fp)# RETURN temp5: 恢复寄存器$t8
lw $s7, -72($fp)# RETURN temp5: 恢复寄存器$s7
lw $s6, -68($fp)# RETURN temp5: 恢复寄存器$s6
lw $s5, -64($fp)# RETURN temp5: 恢复寄存器$s5
lw $s4, -60($fp)# RETURN temp5: 恢复寄存器$s4
lw $s3, -56($fp)# RETURN temp5: 恢复寄存器$s3
lw $s2, -52($fp)# RETURN temp5: 恢复寄存器$s2
lw $s1, -48($fp)# RETURN temp5: 恢复寄存器$s1
lw $s0, -44($fp)# RETURN temp5: 恢复寄存器$s0
lw $t7, -40($fp)# RETURN temp5: 恢复寄存器$t7
lw $t6, -36($fp)# RETURN temp5: 恢复寄存器$t6
lw $t5, -32($fp)# RETURN temp5: 恢复寄存器$t5
lw $t4, -28($fp)# RETURN temp5: 恢复寄存器$t4
lw $t3, -24($fp)# RETURN temp5: 恢复寄存器$t3
lw $t2, -20($fp)# RETURN temp5: 恢复寄存器$t2
lw $t1, -16($fp)# RETURN temp5: 恢复寄存器$t1
lw $t0, -12($fp)# RETURN temp5: 恢复寄存器$t0
lw $ra, -8($fp)# RETURN temp5: 恢复返回地址
lw $fp, -4($fp)# RETURN temp5: 恢复帧指针
addi $sp, $sp, 80
jr $ra

j label2# GOTO label2
label1 :
li $s5, 5
add $s6, $t5, $s5# in handle_binary_op: temp6 := gridResult_ + #5
sw $s6, -140($fp)
lw $s6, -140($fp)
move $v0, $s6# RETURN temp6: 设置返回值
lw $t9, -80($fp)# RETURN temp6: 恢复寄存器$t9
lw $t8, -76($fp)# RETURN temp6: 恢复寄存器$t8
lw $s7, -72($fp)# RETURN temp6: 恢复寄存器$s7
lw $s6, -68($fp)# RETURN temp6: 恢复寄存器$s6
lw $s5, -64($fp)# RETURN temp6: 恢复寄存器$s5
lw $s4, -60($fp)# RETURN temp6: 恢复寄存器$s4
lw $s3, -56($fp)# RETURN temp6: 恢复寄存器$s3
lw $s2, -52($fp)# RETURN temp6: 恢复寄存器$s2
lw $s1, -48($fp)# RETURN temp6: 恢复寄存器$s1
lw $s0, -44($fp)# RETURN temp6: 恢复寄存器$s0
lw $t7, -40($fp)# RETURN temp6: 恢复寄存器$t7
lw $t6, -36($fp)# RETURN temp6: 恢复寄存器$t6
lw $t5, -32($fp)# RETURN temp6: 恢复寄存器$t5
lw $t4, -28($fp)# RETURN temp6: 恢复寄存器$t4
lw $t3, -24($fp)# RETURN temp6: 恢复寄存器$t3
lw $t2, -20($fp)# RETURN temp6: 恢复寄存器$t2
lw $t1, -16($fp)# RETURN temp6: 恢复寄存器$t1
lw $t0, -12($fp)# RETURN temp6: 恢复寄存器$t0
lw $ra, -8($fp)# RETURN temp6: 恢复返回地址
lw $fp, -4($fp)# RETURN temp6: 恢复帧指针
addi $sp, $sp, 80
jr $ra

label2 :
main:
subu $sp, $sp, 80# FUNCTION main: 分配栈帧
sw $fp, 76($sp)# FUNCTION main: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION main: 保存返回地址
addiu $fp, $sp, 80# FUNCTION main: 设置新的帧指针
li $s7, 4# in process_expression: gridSize_ := #4
sw $s7, -144($fp)
li $s7, 0# in process_expression: rowLoop_ := #0
sw $s7, -148($fp)
li $s7, 0# in process_expression: colLoop_ := #0
sw $s7, -152($fp)
li $s7, 0# in process_expression: gridTotalSum_ := #0
sw $s7, -156($fp)
li $s7, 0# in process_expression: gridConditionCount_ := #0
sw $s7, -160($fp)
addi $sp, $sp, -4# READ temp7: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp7: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp7: 恢复返回地址
move $s7, $v0# READ temp7: 将返回值存储到temp7
move $t8, $s7# in process_expression: procFactor_ := temp7
sw $t8, -168($fp)
label3 :
lw $t8, -148($fp)
lw $t9, -144($fp)
blt $t8, $t9, label4
j label5# GOTO label5
label4 :
sw $t0, -100($fp)
lw $t0, -152($fp)
li $t0, 0# in process_expression: colLoop_ := #0
sw $t0, -152($fp)
label6 :
lw $t0, -152($fp)
blt $t0, $t9, label7
j label8# GOTO label8
label7 :
sw $t1, -104($fp)
lw $t1, -168($fp)
subu $sp, $sp, 4# ARG procFactor_: 压栈参数
sw $t1, 0($sp)
subu $sp, $sp, 4# ARG colLoop_: 压栈参数
sw $t0, 0($sp)
subu $sp, $sp, 4# ARG rowLoop_: 压栈参数
sw $t8, 0($sp)
jal processGridValue# CALL processGridValue: 调用函数
sw $t2, -108($fp)
move $t2, $v0# CALL processGridValue: 保存返回值
sw $t3, -112($fp)
move $t3, $t2# in process_expression: gridProcessedVal_ := temp8
sw $t3, -176($fp)
lw $t3, -156($fp)
sw $t4, -116($fp)
lw $t4, -176($fp)
sw $t6, -120($fp)
add $t6, $t3, $t4# in handle_binary_op: temp9 := gridTotalSum_ + gridProcessedVal_
sw $t6, -180($fp)
lw $t6, -180($fp)
move $t3, $t6# in process_expression: gridTotalSum_ := temp9
sw $t3, -156($fp)
li $t3, 25
bgt $t4, $t3, label9
j label10# GOTO label10
label9 :
lw $t7, -160($fp)
sw $s0, -128($fp)
li $s0, 1
add $s1, $t7, $s0# in handle_binary_op: temp10 := gridConditionCount_ + #1
sw $s1, -184($fp)
lw $s1, -184($fp)
move $t7, $s1# in process_expression: gridConditionCount_ := temp10
sw $t7, -160($fp)
label10 :
li $t7, 1
sw $s2, -132($fp)
add $s2, $t0, $t7# in handle_binary_op: temp11 := colLoop_ + #1
sw $s2, -188($fp)
lw $s2, -188($fp)
move $t0, $s2# in process_expression: colLoop_ := temp11
sw $t0, -152($fp)
j label6# GOTO label6
label8 :
li $t0, 1
add $s3, $t8, $t0# in handle_binary_op: temp12 := rowLoop_ + #1
sw $s3, -192($fp)
lw $s3, -192($fp)
move $t8, $s3# in process_expression: rowLoop_ := temp12
sw $t8, -148($fp)
j label3# GOTO label3
label5 :
lw $t8, -156($fp)
move $a0, $t8# WRITE gridTotalSum_: 将值移动到$a0
subu $sp, $sp, 4# WRITE gridTotalSum_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE gridTotalSum_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE gridTotalSum_: 恢复返回地址
sw $s4, -136($fp)
lw $s4, -160($fp)
move $a0, $s4# WRITE gridConditionCount_: 将值移动到$a0
subu $sp, $sp, 4# WRITE gridConditionCount_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE gridConditionCount_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE gridConditionCount_: 恢复返回地址
sw $t5, -124($fp)
li $t5, 0
move $v0, $t5# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

