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

getNextValue:
subu $sp, $sp, 80# FUNCTION getNextValue: 分配栈帧
sw $fp, 76($sp)# FUNCTION getNextValue: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION getNextValue: 保存返回地址
addiu $fp, $sp, 80# FUNCTION getNextValue: 设置新的帧指针
sw $t0, -12($fp)# FUNCTION getNextValue: 保存寄存器 $t0
sw $t1, -16($fp)# FUNCTION getNextValue: 保存寄存器 $t1
sw $t2, -20($fp)# FUNCTION getNextValue: 保存寄存器 $t2
sw $t3, -24($fp)# FUNCTION getNextValue: 保存寄存器 $t3
sw $t4, -28($fp)# FUNCTION getNextValue: 保存寄存器 $t4
sw $t5, -32($fp)# FUNCTION getNextValue: 保存寄存器 $t5
sw $t6, -36($fp)# FUNCTION getNextValue: 保存寄存器 $t6
sw $t7, -40($fp)# FUNCTION getNextValue: 保存寄存器 $t7
sw $s0, -44($fp)# FUNCTION getNextValue: 保存寄存器 $s0
sw $s1, -48($fp)# FUNCTION getNextValue: 保存寄存器 $s1
sw $s2, -52($fp)# FUNCTION getNextValue: 保存寄存器 $s2
sw $s3, -56($fp)# FUNCTION getNextValue: 保存寄存器 $s3
sw $s4, -60($fp)# FUNCTION getNextValue: 保存寄存器 $s4
sw $s5, -64($fp)# FUNCTION getNextValue: 保存寄存器 $s5
sw $s6, -68($fp)# FUNCTION getNextValue: 保存寄存器 $s6
sw $s7, -72($fp)# FUNCTION getNextValue: 保存寄存器 $s7
sw $t8, -76($fp)# FUNCTION getNextValue: 保存寄存器 $t8
sw $t9, -80($fp)# FUNCTION getNextValue: 保存寄存器 $t9
lw $t0, 0($fp)# PARAM idxParam_: 读取第1个参数
lw $t1, -4($fp)# PARAM oldValParam_: 读取第2个参数
lw $t2, -8($fp)# PARAM modParam_: 读取第3个参数
li $t3, 2
div $t0, $t3
mflo $t4# in handle_binary_op: temp0 := idxParam_ / #2 (get quotient)
sw $t4, -112($fp)
lw $t4, -112($fp)
li $t5, 2
mul $t6, $t4, $t5# in handle_binary_op: temp1 := temp0 * #2
sw $t6, -116($fp)
lw $t6, -116($fp)
beq $t6, $t0, label0
j label1# GOTO label1
label0 :
li $t7, 5
add $s0, $t0, $t7# in handle_binary_op: temp2 := idxParam_ + #5
sw $s0, -120($fp)
lw $s1, -120($fp)
move $s0, $s1# in process_expression: valueModifier_ := temp2
sw $s0, -124($fp)
j label2# GOTO label2
label1 :
li $s0, 3
mul $s2, $t0, $s0# in handle_binary_op: temp3 := idxParam_ * #3
sw $s2, -128($fp)
lw $s2, -124($fp)
lw $s3, -128($fp)
move $s2, $s3# in process_expression: valueModifier_ := temp3
sw $s2, -124($fp)
label2 :
lw $s2, -124($fp)
add $s4, $t1, $s2# in handle_binary_op: temp4 := oldValParam_ + valueModifier_
sw $s4, -132($fp)
lw $s4, -132($fp)
move $v0, $s4# RETURN temp4: 设置返回值
lw $t9, -80($fp)# RETURN temp4: 恢复寄存器$t9
lw $t8, -76($fp)# RETURN temp4: 恢复寄存器$t8
lw $s7, -72($fp)# RETURN temp4: 恢复寄存器$s7
lw $s6, -68($fp)# RETURN temp4: 恢复寄存器$s6
lw $s5, -64($fp)# RETURN temp4: 恢复寄存器$s5
lw $s4, -60($fp)# RETURN temp4: 恢复寄存器$s4
lw $s3, -56($fp)# RETURN temp4: 恢复寄存器$s3
lw $s2, -52($fp)# RETURN temp4: 恢复寄存器$s2
lw $s1, -48($fp)# RETURN temp4: 恢复寄存器$s1
lw $s0, -44($fp)# RETURN temp4: 恢复寄存器$s0
lw $t7, -40($fp)# RETURN temp4: 恢复寄存器$t7
lw $t6, -36($fp)# RETURN temp4: 恢复寄存器$t6
lw $t5, -32($fp)# RETURN temp4: 恢复寄存器$t5
lw $t4, -28($fp)# RETURN temp4: 恢复寄存器$t4
lw $t3, -24($fp)# RETURN temp4: 恢复寄存器$t3
lw $t2, -20($fp)# RETURN temp4: 恢复寄存器$t2
lw $t1, -16($fp)# RETURN temp4: 恢复寄存器$t1
lw $t0, -12($fp)# RETURN temp4: 恢复寄存器$t0
lw $ra, -8($fp)# RETURN temp4: 恢复返回地址
lw $fp, -4($fp)# RETURN temp4: 恢复帧指针
addi $sp, $sp, 80
jr $ra

