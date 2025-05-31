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
sw $t3, -84($fp)
lw $t4, -84($fp)
move $t3, $t4# in process_expression: baseRes_ := temp0
sw $t3, -88($fp)
lw $t3, -88($fp)
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
sw $t6, -92($fp)
lw $t3, -88($fp)
lw $t6, -92($fp)
move $t3, $t6# in process_expression: baseRes_ := temp1
sw $t3, -88($fp)
lw $t3, -88($fp)
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
lw $t7, 0($fp)# PARAM baseIn_: 读取第1个参数
lw $s0, 4($fp)# PARAM inputOther_: 读取第2个参数
add $s1, $t7, $s0# in handle_binary_op: temp2 := baseIn_ + inputOther_
sw $s1, -88($fp)
lw $s1, -88($fp)
li $s2, 5
div $s1, $s2
mflo $s3# in handle_binary_op: temp3 := temp2 / #5 (get quotient)
sw $s3, -92($fp)
lw $s4, -92($fp)
move $s3, $s4# in process_expression: indexRes_ := temp3
sw $s3, -96($fp)
lw $s3, -96($fp)
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
lw $s3, -96($fp)
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
lw $s3, -96($fp)
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
addi $t1, $fp, -80
move $t9, $t1# in process_expression: temp4 := &dataArray_
sw $t9, -132($fp)
li $t9, 0
li $t2, 4
sw $t4, -84($fp)
mul $t4, $t9, $t2# in handle_binary_op: temp5 := #0 * #4
sw $t4, -136($fp)
lw $t4, -136($fp)
sw $t0, -80($fp)
lw $t0, -132($fp)
add $t5, $t4, $t0# in handle_binary_op: temp6 := temp5 + temp4
sw $t5, -140($fp)
lw $t5, -140($fp)
sw $t6, -92($fp)
li $t6, 1
sw $t6, 4($t5)# in process_expression: *temp6 = #1
sw $t5, -140($fp)
addi $t1, $fp, -80
move $t5, $t1# in process_expression: temp7 := &dataArray_
sw $t5, -144($fp)
li $t5, 1
sw $t3, -88($fp)
li $t3, 4
sw $t7, -80($fp)
mul $t7, $t5, $t3# in handle_binary_op: temp8 := #1 * #4
sw $t7, -148($fp)
lw $t7, -148($fp)
sw $s0, -84($fp)
lw $s0, -144($fp)
sw $s1, -88($fp)
add $s1, $t7, $s0# in handle_binary_op: temp9 := temp8 + temp7
sw $s1, -152($fp)
lw $s1, -152($fp)
li $s2, 2
sw $s2, 4($s1)# in process_expression: *temp9 = #2
sw $s1, -152($fp)
addi $t1, $fp, -80
move $s1, $t1# in process_expression: temp10 := &dataArray_
sw $s1, -156($fp)
li $s1, 2
sw $s4, -92($fp)
li $s4, 4
mul $s5, $s1, $s4# in handle_binary_op: temp11 := #2 * #4
sw $s5, -160($fp)
lw $s5, -160($fp)
lw $s6, -156($fp)
add $s7, $s5, $s6# in handle_binary_op: temp12 := temp11 + temp10
sw $s7, -164($fp)
lw $s7, -164($fp)
li $t8, 3
sw $t8, 4($s7)# in process_expression: *temp12 = #3
sw $s7, -164($fp)
addi $t1, $fp, -80
move $s7, $t1# in process_expression: temp13 := &dataArray_
sw $s7, -168($fp)
li $s7, 0
sw $s3, -96($fp)
li $s3, 4
mul $t9, $s7, $s3# in handle_binary_op: temp14 := #0 * #4
sw $t9, -172($fp)
lw $t9, -172($fp)
lw $t2, -168($fp)
sw $t4, -136($fp)
add $t4, $t9, $t2# in handle_binary_op: temp15 := temp14 + temp13
sw $t4, -176($fp)
lw $t4, -176($fp)
sw $t0, -132($fp)
lw $t0, 4($t4)# in process_expression: temp16 := *temp15
sw $t0, -180($fp)
lw $t0, -180($fp)
move $a0, $t0# WRITE temp16: 将值移动到$a0
sw $ra, 0($sp)
jal write# WRITE temp16: 调用write函数
lw $ra, 0($sp)
addi $t1, $fp, -80
move $t6, $t1# in process_expression: temp17 := &dataArray_
sw $t6, -184($fp)
li $t6, 1
li $t5, 4
mul $t3, $t6, $t5# in handle_binary_op: temp18 := #1 * #4
sw $t3, -188($fp)
lw $t3, -188($fp)
sw $t7, -148($fp)
lw $t7, -184($fp)
sw $s0, -144($fp)
add $s0, $t3, $t7# in handle_binary_op: temp19 := temp18 + temp17
sw $s0, -192($fp)
lw $s0, -192($fp)
lw $s2, 4($s0)# in process_expression: temp20 := *temp19
sw $s2, -196($fp)
lw $s2, -196($fp)
move $a0, $s2# WRITE temp20: 将值移动到$a0
sw $ra, 0($sp)
jal write# WRITE temp20: 调用write函数
lw $ra, 0($sp)
addi $t1, $fp, -80
move $s1, $t1# in process_expression: temp21 := &dataArray_
sw $s1, -200($fp)
li $s1, 2
li $s4, 4
sw $s5, -160($fp)
mul $s5, $s1, $s4# in handle_binary_op: temp22 := #2 * #4
sw $s5, -204($fp)
lw $s5, -204($fp)
sw $s6, -156($fp)
lw $s6, -200($fp)
add $t8, $s5, $s6# in handle_binary_op: temp23 := temp22 + temp21
sw $t8, -208($fp)
lw $t8, -208($fp)
lw $s7, 4($t8)# in process_expression: temp24 := *temp23
sw $s7, -212($fp)
lw $s7, -212($fp)
move $a0, $s7# WRITE temp24: 将值移动到$a0
sw $ra, 0($sp)
jal write# WRITE temp24: 调用write函数
lw $ra, 0($sp)
li $s3, 0
move $v0, $s3# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

