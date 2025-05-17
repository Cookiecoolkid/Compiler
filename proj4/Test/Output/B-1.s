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

calculateBase:
subu $sp, $sp, 80# FUNCTION calculateBase: 分配栈帧
sw $fp, 76($sp)# FUNCTION calculateBase: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION calculateBase: 保存返回地址
addiu $fp, $sp, 80# FUNCTION calculateBase: 设置新的帧指针
sw $t0, -12($fp)# FUNCTION calculateBase: 保存寄存器 $t0
sw $t1, -16($fp)# FUNCTION calculateBase: 保存寄存器 $t1
sw $t2, -20($fp)# FUNCTION calculateBase: 保存寄存器 $t2
sw $t3, -24($fp)# FUNCTION calculateBase: 保存寄存器 $t3
sw $t4, -28($fp)# FUNCTION calculateBase: 保存寄存器 $t4
sw $t5, -32($fp)# FUNCTION calculateBase: 保存寄存器 $t5
sw $t6, -36($fp)# FUNCTION calculateBase: 保存寄存器 $t6
sw $t7, -40($fp)# FUNCTION calculateBase: 保存寄存器 $t7
sw $s0, -44($fp)# FUNCTION calculateBase: 保存寄存器 $s0
sw $s1, -48($fp)# FUNCTION calculateBase: 保存寄存器 $s1
sw $s2, -52($fp)# FUNCTION calculateBase: 保存寄存器 $s2
sw $s3, -56($fp)# FUNCTION calculateBase: 保存寄存器 $s3
sw $s4, -60($fp)# FUNCTION calculateBase: 保存寄存器 $s4
sw $s5, -64($fp)# FUNCTION calculateBase: 保存寄存器 $s5
sw $s6, -68($fp)# FUNCTION calculateBase: 保存寄存器 $s6
sw $s7, -72($fp)# FUNCTION calculateBase: 保存寄存器 $s7
sw $t8, -76($fp)# FUNCTION calculateBase: 保存寄存器 $t8
sw $t9, -80($fp)# FUNCTION calculateBase: 保存寄存器 $t9
lw $t0, 0($fp)# PARAM inputParam_: 读取第1个参数
li $t1, 50
bgt $t0, $t1, label0
j label1# GOTO label1
label0 :
li $t2, 2
div $t0, $t2
mflo $t3# in handle_binary_op: temp0 := inputParam_ / #2 (get quotient)
sw $t3, -104($fp)
lw $t4, -104($fp)
move $t3, $t4# in process_expression: baseRes_ := temp0
sw $t3, -108($fp)
lw $t3, -108($fp)
move $v0, $t3# RETURN baseRes_: 设置返回值
lw $t9, -80($fp)# RETURN baseRes_: 恢复寄存器$t9
lw $t8, -76($fp)# RETURN baseRes_: 恢复寄存器$t8
lw $s7, -72($fp)# RETURN baseRes_: 恢复寄存器$s7
lw $s6, -68($fp)# RETURN baseRes_: 恢复寄存器$s6
lw $s5, -64($fp)# RETURN baseRes_: 恢复寄存器$s5
lw $s4, -60($fp)# RETURN baseRes_: 恢复寄存器$s4
lw $s3, -56($fp)# RETURN baseRes_: 恢复寄存器$s3
lw $s2, -52($fp)# RETURN baseRes_: 恢复寄存器$s2
lw $s1, -48($fp)# RETURN baseRes_: 恢复寄存器$s1
lw $s0, -44($fp)# RETURN baseRes_: 恢复寄存器$s0
lw $t7, -40($fp)# RETURN baseRes_: 恢复寄存器$t7
lw $t6, -36($fp)# RETURN baseRes_: 恢复寄存器$t6
lw $t5, -32($fp)# RETURN baseRes_: 恢复寄存器$t5
lw $t4, -28($fp)# RETURN baseRes_: 恢复寄存器$t4
lw $t3, -24($fp)# RETURN baseRes_: 恢复寄存器$t3
lw $t2, -20($fp)# RETURN baseRes_: 恢复寄存器$t2
lw $t1, -16($fp)# RETURN baseRes_: 恢复寄存器$t1
lw $t0, -12($fp)# RETURN baseRes_: 恢复寄存器$t0
lw $ra, -8($fp)# RETURN baseRes_: 恢复返回地址
lw $fp, -4($fp)# RETURN baseRes_: 恢复帧指针
addi $sp, $sp, 80
jr $ra