checkComplexCondition:
subu $sp, $sp, 80# FUNCTION checkComplexCondition: 分配栈帧
sw $fp, 76($sp)# FUNCTION checkComplexCondition: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION checkComplexCondition: 保存返回地址
addiu $fp, $sp, 80# FUNCTION checkComplexCondition: 设置新的帧指针
sw $t0, -12($fp)# FUNCTION checkComplexCondition: 保存寄存器 $t0
sw $t1, -16($fp)# FUNCTION checkComplexCondition: 保存寄存器 $t1
sw $t2, -20($fp)# FUNCTION checkComplexCondition: 保存寄存器 $t2
sw $t3, -24($fp)# FUNCTION checkComplexCondition: 保存寄存器 $t3
sw $t4, -28($fp)# FUNCTION checkComplexCondition: 保存寄存器 $t4
sw $t5, -32($fp)# FUNCTION checkComplexCondition: 保存寄存器 $t5
sw $t6, -36($fp)# FUNCTION checkComplexCondition: 保存寄存器 $t6
sw $t7, -40($fp)# FUNCTION checkComplexCondition: 保存寄存器 $t7
sw $s0, -44($fp)# FUNCTION checkComplexCondition: 保存寄存器 $s0
sw $s1, -48($fp)# FUNCTION checkComplexCondition: 保存寄存器 $s1
sw $s2, -52($fp)# FUNCTION checkComplexCondition: 保存寄存器 $s2
sw $s3, -56($fp)# FUNCTION checkComplexCondition: 保存寄存器 $s3
sw $s4, -60($fp)# FUNCTION checkComplexCondition: 保存寄存器 $s4
sw $s5, -64($fp)# FUNCTION checkComplexCondition: 保存寄存器 $s5
sw $s6, -68($fp)# FUNCTION checkComplexCondition: 保存寄存器 $s6
sw $s7, -72($fp)# FUNCTION checkComplexCondition: 保存寄存器 $s7
sw $t8, -76($fp)# FUNCTION checkComplexCondition: 保存寄存器 $t8
sw $t9, -80($fp)# FUNCTION checkComplexCondition: 保存寄存器 $t9
lw $s5, -12($fp)# PARAM valueToCheck_: 读取第4个参数
lw $s6, -16($fp)# PARAM checkThresholdParam_: 读取第5个参数
li $s7, 50
bgt $s5, $s7, label5
j label4# GOTO label4
label5 :
li $t8, 5
blt $s6, $t8, label3
j label4# GOTO label4
label3 :
li $t9, 1
move $v0, $t9# RETURN #1: 设置返回值
lw $t9, -80($fp)# RETURN #1: 恢复寄存器$t9
lw $t8, -76($fp)# RETURN #1: 恢复寄存器$t8
lw $s7, -72($fp)# RETURN #1: 恢复寄存器$s7
lw $s6, -68($fp)# RETURN #1: 恢复寄存器$s6
lw $s5, -64($fp)# RETURN #1: 恢复寄存器$s5
lw $s4, -60($fp)# RETURN #1: 恢复寄存器$s4
lw $s3, -56($fp)# RETURN #1: 恢复寄存器$s3
lw $s2, -52($fp)# RETURN #1: 恢复寄存器$s2
lw $s1, -48($fp)# RETURN #1: 恢复寄存器$s1
lw $s0, -44($fp)# RETURN #1: 恢复寄存器$s0
lw $t7, -40($fp)# RETURN #1: 恢复寄存器$t7
lw $t6, -36($fp)# RETURN #1: 恢复寄存器$t6
lw $t5, -32($fp)# RETURN #1: 恢复寄存器$t5
lw $t4, -28($fp)# RETURN #1: 恢复寄存器$t4
lw $t3, -24($fp)# RETURN #1: 恢复寄存器$t3
lw $t2, -20($fp)# RETURN #1: 恢复寄存器$t2
lw $t1, -16($fp)# RETURN #1: 恢复寄存器$t1
lw $t0, -12($fp)# RETURN #1: 恢复寄存器$t0
lw $ra, -8($fp)# RETURN #1: 恢复返回地址
lw $fp, -4($fp)# RETURN #1: 恢复帧指针
addi $sp, $sp, 80
jr $ra

