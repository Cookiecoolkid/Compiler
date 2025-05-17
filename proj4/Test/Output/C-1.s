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

calculateInnerLoopLimit:
subu $sp, $sp, 80# FUNCTION calculateInnerLoopLimit: 分配栈帧
sw $fp, 76($sp)# FUNCTION calculateInnerLoopLimit: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION calculateInnerLoopLimit: 保存返回地址
addiu $fp, $sp, 80# FUNCTION calculateInnerLoopLimit: 设置新的帧指针
sw $t0, -12($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $t0
sw $t1, -16($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $t1
sw $t2, -20($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $t2
sw $t3, -24($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $t3
sw $t4, -28($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $t4
sw $t5, -32($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $t5
sw $t6, -36($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $t6
sw $t7, -40($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $t7
sw $s0, -44($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $s0
sw $s1, -48($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $s1
sw $s2, -52($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $s2
sw $s3, -56($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $s3
sw $s4, -60($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $s4
sw $s5, -64($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $s5
sw $s6, -68($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $s6
sw $s7, -72($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $s7
sw $t8, -76($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $t8
sw $t9, -80($fp)# FUNCTION calculateInnerLoopLimit: 保存寄存器 $t9
lw $t0, 0($fp)# PARAM totalSize_: 读取第1个参数
lw $t1, -4($fp)# PARAM outerLoopIndex_: 读取第2个参数
sub $t2, $t0, $t1# in handle_binary_op: temp0 := totalSize_ - outerLoopIndex_
sw $t2, -88($fp)
lw $t2, -88($fp)
li $t3, 1
sub $t4, $t2, $t3# in handle_binary_op: temp1 := temp0 - #1
sw $t4, -92($fp)
lw $t5, -92($fp)
move $t4, $t5# in process_expression: limitResult_ := temp1
move $v0, $t4# RETURN limitResult_: 设置返回值
lw $t9, -80($fp)# RETURN limitResult_: 恢复寄存器$t9
lw $t8, -76($fp)# RETURN limitResult_: 恢复寄存器$t8
lw $s7, -72($fp)# RETURN limitResult_: 恢复寄存器$s7
lw $s6, -68($fp)# RETURN limitResult_: 恢复寄存器$s6
lw $s5, -64($fp)# RETURN limitResult_: 恢复寄存器$s5
lw $s4, -60($fp)# RETURN limitResult_: 恢复寄存器$s4
lw $s3, -56($fp)# RETURN limitResult_: 恢复寄存器$s3
lw $s2, -52($fp)# RETURN limitResult_: 恢复寄存器$s2
lw $s1, -48($fp)# RETURN limitResult_: 恢复寄存器$s1
lw $s0, -44($fp)# RETURN limitResult_: 恢复寄存器$s0
lw $t7, -40($fp)# RETURN limitResult_: 恢复寄存器$t7
lw $t6, -36($fp)# RETURN limitResult_: 恢复寄存器$t6
lw $t5, -32($fp)# RETURN limitResult_: 恢复寄存器$t5
lw $t4, -28($fp)# RETURN limitResult_: 恢复寄存器$t4
lw $t3, -24($fp)# RETURN limitResult_: 恢复寄存器$t3
lw $t2, -20($fp)# RETURN limitResult_: 恢复寄存器$t2
lw $t1, -16($fp)# RETURN limitResult_: 恢复寄存器$t1
lw $t0, -12($fp)# RETURN limitResult_: 恢复寄存器$t0
lw $ra, -8($fp)# RETURN limitResult_: 恢复返回地址
lw $fp, -4($fp)# RETURN limitResult_: 恢复帧指针
addi $sp, $sp, 80
jr $ra

main:
subu $sp, $sp, 80# FUNCTION main: 分配栈帧
sw $fp, 76($sp)# FUNCTION main: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION main: 保存返回地址
addiu $fp, $sp, 80# FUNCTION main: 设置新的帧指针
li $t6, 5# in process_expression: arrayDataSize_ := #5
li $t7, 0# in process_expression: outerIdx_ := #0
li $t7, 0# in process_expression: innerIdx_ := #0
label0 :
blt $s0, $s1, label1
j label2# GOTO label2
label1 :
addi $s3, $fp, -100
move $s2, $s3# in process_expression: temp2 := &sortArrayData_
li $s4, 4
mul $s5, $s0, $s4# in handle_binary_op: temp3 := outerIdx_ * #4
sw $s5, -280($fp)
lw $s5, -280($fp)
add $s6, $s5, $s2# in handle_binary_op: temp4 := temp3 + temp2
sw $s6, -284($fp)
addi $sp, $sp, -4# READ temp5: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp5: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp5: 恢复返回地址
move $s6, $v0# READ temp5: 将返回值存储到temp5
lw $s7, -284($fp)
sw $s6, 0($s7)# in process_expression: *temp4 = temp5
li $t8, 1
add $t9, $s0, $t8# in handle_binary_op: temp6 := outerIdx_ + #1
sw $t9, -292($fp)
lw $t9, -292($fp)
move $s0, $t9# in process_expression: outerIdx_ := temp6
j label0# GOTO label0
label2 :
li $t7, 0# in process_expression: outerIdx_ := #0
sw $t0, -80($fp)
li $t0, 1
sw $t1, -84($fp)
sub $t1, $s1, $t0# in handle_binary_op: temp7 := arrayDataSize_ - #1
sw $t1, -296($fp)
sw $t2, -88($fp)
lw $t2, -296($fp)
move $t1, $t2# in process_expression: outerLimit_ := temp7
label3 :
blt $s0, $t1, label4
j label5# GOTO label5
label4 :
li $t7, 0# in process_expression: innerIdx_ := #0
subu $sp, $sp, 4# ARG outerIdx_: 压栈参数
sw $s0, 0($sp)
subu $sp, $sp, 4# ARG arrayDataSize_: 压栈参数
sw $s1, 0($sp)
jal calculateInnerLoopLimit# CALL calculateInnerLoopLimit: 调用函数
move $t3, $v0# CALL calculateInnerLoopLimit: 保存返回值
sw $t5, -92($fp)
move $t5, $t3# in process_expression: innerLimit_ := temp8
label6 :
sw $t4, -96($fp)
blt $t4, $t5, label7
j label8# GOTO label8
label7 :
sw $t6, -260($fp)
move $t6, $s3# in process_expression: temp9 := &sortArrayData_
li $s4, 4
sw $s5, -280($fp)
mul $s5, $t4, $s4# in handle_binary_op: temp10 := innerIdx_ * #4
sw $s5, -320($fp)
lw $s5, -320($fp)
sw $s2, -276($fp)
add $s2, $s5, $t6# in handle_binary_op: temp11 := temp10 + temp9
sw $s2, -324($fp)
lw $s2, -324($fp)
sw $s7, -284($fp)
lw $s7, 0($s2)# in process_expression: temp12 := *temp11
sw $s6, -288($fp)
move $s6, $s3# in process_expression: temp13 := &sortArrayData_
li $t8, 1
sw $t9, -292($fp)
add $t9, $t4, $t8# in handle_binary_op: temp14 := innerIdx_ + #1
sw $t9, -336($fp)
lw $t9, -336($fp)
li $t0, 4
sw $t2, -296($fp)
mul $t2, $t9, $t0# in handle_binary_op: temp15 := temp14 * #4
sw $t2, -340($fp)
lw $t2, -340($fp)
sw $t1, -300($fp)
add $t1, $t2, $s6# in handle_binary_op: temp16 := temp15 + temp13
sw $t1, -344($fp)
lw $t1, -344($fp)
sw $t7, -264($fp)
lw $t7, 0($t1)# in process_expression: temp17 := *temp16
bgt $s7, $t7, label9
j label10# GOTO label10
label9 :
sw $s0, -268($fp)
move $s0, $s3# in process_expression: temp18 := &sortArrayData_
sw $s1, -272($fp)
li $s1, 4
sw $t3, -304($fp)
mul $t3, $t4, $s1# in handle_binary_op: temp19 := innerIdx_ * #4
sw $t3, -356($fp)
lw $t3, -356($fp)
sw $t5, -308($fp)
add $t5, $t3, $s0# in handle_binary_op: temp20 := temp19 + temp18
sw $t5, -360($fp)
lw $t5, -360($fp)
lw $s4, 0($t5)# in process_expression: temp21 := *temp20
sw $s5, -320($fp)
move $s5, $s4# in process_expression: swapHolder_ := temp21
sw $t6, -316($fp)
move $t6, $s3# in process_expression: temp22 := &sortArrayData_
sw $s2, -324($fp)
li $s2, 4
mul $t8, $t4, $s2# in handle_binary_op: temp23 := innerIdx_ * #4
sw $t8, -376($fp)
lw $t8, -376($fp)
sw $t9, -336($fp)
add $t9, $t8, $t6# in handle_binary_op: temp24 := temp23 + temp22
sw $t9, -380($fp)
move $t9, $s3# in process_expression: temp25 := &sortArrayData_
li $t0, 1
sw $t2, -340($fp)
add $t2, $t4, $t0# in handle_binary_op: temp26 := innerIdx_ + #1
sw $t2, -388($fp)
lw $t2, -388($fp)
sw $s6, -332($fp)
li $s6, 4
sw $t1, -344($fp)
mul $t1, $t2, $s6# in handle_binary_op: temp27 := temp26 * #4
sw $t1, -392($fp)
lw $t1, -392($fp)
sw $s7, -328($fp)
add $s7, $t1, $t9# in handle_binary_op: temp28 := temp27 + temp25
sw $s7, -396($fp)
lw $s7, -396($fp)
sw $t7, -348($fp)
lw $t7, 0($s7)# in process_expression: temp29 := *temp28
lw $s1, -380($fp)
sw $t7, 0($s1)# in process_expression: *temp24 = temp29
sw $t3, -356($fp)
move $t3, $s3# in process_expression: temp30 := &sortArrayData_
sw $s0, -352($fp)
li $s0, 1
sw $t5, -360($fp)
add $t5, $t4, $s0# in handle_binary_op: temp31 := innerIdx_ + #1
sw $t5, -408($fp)
lw $t5, -408($fp)
sw $s5, -368($fp)
li $s5, 4
sw $s4, -364($fp)
mul $s4, $t5, $s5# in handle_binary_op: temp32 := temp31 * #4
sw $s4, -412($fp)
lw $s4, -412($fp)
add $s2, $s4, $t3# in handle_binary_op: temp33 := temp32 + temp30
sw $s2, -416($fp)
lw $s2, -416($fp)
sw $t8, -376($fp)
lw $t8, -368($fp)
sw $t8, 0($s2)# in process_expression: *temp33 = swapHolder_
label10 :
sw $t6, -372($fp)
li $t6, 1
add $t0, $t4, $t6# in handle_binary_op: temp34 := innerIdx_ + #1
sw $t0, -420($fp)
lw $t0, -420($fp)
move $t4, $t0# in process_expression: innerIdx_ := temp34
j label6# GOTO label6
label8 :
sw $t2, -388($fp)
lw $t2, -268($fp)
li $s6, 1
sw $t1, -392($fp)
add $t1, $t2, $s6# in handle_binary_op: temp35 := outerIdx_ + #1
sw $t1, -424($fp)
lw $t1, -424($fp)
move $t2, $t1# in process_expression: outerIdx_ := temp35
j label3# GOTO label3
label5 :
sw $t9, -384($fp)
lw $t9, -264($fp)
li $t9, 0# in process_expression: outerIdx_ := #0
label11 :
sw $s7, -396($fp)
lw $s7, -272($fp)
blt $t2, $s7, label12
j label13# GOTO label13
label12 :
sw $s1, -380($fp)
move $s1, $s3# in process_expression: temp36 := &sortArrayData_
sw $t7, -400($fp)
li $t7, 4
mul $s0, $t2, $t7# in handle_binary_op: temp37 := outerIdx_ * #4
sw $s0, -432($fp)
lw $s0, -432($fp)
sw $t5, -408($fp)
add $t5, $s0, $s1# in handle_binary_op: temp38 := temp37 + temp36
sw $t5, -436($fp)
lw $t5, -436($fp)
lw $s5, 0($t5)# in process_expression: temp39 := *temp38
move $a0, $s5# WRITE temp39: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp39: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp39: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp39: 恢复返回地址
sw $s4, -412($fp)
li $s4, 1
sw $t3, -404($fp)
add $t3, $t2, $s4# in handle_binary_op: temp40 := outerIdx_ + #1
sw $t3, -444($fp)
lw $t3, -444($fp)
move $t2, $t3# in process_expression: outerIdx_ := temp40
j label11# GOTO label11
label13 :
sw $s2, -416($fp)
li $s2, 0
move $v0, $s2# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