j label2# GOTO label2
label1 :
li $t5, 10
add $t6, $t0, $t5# in handle_binary_op: temp1 := inputParam_ + #10
sw $t6, -112($fp)
lw $t6, -112($fp)
move $t3, $t6# in process_expression: baseRes_ := temp1
sw $t3, -108($fp)
lw $t3, -108($fp)
move $v0, $t3# RETURN baseRes_: 设置返回值
lw $t9, -80($fp)# RETURN baseRes_: 恢复寄存器$t9
lw $t8, -76($fp)# RETURN baseRes_: 恢复寄存器$t8
lw $s7, -72($fp)# RETURN baseRes_: 恢复寄存器$s7
lw $s6, -68($fp)# RETURN baseRes_: 恢复寄存器$s6
lw $s5, -64($fp)# RETURN baseRes_: 恢复寄存器$s5
lw $s4, -60($fp)# RETURN baseRes_: 恢复寄存器$s4
lw $s3, -56($fp)# RETURN baseRes_: 恢复寄存器$s3
lw $s2, -52($fp)# RETURN baseRes_: 恢复寄存器$s2
lw $s1, -48($fp)# RETURN baseRes_: 恢复寄存器$s1
lw $s0, -44($fp)# RETURN baseRes_: 恢复寄存器$s0
lw $t7, -40($fp)# RETURN baseRes_: 恢复寄存器$t7
lw $t6, -36($fp)# RETURN baseRes_: 恢复寄存器$t6
lw $t5, -32($fp)# RETURN baseRes_: 恢复寄存器$t5
lw $t4, -28($fp)# RETURN baseRes_: 恢复寄存器$t4
lw $t3, -24($fp)# RETURN baseRes_: 恢复寄存器$t3
lw $t2, -20($fp)# RETURN baseRes_: 恢复寄存器$t2
lw $t1, -16($fp)# RETURN baseRes_: 恢复寄存器$t1
lw $t0, -12($fp)# RETURN baseRes_: 恢复寄存器$t0
lw $ra, -8($fp)# RETURN baseRes_: 恢复返回地址
lw $fp, -4($fp)# RETURN baseRes_: 恢复帧指针
addi $sp, $sp, 80
jr $ra

