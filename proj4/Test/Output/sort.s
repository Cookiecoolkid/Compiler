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
subu $sp, $sp, 4
lw $t0, 0($fp)# PARAM totalSize_: 读取第1个参数
subu $sp, $sp, 4
lw $t1, 4($fp)# PARAM outerLoopIndex_: 读取第2个参数
subu $sp, $sp, 4
sub $t2, $t0, $t1# in handle_binary_op: temp0 := totalSize_ - outerLoopIndex_
sw $t2, -92($fp)
sw $t0, -84($fp)
sw $t1, -88($fp)
lw $t0, -92($fp)
li $t1, 1
subu $sp, $sp, 4
sub $t2, $t0, $t1# in handle_binary_op: temp1 := temp0 - #1
sw $t2, -96($fp)
sw $t0, -92($fp)
subu $sp, $sp, 4
lw $t1, -96($fp)
move $t0, $t1# in process_expression: limitResult_ := temp1
sw $t0, -100($fp)
lw $t0, -100($fp)
move $v0, $t0# RETURN limitResult_: 设置返回值
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
subu $sp, $sp, 4
subu $sp, $sp, 80
subu $sp, $sp, 4
li $t0, 5# in process_expression: arrayDataSize_ := #5
sw $t0, -168($fp)
subu $sp, $sp, 4
li $t0, 0# in process_expression: outerIdx_ := #0
sw $t0, -172($fp)
subu $sp, $sp, 4
li $t0, 0# in process_expression: innerIdx_ := #0
sw $t0, -176($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t0, $t1# in process_expression: temp2 := &sortArrayData_
sw $t0, -180($fp)
li $t0, 0
li $t2, 4
subu $sp, $sp, 4
mul $t3, $t0, $t2# in handle_binary_op: temp3 := #0 * #4
sw $t3, -184($fp)
lw $t0, -184($fp)
lw $t2, -180($fp)
subu $sp, $sp, 4
add $t3, $t0, $t2# in handle_binary_op: temp4 := temp3 + temp2
sw $t3, -188($fp)
sw $t0, -184($fp)
sw $t2, -180($fp)
lw $t0, -188($fp)
li $t2, 5
sw $t2, 4($t0)# in process_expression: *temp4 = #5
sw $t0, -188($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t0, $t1# in process_expression: temp5 := &sortArrayData_
sw $t0, -192($fp)
li $t0, 1
li $t3, 4
subu $sp, $sp, 4
mul $t4, $t0, $t3# in handle_binary_op: temp6 := #1 * #4
sw $t4, -196($fp)
lw $t0, -196($fp)
lw $t3, -192($fp)
subu $sp, $sp, 4
add $t4, $t0, $t3# in handle_binary_op: temp7 := temp6 + temp5
sw $t4, -200($fp)
sw $t0, -196($fp)
sw $t3, -192($fp)
lw $t0, -200($fp)
li $t3, 4
sw $t3, 4($t0)# in process_expression: *temp7 = #4
sw $t0, -200($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t0, $t1# in process_expression: temp8 := &sortArrayData_
sw $t0, -204($fp)
li $t0, 2
li $t4, 4
subu $sp, $sp, 4
mul $t5, $t0, $t4# in handle_binary_op: temp9 := #2 * #4
sw $t5, -208($fp)
lw $t0, -208($fp)
lw $t4, -204($fp)
subu $sp, $sp, 4
add $t5, $t0, $t4# in handle_binary_op: temp10 := temp9 + temp8
sw $t5, -212($fp)
sw $t0, -208($fp)
sw $t4, -204($fp)
lw $t0, -212($fp)
li $t4, 3
sw $t4, 4($t0)# in process_expression: *temp10 = #3
sw $t0, -212($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t0, $t1# in process_expression: temp11 := &sortArrayData_
sw $t0, -216($fp)
li $t0, 3
li $t5, 4
subu $sp, $sp, 4
mul $t6, $t0, $t5# in handle_binary_op: temp12 := #3 * #4
sw $t6, -220($fp)
lw $t0, -220($fp)
lw $t5, -216($fp)
subu $sp, $sp, 4
add $t6, $t0, $t5# in handle_binary_op: temp13 := temp12 + temp11
sw $t6, -224($fp)
sw $t0, -220($fp)
sw $t5, -216($fp)
lw $t0, -224($fp)
li $t5, 2
sw $t5, 4($t0)# in process_expression: *temp13 = #2
sw $t0, -224($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t0, $t1# in process_expression: temp14 := &sortArrayData_
sw $t0, -228($fp)
li $t0, 4
li $t6, 4
subu $sp, $sp, 4
mul $t7, $t0, $t6# in handle_binary_op: temp15 := #4 * #4
sw $t7, -232($fp)
lw $t0, -232($fp)
lw $t6, -228($fp)
subu $sp, $sp, 4
add $t7, $t0, $t6# in handle_binary_op: temp16 := temp15 + temp14
sw $t7, -236($fp)
sw $t0, -232($fp)
sw $t6, -228($fp)
lw $t0, -236($fp)
li $t6, 1
sw $t6, 4($t0)# in process_expression: *temp16 = #1
sw $t0, -236($fp)
lw $t0, -172($fp)
li $t0, 0# in process_expression: outerIdx_ := #0
sw $t0, -172($fp)
label0 :
lw $t0, -172($fp)
lw $t7, -168($fp)
blt $t0, $t7, label1
j label2# GOTO label2
label1 :
subu $sp, $sp, 4
addi $t1, $fp, -84
move $s0, $t1# in process_expression: temp17 := &sortArrayData_
sw $s0, -240($fp)
lw $t0, -172($fp)
li $s0, 4
subu $sp, $sp, 4
mul $s1, $t0, $s0# in handle_binary_op: temp18 := outerIdx_ * #4
sw $s1, -244($fp)
sw $t0, -172($fp)
lw $t0, -244($fp)
lw $s0, -240($fp)
subu $sp, $sp, 4
add $s1, $t0, $s0# in handle_binary_op: temp19 := temp18 + temp17
sw $s1, -248($fp)
sw $t0, -244($fp)
sw $s0, -240($fp)
lw $t0, -248($fp)
subu $sp, $sp, 4
lw $s0, 4($t0)# in process_expression: temp20 := *temp19
sw $s0, -252($fp)
lw $s0, -252($fp)
move $a0, $s0# WRITE temp20: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp20: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp20: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp20: 恢复返回地址
lw $s1, -172($fp)
li $s2, 1
subu $sp, $sp, 4
add $s3, $s1, $s2# in handle_binary_op: temp21 := outerIdx_ + #1
sw $s3, -256($fp)
sw $s1, -172($fp)
lw $s1, -172($fp)
lw $s2, -256($fp)
move $s1, $s2# in process_expression: outerIdx_ := temp21
sw $s1, -172($fp)
j label0# GOTO label0
label2 :
lw $s1, -172($fp)
li $s1, 0# in process_expression: outerIdx_ := #0
sw $s1, -172($fp)
lw $t7, -168($fp)
li $s1, 1
subu $sp, $sp, 4
sub $s3, $t7, $s1# in handle_binary_op: temp22 := arrayDataSize_ - #1
sw $s3, -260($fp)
sw $t7, -168($fp)
subu $sp, $sp, 4
lw $s1, -260($fp)
move $t7, $s1# in process_expression: outerLimit_ := temp22
sw $t7, -264($fp)
label3 :
lw $t7, -172($fp)
lw $s3, -264($fp)
blt $t7, $s3, label4
j label5# GOTO label5
label4 :
lw $s4, -176($fp)
li $s4, 0# in process_expression: innerIdx_ := #0
sw $s4, -176($fp)
lw $t7, -172($fp)
subu $sp, $sp, 4
sw $t7, 0($sp)# ARG outerIdx_: 压栈参数
lw $s4, -168($fp)
subu $sp, $sp, 4
sw $s4, 0($sp)# ARG arrayDataSize_: 压栈参数
jal calculateInnerLoopLimit# CALL calculateInnerLoopLimit: 调用函数
addi $sp, $sp, 8# CALL calculateInnerLoopLimit: 恢复栈指针
subu $sp, $sp, 4
move $s5, $v0# CALL calculateInnerLoopLimit: 保存返回值
subu $sp, $sp, 4
move $s6, $s5# in process_expression: innerLimit_ := temp23
sw $s6, -272($fp)
label6 :
lw $s6, -176($fp)
lw $s7, -272($fp)
blt $s6, $s7, label7
j label8# GOTO label8
label7 :
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t8, $t1# in process_expression: temp24 := &sortArrayData_
sw $t8, -276($fp)
lw $s6, -176($fp)
li $t8, 4
subu $sp, $sp, 4
mul $t9, $s6, $t8# in handle_binary_op: temp25 := innerIdx_ * #4
sw $t9, -280($fp)
sw $s6, -176($fp)
lw $s6, -280($fp)
lw $t8, -276($fp)
subu $sp, $sp, 4
add $t9, $s6, $t8# in handle_binary_op: temp26 := temp25 + temp24
sw $t9, -284($fp)
sw $s6, -280($fp)
sw $t8, -276($fp)
lw $s6, -284($fp)
subu $sp, $sp, 4
lw $t8, 4($s6)# in process_expression: temp27 := *temp26
sw $t8, -288($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t8, $t1# in process_expression: temp28 := &sortArrayData_
sw $t8, -292($fp)
lw $t8, -176($fp)
li $t9, 1
subu $sp, $sp, 4
add $t2, $t8, $t9# in handle_binary_op: temp29 := innerIdx_ + #1
sw $t2, -296($fp)
sw $t8, -176($fp)
lw $t2, -296($fp)
li $t8, 4
subu $sp, $sp, 4
mul $t9, $t2, $t8# in handle_binary_op: temp30 := temp29 * #4
sw $t9, -300($fp)
sw $t2, -296($fp)
lw $t2, -300($fp)
lw $t8, -292($fp)
subu $sp, $sp, 4
add $t9, $t2, $t8# in handle_binary_op: temp31 := temp30 + temp28
sw $t9, -304($fp)
sw $t2, -300($fp)
sw $t8, -292($fp)
lw $t2, -304($fp)
subu $sp, $sp, 4
lw $t8, 4($t2)# in process_expression: temp32 := *temp31
sw $t8, -308($fp)
lw $t8, -288($fp)
lw $t9, -308($fp)
bgt $t8, $t9, label9
j label10# GOTO label10
label9 :
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t3, $t1# in process_expression: temp33 := &sortArrayData_
sw $t3, -312($fp)
lw $t3, -176($fp)
li $t4, 4
subu $sp, $sp, 4
mul $t5, $t3, $t4# in handle_binary_op: temp34 := innerIdx_ * #4
sw $t5, -316($fp)
sw $t3, -176($fp)
lw $t3, -316($fp)
lw $t4, -312($fp)
subu $sp, $sp, 4
add $t5, $t3, $t4# in handle_binary_op: temp35 := temp34 + temp33
sw $t5, -320($fp)
sw $t3, -316($fp)
sw $t4, -312($fp)
lw $t3, -320($fp)
subu $sp, $sp, 4
lw $t4, 4($t3)# in process_expression: temp36 := *temp35
sw $t4, -324($fp)
subu $sp, $sp, 4
lw $t5, -324($fp)
move $t4, $t5# in process_expression: swapHolder_ := temp36
sw $t4, -328($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t4, $t1# in process_expression: temp37 := &sortArrayData_
sw $t4, -332($fp)
lw $t4, -176($fp)
li $t6, 4
subu $sp, $sp, 4
sw $t0, -248($fp)
mul $t0, $t4, $t6# in handle_binary_op: temp38 := innerIdx_ * #4
sw $t0, -336($fp)
sw $t4, -176($fp)
lw $t0, -336($fp)
lw $t4, -332($fp)
subu $sp, $sp, 4
add $t6, $t0, $t4# in handle_binary_op: temp39 := temp38 + temp37
sw $t6, -340($fp)
sw $t0, -336($fp)
sw $t4, -332($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t0, $t1# in process_expression: temp40 := &sortArrayData_
sw $t0, -344($fp)
lw $t0, -176($fp)
li $t4, 1
subu $sp, $sp, 4
add $t6, $t0, $t4# in handle_binary_op: temp41 := innerIdx_ + #1
sw $t6, -348($fp)
sw $t0, -176($fp)
lw $t0, -348($fp)
li $t4, 4
subu $sp, $sp, 4
mul $t6, $t0, $t4# in handle_binary_op: temp42 := temp41 * #4
sw $t6, -352($fp)
sw $t0, -348($fp)
lw $t0, -352($fp)
lw $t4, -344($fp)
subu $sp, $sp, 4
add $t6, $t0, $t4# in handle_binary_op: temp43 := temp42 + temp40
sw $t6, -356($fp)
sw $t0, -352($fp)
sw $t4, -344($fp)
lw $t0, -356($fp)
subu $sp, $sp, 4
lw $t4, 4($t0)# in process_expression: temp44 := *temp43
sw $t4, -360($fp)
lw $t4, -340($fp)
lw $t6, -360($fp)
sw $t6, 4($t4)# in process_expression: *temp39 = temp44
sw $t4, -340($fp)
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t4, $t1# in process_expression: temp45 := &sortArrayData_
sw $t4, -364($fp)
lw $t4, -176($fp)
sw $s0, -252($fp)
li $s0, 1
subu $sp, $sp, 4
sw $s2, -256($fp)
add $s2, $t4, $s0# in handle_binary_op: temp46 := innerIdx_ + #1
sw $s2, -368($fp)
sw $t4, -176($fp)
lw $t4, -368($fp)
li $s0, 4
subu $sp, $sp, 4
mul $s2, $t4, $s0# in handle_binary_op: temp47 := temp46 * #4
sw $s2, -372($fp)
sw $t4, -368($fp)
lw $t4, -372($fp)
lw $s0, -364($fp)
subu $sp, $sp, 4
add $s2, $t4, $s0# in handle_binary_op: temp48 := temp47 + temp45
sw $s2, -376($fp)
sw $t4, -372($fp)
sw $s0, -364($fp)
lw $t4, -376($fp)
lw $s0, -328($fp)
sw $s0, 4($t4)# in process_expression: *temp48 = swapHolder_
sw $t4, -376($fp)
label10 :
lw $t4, -176($fp)
li $s2, 1
subu $sp, $sp, 4
sw $s1, -260($fp)
add $s1, $t4, $s2# in handle_binary_op: temp49 := innerIdx_ + #1
sw $s1, -380($fp)
sw $t4, -176($fp)
lw $t4, -176($fp)
lw $s1, -380($fp)
move $t4, $s1# in process_expression: innerIdx_ := temp49
sw $t4, -176($fp)
j label6# GOTO label6
label8 :
subu $sp, $sp, 4
addi $t1, $fp, -84
move $t4, $t1# in process_expression: temp50 := &sortArrayData_
sw $t4, -384($fp)
li $t4, 0
li $s2, 4
subu $sp, $sp, 4
sw $s3, -264($fp)
mul $s3, $t4, $s2# in handle_binary_op: temp51 := #0 * #4
sw $s3, -388($fp)
lw $t4, -388($fp)
lw $s2, -384($fp)
subu $sp, $sp, 4
add $s3, $t4, $s2# in handle_binary_op: temp52 := temp51 + temp50
sw $s3, -392($fp)
sw $t4, -388($fp)
sw $s2, -384($fp)
lw $t4, -392($fp)
subu $sp, $sp, 4
lw $s2, 4($t4)# in process_expression: temp53 := *temp52
sw $s2, -396($fp)
lw $s2, -396($fp)
move $a0, $s2# WRITE temp53: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp53: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp53: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp53: 恢复返回地址
subu $sp, $sp, 4
addi $t1, $fp, -84
move $s3, $t1# in process_expression: temp54 := &sortArrayData_
sw $s3, -400($fp)
li $s3, 1
sw $t7, -172($fp)
li $t7, 4
subu $sp, $sp, 4
sw $s4, -168($fp)
mul $s4, $s3, $t7# in handle_binary_op: temp55 := #1 * #4
sw $s4, -404($fp)
lw $t7, -404($fp)
lw $s3, -400($fp)
subu $sp, $sp, 4
add $s4, $t7, $s3# in handle_binary_op: temp56 := temp55 + temp54
sw $s4, -408($fp)
sw $t7, -404($fp)
sw $s3, -400($fp)
lw $t7, -408($fp)
subu $sp, $sp, 4
lw $s3, 4($t7)# in process_expression: temp57 := *temp56
sw $s3, -412($fp)
lw $s3, -412($fp)
move $a0, $s3# WRITE temp57: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp57: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp57: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp57: 恢复返回地址
subu $sp, $sp, 4
addi $t1, $fp, -84
move $s4, $t1# in process_expression: temp58 := &sortArrayData_
sw $s4, -416($fp)
li $s4, 2
sw $s5, -268($fp)
li $s5, 4
subu $sp, $sp, 4
sw $s7, -272($fp)
mul $s7, $s4, $s5# in handle_binary_op: temp59 := #2 * #4
sw $s7, -420($fp)
lw $s4, -420($fp)
lw $s5, -416($fp)
subu $sp, $sp, 4
add $s7, $s4, $s5# in handle_binary_op: temp60 := temp59 + temp58
sw $s7, -424($fp)
sw $s4, -420($fp)
sw $s5, -416($fp)
lw $s4, -424($fp)
subu $sp, $sp, 4
lw $s5, 4($s4)# in process_expression: temp61 := *temp60
sw $s5, -428($fp)
lw $s5, -428($fp)
move $a0, $s5# WRITE temp61: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp61: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp61: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp61: 恢复返回地址
subu $sp, $sp, 4
addi $t1, $fp, -84
move $s7, $t1# in process_expression: temp62 := &sortArrayData_
sw $s7, -432($fp)
li $s7, 3
sw $s6, -284($fp)
li $s6, 4
subu $sp, $sp, 4
sw $t2, -304($fp)
mul $t2, $s7, $s6# in handle_binary_op: temp63 := #3 * #4
sw $t2, -436($fp)
lw $t2, -436($fp)
lw $s6, -432($fp)
subu $sp, $sp, 4
add $s7, $t2, $s6# in handle_binary_op: temp64 := temp63 + temp62
sw $s7, -440($fp)
sw $t2, -436($fp)
sw $s6, -432($fp)
lw $t2, -440($fp)
subu $sp, $sp, 4
lw $s6, 4($t2)# in process_expression: temp65 := *temp64
sw $s6, -444($fp)
lw $s6, -444($fp)
move $a0, $s6# WRITE temp65: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp65: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp65: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp65: 恢复返回地址
subu $sp, $sp, 4
addi $t1, $fp, -84
move $s7, $t1# in process_expression: temp66 := &sortArrayData_
sw $s7, -448($fp)
li $s7, 4
sw $t8, -288($fp)
li $t8, 4
subu $sp, $sp, 4
sw $t9, -308($fp)
mul $t9, $s7, $t8# in handle_binary_op: temp67 := #4 * #4
sw $t9, -452($fp)
lw $s7, -452($fp)
lw $t8, -448($fp)
subu $sp, $sp, 4
add $t9, $s7, $t8# in handle_binary_op: temp68 := temp67 + temp66
sw $t9, -456($fp)
sw $s7, -452($fp)
sw $t8, -448($fp)
lw $s7, -456($fp)
subu $sp, $sp, 4
lw $t8, 4($s7)# in process_expression: temp69 := *temp68
sw $t8, -460($fp)
lw $t8, -460($fp)
move $a0, $t8# WRITE temp69: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp69: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp69: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp69: 恢复返回地址
lw $t9, -172($fp)
sw $t3, -320($fp)
li $t3, 1
subu $sp, $sp, 4
sw $t5, -324($fp)
add $t5, $t9, $t3# in handle_binary_op: temp70 := outerIdx_ + #1
sw $t5, -464($fp)
sw $t9, -172($fp)
lw $t3, -172($fp)
lw $t5, -464($fp)
move $t3, $t5# in process_expression: outerIdx_ := temp70
sw $t3, -172($fp)
j label3# GOTO label3
label5 :
lw $t3, -172($fp)
li $t3, 0# in process_expression: outerIdx_ := #0
sw $t3, -172($fp)
label11 :
lw $t3, -172($fp)
lw $t9, -168($fp)
blt $t3, $t9, label12
j label13# GOTO label13
label12 :
subu $sp, $sp, 4
sw $t0, -356($fp)
addi $t1, $fp, -84
move $t0, $t1# in process_expression: temp71 := &sortArrayData_
sw $t0, -468($fp)
lw $t3, -172($fp)
li $t0, 4
subu $sp, $sp, 4
sw $t6, -360($fp)
mul $t6, $t3, $t0# in handle_binary_op: temp72 := outerIdx_ * #4
sw $t6, -472($fp)
sw $t3, -172($fp)
lw $t0, -472($fp)
lw $t3, -468($fp)
subu $sp, $sp, 4
add $t6, $t0, $t3# in handle_binary_op: temp73 := temp72 + temp71
sw $t6, -476($fp)
sw $t0, -472($fp)
sw $t3, -468($fp)
lw $t0, -476($fp)
subu $sp, $sp, 4
lw $t3, 4($t0)# in process_expression: temp74 := *temp73
sw $t3, -480($fp)
lw $t3, -480($fp)
move $a0, $t3# WRITE temp74: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp74: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp74: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp74: 恢复返回地址
lw $t6, -172($fp)
sw $s0, -328($fp)
li $s0, 1
subu $sp, $sp, 4
sw $s1, -380($fp)
add $s1, $t6, $s0# in handle_binary_op: temp75 := outerIdx_ + #1
sw $s1, -484($fp)
sw $t6, -172($fp)
lw $t6, -172($fp)
lw $s0, -484($fp)
move $t6, $s0# in process_expression: outerIdx_ := temp75
sw $t6, -172($fp)
j label11# GOTO label11
label13 :
li $t6, 0
move $v0, $t6# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