label4 :
sw $t2, -108($fp)
li $t2, 10
blt $s5, $t2, label8
j label7# GOTO label7
label8 :
li $t3, 0
bgt $s6, $t3, label6
j label7# GOTO label7
label6 :
sw $t4, -112($fp)
li $t4, 1
move $v0, $t4# RETURN #1: 设置返回值
lw $t9, -80($fp)# RETURN #1: 恢复寄存器$t9
lw $t8, -76($fp)# RETURN #1: 恢复寄存器$t8
lw $s7, -72($fp)# RETURN #1: 恢复寄存器$s7
lw $s6, -68($fp)# RETURN #1: 恢复寄存器$s6
lw $s5, -64($fp)# RETURN #1: 恢复寄存器$s5
lw $s4, -60($fp)# RETURN #1: 恢复寄存器$s4
lw $s3, -56($fp)# RETURN #1: 恢复寄存器$s3
lw $s2, -52($fp)# RETURN #1: 恢复寄存器$s2
lw $s1, -48($fp)# RETURN #1: 恢复寄存器$s1
lw $s0, -44($fp)# RETURN #1: 恢复寄存器$s0
lw $t7, -40($fp)# RETURN #1: 恢复寄存器$t7
lw $t6, -36($fp)# RETURN #1: 恢复寄存器$t6
lw $t5, -32($fp)# RETURN #1: 恢复寄存器$t5
lw $t4, -28($fp)# RETURN #1: 恢复寄存器$t4
lw $t3, -24($fp)# RETURN #1: 恢复寄存器$t3
lw $t2, -20($fp)# RETURN #1: 恢复寄存器$t2
lw $t1, -16($fp)# RETURN #1: 恢复寄存器$t1
lw $t0, -12($fp)# RETURN #1: 恢复寄存器$t0
lw $ra, -8($fp)# RETURN #1: 恢复返回地址
lw $fp, -4($fp)# RETURN #1: 恢复帧指针
addi $sp, $sp, 80
jr $ra

label7 :
li $t5, 0
move $v0, $t5# RETURN #0: 设置返回值
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