label2 :
determineIndex:
subu $sp, $sp, 80# FUNCTION determineIndex: 分配栈帧
sw $fp, 76($sp)# FUNCTION determineIndex: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION determineIndex: 保存返回地址
addiu $fp, $sp, 80# FUNCTION determineIndex: 设置新的帧指针
sw $t0, -12($fp)# FUNCTION determineIndex: 保存寄存器 $t0
sw $t1, -16($fp)# FUNCTION determineIndex: 保存寄存器 $t1
sw $t2, -20($fp)# FUNCTION determineIndex: 保存寄存器 $t2
sw $t3, -24($fp)# FUNCTION determineIndex: 保存寄存器 $t3
sw $t4, -28($fp)# FUNCTION determineIndex: 保存寄存器 $t4
sw $t5, -32($fp)# FUNCTION determineIndex: 保存寄存器 $t5
sw $t6, -36($fp)# FUNCTION determineIndex: 保存寄存器 $t6
sw $t7, -40($fp)# FUNCTION determineIndex: 保存寄存器 $t7
sw $s0, -44($fp)# FUNCTION determineIndex: 保存寄存器 $s0
sw $s1, -48($fp)# FUNCTION determineIndex: 保存寄存器 $s1
sw $s2, -52($fp)# FUNCTION determineIndex: 保存寄存器 $s2
sw $s3, -56($fp)# FUNCTION determineIndex: 保存寄存器 $s3
sw $s4, -60($fp)# FUNCTION determineIndex: 保存寄存器 $s4
sw $s5, -64($fp)# FUNCTION determineIndex: 保存寄存器 $s5
sw $s6, -68($fp)# FUNCTION determineIndex: 保存寄存器 $s6
sw $s7, -72($fp)# FUNCTION determineIndex: 保存寄存器 $s7
sw $t8, -76($fp)# FUNCTION determineIndex: 保存寄存器 $t8
sw $t9, -80($fp)# FUNCTION determineIndex: 保存寄存器 $t9
lw $t7, -4($fp)# PARAM baseIn_: 读取第2个参数
lw $s0, -8($fp)# PARAM inputOther_: 读取第3个参数
add $s1, $t7, $s0# in handle_binary_op: temp2 := baseIn_ + inputOther_
sw $s1, -124($fp)
lw $s1, -124($fp)
li $s2, 5
div $s1, $s2
mflo $s3# in handle_binary_op: temp3 := temp2 / #5 (get quotient)
sw $s3, -128($fp)
lw $s4, -128($fp)
move $s3, $s4# in process_expression: indexRes_ := temp3
sw $s3, -132($fp)
lw $s3, -132($fp)
li $s5, 0
blt $s3, $s5, label3
j label4# GOTO label4
label3 :
li $s6, 0
move $v0, $s6# RETURN #0: 设置返回值
lw $t9, -80($fp)# RETURN #0: 恢复寄存器$t9
lw $t8, -76($fp)# RETURN #0: 恢复寄存器$t8
lw $s7, -72($fp)# RETURN #0: 恢复寄存器$s7
lw $s6, -68($fp)# RETURN #0: 恢复寄存器$s6
lw $s5, -64($fp)# RETURN #0: 恢复寄存器$s5
lw $s4, -60($fp)# RETURN #0: 恢复寄存器$s4
lw $s3, -56($fp)# RETURN #0: 恢复寄存器$s3
lw $s2, -52($fp)# RETURN #0: 恢复寄存器$s2
lw $s1, -48($fp)# RETURN #0: 恢复寄存器$s1
lw $s0, -44($fp)# RETURN #0: 恢复寄存器$s0
lw $t7, -40($fp)# RETURN #0: 恢复寄存器$t7
lw $t6, -36($fp)# RETURN #0: 恢复寄存器$t6
lw $t5, -32($fp)# RETURN #0: 恢复寄存器$t5
lw $t4, -28($fp)# RETURN #0: 恢复寄存器$t4
lw $t3, -24($fp)# RETURN #0: 恢复寄存器$t3
lw $t2, -20($fp)# RETURN #0: 恢复寄存器$t2
lw $t1, -16($fp)# RETURN #0: 恢复寄存器$t1
lw $t0, -12($fp)# RETURN #0: 恢复寄存器$t0
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

label4 :
li $s7, 4
bgt $s3, $s7, label5
j label6# GOTO label6
label5 :
li $t8, 4
move $v0, $t8# RETURN #4: 设置返回值
lw $t9, -80($fp)# RETURN #4: 恢复寄存器$t9
lw $t8, -76($fp)# RETURN #4: 恢复寄存器$t8
lw $s7, -72($fp)# RETURN #4: 恢复寄存器$s7
lw $s6, -68($fp)# RETURN #4: 恢复寄存器$s6
lw $s5, -64($fp)# RETURN #4: 恢复寄存器$s5
lw $s4, -60($fp)# RETURN #4: 恢复寄存器$s4
lw $s3, -56($fp)# RETURN #4: 恢复寄存器$s3
lw $s2, -52($fp)# RETURN #4: 恢复寄存器$s2
lw $s1, -48($fp)# RETURN #4: 恢复寄存器$s1
lw $s0, -44($fp)# RETURN #4: 恢复寄存器$s0
lw $t7, -40($fp)# RETURN #4: 恢复寄存器$t7
lw $t6, -36($fp)# RETURN #4: 恢复寄存器$t6
lw $t5, -32($fp)# RETURN #4: 恢复寄存器$t5
lw $t4, -28($fp)# RETURN #4: 恢复寄存器$t4
lw $t3, -24($fp)# RETURN #4: 恢复寄存器$t3
lw $t2, -20($fp)# RETURN #4: 恢复寄存器$t2
lw $t1, -16($fp)# RETURN #4: 恢复寄存器$t1
lw $t0, -12($fp)# RETURN #4: 恢复寄存器$t0
lw $ra, -8($fp)# RETURN #4: 恢复返回地址
lw $fp, -4($fp)# RETURN #4: 恢复帧指针
addi $sp, $sp, 80
jr $ra

label6 :
move $v0, $s3# RETURN indexRes_: 设置返回值
lw $t9, -80($fp)# RETURN indexRes_: 恢复寄存器$t9
lw $t8, -76($fp)# RETURN indexRes_: 恢复寄存器$t8
lw $s7, -72($fp)# RETURN indexRes_: 恢复寄存器$s7
lw $s6, -68($fp)# RETURN indexRes_: 恢复寄存器$s6
lw $s5, -64($fp)# RETURN indexRes_: 恢复寄存器$s5
lw $s4, -60($fp)# RETURN indexRes_: 恢复寄存器$s4
lw $s3, -56($fp)# RETURN indexRes_: 恢复寄存器$s3
lw $s2, -52($fp)# RETURN indexRes_: 恢复寄存器$s2
lw $s1, -48($fp)# RETURN indexRes_: 恢复寄存器$s1
lw $s0, -44($fp)# RETURN indexRes_: 恢复寄存器$s0
lw $t7, -40($fp)# RETURN indexRes_: 恢复寄存器$t7
lw $t6, -36($fp)# RETURN indexRes_: 恢复寄存器$t6
lw $t5, -32($fp)# RETURN indexRes_: 恢复寄存器$t5
lw $t4, -28($fp)# RETURN indexRes_: 恢复寄存器$t4
lw $t3, -24($fp)# RETURN indexRes_: 恢复寄存器$t3
lw $t2, -20($fp)# RETURN indexRes_: 恢复寄存器$t2
lw $t1, -16($fp)# RETURN indexRes_: 恢复寄存器$t1
lw $t0, -12($fp)# RETURN indexRes_: 恢复寄存器$t0
lw $ra, -8($fp)# RETURN indexRes_: 恢复返回地址
lw $fp, -4($fp)# RETURN indexRes_: 恢复帧指针
addi $sp, $sp, 80
jr $ra