main:
subu $sp, $sp, 80# FUNCTION main: 分配栈帧
sw $fp, 76($sp)# FUNCTION main: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION main: 保存返回地址
addiu $fp, $sp, 80# FUNCTION main: 设置新的帧指针
sw $t6, -116($fp)
li $t6, 0# in process_expression: loopCounter_ := #0
sw $t6, -304($fp)
li $t6, 0# in process_expression: conditionMetCounter_ := #0
sw $t6, -308($fp)
addi $t7, $fp, -144
move $t6, $t7# in process_expression: temp5 := &mainArray_
sw $t6, -312($fp)
li $t6, 0
sw $s1, -120($fp)
li $s1, 4
sw $t0, -100($fp)
mul $t0, $t6, $s1# in handle_binary_op: temp6 := #0 * #4
sw $t0, -316($fp)
lw $t0, -316($fp)
lw $s0, -312($fp)
sw $s3, -128($fp)
add $s3, $t0, $s0# in handle_binary_op: temp7 := temp6 + temp5
sw $s3, -320($fp)
lw $s3, -320($fp)
sw $t1, -104($fp)
li $t1, 5
sw $t1, 0($s3)# in process_expression: *temp7 = #5
sw $s3, -320($fp)
move $s3, $t7# in process_expression: temp8 := &mainArray_
sw $s3, -324($fp)
li $s3, 1
sw $s2, -124($fp)
li $s2, 4
sw $s4, -132($fp)
mul $s4, $s3, $s2# in handle_binary_op: temp9 := #1 * #4
sw $s4, -328($fp)
lw $s4, -328($fp)
lw $s7, -324($fp)
add $t8, $s4, $s7# in handle_binary_op: temp10 := temp9 + temp8
sw $t8, -332($fp)
lw $t8, -332($fp)
li $t9, 8
sw $t9, 0($t8)# in process_expression: *temp10 = #8
sw $t8, -332($fp)
move $t8, $t7# in process_expression: temp11 := &mainArray_
sw $t8, -336($fp)
li $t8, 2
sw $s5, -136($fp)
li $s5, 4
mul $t2, $t8, $s5# in handle_binary_op: temp12 := #2 * #4
sw $t2, -340($fp)
lw $t2, -340($fp)
sw $s6, -140($fp)
lw $s6, -336($fp)
add $t3, $t2, $s6# in handle_binary_op: temp13 := temp12 + temp11
sw $t3, -344($fp)
lw $t3, -344($fp)
li $t4, 3
sw $t4, 0($t3)# in process_expression: *temp13 = #3
sw $t3, -344($fp)
move $t3, $t7# in process_expression: temp14 := &mainArray_
sw $t3, -348($fp)
li $t3, 3
li $t5, 4
mul $t6, $t3, $t5# in handle_binary_op: temp15 := #3 * #4
sw $t6, -352($fp)
lw $t6, -352($fp)
lw $s1, -348($fp)
sw $t0, -316($fp)
add $t0, $t6, $s1# in handle_binary_op: temp16 := temp15 + temp14
sw $t0, -356($fp)
lw $t0, -356($fp)
sw $s0, -312($fp)
li $s0, 12
sw $s0, 0($t0)# in process_expression: *temp16 = #12
sw $t0, -356($fp)
move $t0, $t7# in process_expression: temp17 := &mainArray_
sw $t0, -360($fp)
li $t0, 4
li $t1, 4
mul $s3, $t0, $t1# in handle_binary_op: temp18 := #4 * #4
sw $s3, -364($fp)
lw $s3, -364($fp)
lw $s2, -360($fp)
sw $s4, -328($fp)
add $s4, $s3, $s2# in handle_binary_op: temp19 := temp18 + temp17
sw $s4, -368($fp)
lw $s4, -368($fp)
sw $s7, -324($fp)
li $s7, 7
sw $s7, 0($s4)# in process_expression: *temp19 = #7
sw $s4, -368($fp)
addi $sp, $sp, -4# READ temp20: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp20: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp20: 恢复返回地址
move $s4, $v0# READ temp20: 将返回值存储到temp20
move $t9, $s4# in process_expression: valueModifierIn_ := temp20
sw $t9, -376($fp)
addi $sp, $sp, -4# READ temp21: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp21: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp21: 恢复返回地址
move $t9, $v0# READ temp21: 将返回值存储到temp21
move $t8, $t9# in process_expression: complexCheckValIn_ := temp21
sw $t8, -384($fp)
addi $sp, $sp, -4# READ temp22: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp22: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp22: 恢复返回地址
move $t8, $v0# READ temp22: 将返回值存储到temp22
move $s5, $t8# in process_expression: loopExecLimit_ := temp22
sw $s5, -392($fp)
lw $s5, -392($fp)
sw $t2, -340($fp)
li $t2, 5
bgt $s5, $t2, label9
j label10# GOTO label10
label9 :
li $s5, 5# in process_expression: loopExecLimit_ := #5
sw $s5, -392($fp)
label10 :
lw $s5, -392($fp)
sw $s6, -336($fp)
li $s6, 0
blt $s5, $s6, label11
j label12# GOTO label12
label11 :
li $s5, 0# in process_expression: loopExecLimit_ := #0
sw $s5, -392($fp)
label12 :
label13 :
lw $s5, -304($fp)
lw $t4, -392($fp)
blt $s5, $t4, label14
j label15# GOTO label15
label14 :
move $t3, $t7# in process_expression: temp23 := &mainArray_
sw $t3, -396($fp)
li $t3, 4
mul $t5, $s5, $t3# in handle_binary_op: temp24 := loopCounter_ * #4
sw $t5, -400($fp)
lw $t5, -400($fp)
sw $t6, -352($fp)
lw $t6, -396($fp)
sw $s1, -348($fp)
add $s1, $t5, $t6# in handle_binary_op: temp25 := temp24 + temp23
sw $s1, -404($fp)
move $s1, $t7# in process_expression: temp26 := &mainArray_
sw $s1, -408($fp)
li $s1, 4
mul $s0, $s5, $s1# in handle_binary_op: temp27 := loopCounter_ * #4
sw $s0, -412($fp)
lw $s0, -412($fp)
lw $t0, -408($fp)
add $t1, $s0, $t0# in handle_binary_op: temp28 := temp27 + temp26
sw $t1, -416($fp)
lw $t1, -416($fp)
sw $s3, -364($fp)
lw $s3, 0($t1)# in process_expression: temp29 := *temp28
sw $s3, -420($fp)
lw $s3, -376($fp)
subu $sp, $sp, 4# ARG valueModifierIn_: 压栈参数
sw $s3, 0($sp)
sw $s2, -360($fp)
lw $s2, -420($fp)
subu $sp, $sp, 4# ARG temp29: 压栈参数
sw $s2, 0($sp)
subu $sp, $sp, 4# ARG loopCounter_: 压栈参数
sw $s5, 0($sp)
jal getNextValue# CALL getNextValue: 调用函数
move $s7, $v0# CALL getNextValue: 保存返回值
sw $s4, -372($fp)
lw $s4, -404($fp)
sw $s7, 0($s4)# in process_expression: *temp25 = temp30
sw $s4, -404($fp)
move $s4, $t7# in process_expression: temp31 := &mainArray_
sw $s4, -428($fp)
li $s4, 4
sw $t9, -380($fp)
mul $t9, $s5, $s4# in handle_binary_op: temp32 := loopCounter_ * #4
sw $t9, -432($fp)
lw $t9, -432($fp)
sw $t8, -388($fp)
lw $t8, -428($fp)
add $t2, $t9, $t8# in handle_binary_op: temp33 := temp32 + temp31
sw $t2, -436($fp)
lw $t2, -436($fp)
lw $s6, 0($t2)# in process_expression: temp34 := *temp33
sw $s6, -440($fp)
lw $s6, -384($fp)
subu $sp, $sp, 4# ARG complexCheckValIn_: 压栈参数
sw $s6, 0($sp)
sw $t4, -392($fp)
lw $t4, -440($fp)
subu $sp, $sp, 4# ARG temp34: 压栈参数
sw $t4, 0($sp)
jal checkComplexCondition# CALL checkComplexCondition: 调用函数
move $t3, $v0# CALL checkComplexCondition: 保存返回值
sw $t5, -400($fp)
li $t5, 1
beq $t3, $t5, label16
j label17# GOTO label17
label16 :
sw $t6, -396($fp)
lw $t6, -308($fp)
li $s1, 1
sw $s0, -412($fp)
add $s0, $t6, $s1# in handle_binary_op: temp36 := conditionMetCounter_ + #1
sw $s0, -448($fp)
lw $s0, -448($fp)
move $t6, $s0# in process_expression: conditionMetCounter_ := temp36
sw $t6, -308($fp)
label17 :
li $t6, 1
sw $t0, -408($fp)
add $t0, $s5, $t6# in handle_binary_op: temp37 := loopCounter_ + #1
sw $t0, -452($fp)
lw $t0, -452($fp)
move $s5, $t0# in process_expression: loopCounter_ := temp37
sw $s5, -304($fp)
j label13# GOTO label13
label15 :
move $s5, $t7# in process_expression: temp38 := &mainArray_
sw $s5, -456($fp)
li $s5, 0
sw $t1, -416($fp)
li $t1, 4
sw $s3, -376($fp)
mul $s3, $s5, $t1# in handle_binary_op: temp39 := #0 * #4
sw $s3, -460($fp)
lw $s3, -460($fp)
sw $s2, -420($fp)
lw $s2, -456($fp)
sw $s7, -424($fp)
add $s7, $s3, $s2# in handle_binary_op: temp40 := temp39 + temp38
sw $s7, -464($fp)
lw $s7, -464($fp)
lw $s4, 0($s7)# in process_expression: temp41 := *temp40
sw $s4, -468($fp)
lw $s4, -468($fp)
move $a0, $s4# WRITE temp41: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp41: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp41: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp41: 恢复返回地址
sw $t9, -432($fp)
lw $t9, -392($fp)
sw $t8, -428($fp)
li $t8, 0
bgt $t9, $t8, label18
j label19# GOTO label19
label18 :
sw $t2, -436($fp)
move $t2, $t7# in process_expression: temp42 := &mainArray_
sw $t2, -472($fp)
li $t2, 1
sw $s6, -384($fp)
sub $s6, $t9, $t2# in handle_binary_op: temp43 := loopExecLimit_ - #1
sw $s6, -476($fp)
lw $s6, -476($fp)
sw $t4, -440($fp)
li $t4, 4
sw $t3, -444($fp)
mul $t3, $s6, $t4# in handle_binary_op: temp44 := temp43 * #4
sw $t3, -480($fp)
lw $t3, -480($fp)
lw $t5, -472($fp)
add $s1, $t3, $t5# in handle_binary_op: temp45 := temp44 + temp42
sw $s1, -484($fp)
lw $s1, -484($fp)
sw $s0, -448($fp)
lw $s0, 0($s1)# in process_expression: temp46 := *temp45
sw $s0, -488($fp)
lw $s0, -488($fp)
move $a0, $s0# WRITE temp46: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp46: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp46: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp46: 恢复返回地址
j label20# GOTO label20
label19 :
move $t6, $t7# in process_expression: temp47 := &mainArray_
sw $t6, -492($fp)
li $t6, 0
sw $t0, -452($fp)
li $t0, 4
mul $s5, $t6, $t0# in handle_binary_op: temp48 := #0 * #4
sw $s5, -496($fp)
lw $s5, -496($fp)
lw $t1, -492($fp)
sw $s3, -460($fp)
add $s3, $s5, $t1# in handle_binary_op: temp49 := temp48 + temp47
sw $s3, -500($fp)
lw $s3, -500($fp)
sw $s2, -456($fp)
lw $s2, 0($s3)# in process_expression: temp50 := *temp49
sw $s2, -504($fp)
lw $s2, -504($fp)
move $a0, $s2# WRITE temp50: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp50: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp50: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp50: 恢复返回地址
label20 :
sw $s7, -464($fp)
lw $s7, -308($fp)
move $a0, $s7# WRITE conditionMetCounter_: 将值移动到$a0
subu $sp, $sp, 4# WRITE conditionMetCounter_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE conditionMetCounter_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE conditionMetCounter_: 恢复返回地址
sw $s4, -468($fp)
lw $s4, -304($fp)
move $a0, $s4# WRITE loopCounter_: 将值移动到$a0
subu $sp, $sp, 4# WRITE loopCounter_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE loopCounter_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE loopCounter_: 恢复返回地址
li $t8, 0
move $v0, $t8# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