main:
subu $sp, $sp, 80# FUNCTION main: 分配栈帧
sw $fp, 76($sp)# FUNCTION main: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION main: 保存返回地址
addiu $fp, $sp, 80# FUNCTION main: 设置新的帧指针
addi $t1, $fp, -136
move $t9, $t1# in process_expression: temp4 := &dataArray_
sw $t9, -296($fp)
li $t9, 0
li $t2, 4
sw $t4, -104($fp)
mul $t4, $t9, $t2# in handle_binary_op: temp5 := #0 * #4
sw $t4, -300($fp)
lw $t4, -300($fp)
sw $t0, -100($fp)
lw $t0, -296($fp)
add $t5, $t4, $t0# in handle_binary_op: temp6 := temp5 + temp4
sw $t5, -304($fp)
lw $t5, -304($fp)
sw $t6, -112($fp)
li $t6, 1
sw $t6, 0($t5)# in process_expression: *temp6 = #1
sw $t5, -304($fp)
move $t5, $t1# in process_expression: temp7 := &dataArray_
sw $t5, -308($fp)
li $t5, 1
sw $t3, -108($fp)
li $t3, 4
sw $t7, -116($fp)
mul $t7, $t5, $t3# in handle_binary_op: temp8 := #1 * #4
sw $t7, -312($fp)
lw $t7, -312($fp)
sw $s0, -120($fp)
lw $s0, -308($fp)
sw $s1, -124($fp)
add $s1, $t7, $s0# in handle_binary_op: temp9 := temp8 + temp7
sw $s1, -316($fp)
lw $s1, -316($fp)
li $s2, 2
sw $s2, 0($s1)# in process_expression: *temp9 = #2
sw $s1, -316($fp)
move $s1, $t1# in process_expression: temp10 := &dataArray_
sw $s1, -320($fp)
li $s1, 2
sw $s4, -128($fp)
li $s4, 4
mul $s5, $s1, $s4# in handle_binary_op: temp11 := #2 * #4
sw $s5, -324($fp)
lw $s5, -324($fp)
lw $s6, -320($fp)
add $s7, $s5, $s6# in handle_binary_op: temp12 := temp11 + temp10
sw $s7, -328($fp)
lw $s7, -328($fp)
li $t8, 3
sw $t8, 0($s7)# in process_expression: *temp12 = #3
sw $s7, -328($fp)
move $s7, $t1# in process_expression: temp13 := &dataArray_
sw $s7, -332($fp)
li $s7, 3
sw $s3, -132($fp)
li $s3, 4
mul $t9, $s7, $s3# in handle_binary_op: temp14 := #3 * #4
sw $t9, -336($fp)
lw $t9, -336($fp)
lw $t2, -332($fp)
sw $t4, -300($fp)
add $t4, $t9, $t2# in handle_binary_op: temp15 := temp14 + temp13
sw $t4, -340($fp)
lw $t4, -340($fp)
sw $t0, -296($fp)
li $t0, 4
sw $t0, 0($t4)# in process_expression: *temp15 = #4
sw $t4, -340($fp)
move $t4, $t1# in process_expression: temp16 := &dataArray_
sw $t4, -344($fp)
li $t4, 4
li $t6, 4
mul $t5, $t4, $t6# in handle_binary_op: temp17 := #4 * #4
sw $t5, -348($fp)
lw $t5, -348($fp)
lw $t3, -344($fp)
sw $t7, -312($fp)
add $t7, $t5, $t3# in handle_binary_op: temp18 := temp17 + temp16
sw $t7, -352($fp)
lw $t7, -352($fp)
sw $s0, -308($fp)
li $s0, 5
sw $s0, 0($t7)# in process_expression: *temp18 = #5
sw $t7, -352($fp)
addi $sp, $sp, -4# READ temp19: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp19: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp19: 恢复返回地址
move $t7, $v0# READ temp19: 将返回值存储到temp19
move $s2, $t7# in process_expression: val1_ := temp19
sw $s2, -360($fp)
addi $sp, $sp, -4# READ temp20: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp20: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp20: 恢复返回地址
move $s2, $v0# READ temp20: 将返回值存储到temp20
move $s1, $s2# in process_expression: val2_ := temp20
sw $s1, -368($fp)
lw $s1, -360($fp)
subu $sp, $sp, 4# ARG val1_: 压栈参数
sw $s1, 0($sp)
jal calculateBase# CALL calculateBase: 调用函数
move $s4, $v0# CALL calculateBase: 保存返回值
sw $s5, -324($fp)
move $s5, $s4# in process_expression: baseOut_ := temp21
sw $s5, -376($fp)
lw $s5, -368($fp)
subu $sp, $sp, 4# ARG val2_: 压栈参数
sw $s5, 0($sp)
sw $s6, -320($fp)
lw $s6, -376($fp)
subu $sp, $sp, 4# ARG baseOut_: 压栈参数
sw $s6, 0($sp)
jal determineIndex# CALL determineIndex: 调用函数
move $t8, $v0# CALL determineIndex: 保存返回值
move $s7, $t8# in process_expression: targetIdx_ := temp22
sw $s7, -384($fp)
move $s7, $t1# in process_expression: temp23 := &dataArray_
sw $s7, -388($fp)
lw $s7, -384($fp)
li $s3, 4
sw $t9, -336($fp)
mul $t9, $s7, $s3# in handle_binary_op: temp24 := targetIdx_ * #4
sw $t9, -392($fp)
lw $t9, -392($fp)
sw $t2, -332($fp)
lw $t2, -388($fp)
add $t0, $t9, $t2# in handle_binary_op: temp25 := temp24 + temp23
sw $t0, -396($fp)
lw $t0, -396($fp)
lw $t4, 0($t0)# in process_expression: temp26 := *temp25
sw $t4, -400($fp)
lw $t6, -400($fp)
move $t4, $t6# in process_expression: originalVal_ := temp26
sw $t4, -404($fp)
li $t4, 30
bgt $s6, $t4, label10
j label8# GOTO label8
label10 :
sw $t5, -348($fp)
li $t5, 0
bgt $s5, $t5, label7
j label8# GOTO label8
label7 :
sw $t3, -344($fp)
move $t3, $t1# in process_expression: temp27 := &dataArray_
sw $t3, -408($fp)
li $t3, 4
mul $s0, $s7, $t3# in handle_binary_op: temp28 := targetIdx_ * #4
sw $s0, -412($fp)
lw $s0, -412($fp)
sw $t7, -356($fp)
lw $t7, -408($fp)
sw $s2, -364($fp)
add $s2, $s0, $t7# in handle_binary_op: temp29 := temp28 + temp27
sw $s2, -416($fp)
lw $s2, -416($fp)
sw $s6, 0($s2)# in process_expression: *temp29 = baseOut_
sw $s2, -416($fp)
j label9# GOTO label9
label8 :
move $s2, $t1# in process_expression: temp30 := &dataArray_
sw $s2, -420($fp)
li $s2, 4
sw $s1, -360($fp)
mul $s1, $s7, $s2# in handle_binary_op: temp31 := targetIdx_ * #4
sw $s1, -424($fp)
lw $s1, -424($fp)
sw $s4, -372($fp)
lw $s4, -420($fp)
sw $t8, -380($fp)
add $t8, $s1, $s4# in handle_binary_op: temp32 := temp31 + temp30
sw $t8, -428($fp)
lw $t8, -404($fp)
li $s3, 2
sw $t9, -392($fp)
mul $t9, $t8, $s3# in handle_binary_op: temp33 := originalVal_ * #2
sw $t9, -432($fp)
lw $t9, -428($fp)
sw $t2, -388($fp)
lw $t2, -432($fp)
sw $t2, 0($t9)# in process_expression: *temp32 = temp33
sw $t9, -428($fp)
label9 :
move $t9, $t1# in process_expression: temp34 := &dataArray_
sw $t9, -436($fp)
li $t9, 4
sw $t0, -396($fp)
mul $t0, $s7, $t9# in handle_binary_op: temp35 := targetIdx_ * #4
sw $t0, -440($fp)
lw $t0, -440($fp)
sw $t6, -400($fp)
lw $t6, -436($fp)
add $t4, $t0, $t6# in handle_binary_op: temp36 := temp35 + temp34
sw $t4, -444($fp)
lw $t4, -444($fp)
sw $s5, -368($fp)
lw $s5, 0($t4)# in process_expression: temp37 := *temp36
sw $s5, -448($fp)
lw $t5, -448($fp)
move $s5, $t5# in process_expression: modifiedVal_ := temp37
sw $s5, -452($fp)
move $a0, $s7# WRITE targetIdx_: 将值移动到$a0
subu $sp, $sp, 4# WRITE targetIdx_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE targetIdx_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE targetIdx_: 恢复返回地址
move $a0, $t8# WRITE originalVal_: 将值移动到$a0
subu $sp, $sp, 4# WRITE originalVal_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE originalVal_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE originalVal_: 恢复返回地址
lw $s5, -452($fp)
move $a0, $s5# WRITE modifiedVal_: 将值移动到$a0
subu $sp, $sp, 4# WRITE modifiedVal_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE modifiedVal_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE modifiedVal_: 恢复返回地址
li $t3, 0
move $v0, $t3# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

