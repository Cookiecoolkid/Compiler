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
sw $t3, -88($fp)
lw $t4, -88($fp)
move $t3, $t4# in process_expression: baseRes_ := temp0
sw $t3, -92($fp)
lw $t3, -92($fp)
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
sw $t6, -96($fp)
lw $t3, -92($fp)
lw $t6, -96($fp)
move $t3, $t6# in process_expression: baseRes_ := temp1
sw $t3, -92($fp)
lw $t3, -92($fp)
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
sw $s1, -92($fp)
lw $s1, -92($fp)
li $s2, 5
div $s1, $s2
mflo $s3# in handle_binary_op: temp3 := temp2 / #5 (get quotient)
sw $s3, -96($fp)
lw $s4, -96($fp)
move $s3, $s4# in process_expression: indexRes_ := temp3
sw $s3, -100($fp)
lw $s3, -100($fp)
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
lw $s3, -100($fp)
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
lw $s3, -100($fp)
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
addi $t1, $fp, -84
move $t9, $t1# in process_expression: temp4 := &dataArray_
sw $t9, -168($fp)
li $t9, 0
li $t2, 4
sw $t4, -88($fp)
mul $t4, $t9, $t2# in handle_binary_op: temp5 := #0 * #4
sw $t4, -172($fp)
lw $t4, -172($fp)
sw $t0, -84($fp)
lw $t0, -168($fp)
add $t5, $t4, $t0# in handle_binary_op: temp6 := temp5 + temp4
sw $t5, -176($fp)
lw $t5, -176($fp)
sw $t6, -96($fp)
li $t6, 1
sw $t6, 4($t5)# in process_expression: *temp6 = #1
sw $t5, -176($fp)
addi $t1, $fp, -84
move $t5, $t1# in process_expression: temp7 := &dataArray_
sw $t5, -180($fp)
li $t5, 1
sw $t3, -92($fp)
li $t3, 4
sw $t7, -84($fp)
mul $t7, $t5, $t3# in handle_binary_op: temp8 := #1 * #4
sw $t7, -184($fp)
lw $t7, -184($fp)
sw $s0, -88($fp)
lw $s0, -180($fp)
sw $s1, -92($fp)
add $s1, $t7, $s0# in handle_binary_op: temp9 := temp8 + temp7
sw $s1, -188($fp)
lw $s1, -188($fp)
li $s2, 2
sw $s2, 4($s1)# in process_expression: *temp9 = #2
sw $s1, -188($fp)
addi $t1, $fp, -84
move $s1, $t1# in process_expression: temp10 := &dataArray_
sw $s1, -192($fp)
li $s1, 2
sw $s4, -96($fp)
li $s4, 4
mul $s5, $s1, $s4# in handle_binary_op: temp11 := #2 * #4
sw $s5, -196($fp)
lw $s5, -196($fp)
lw $s6, -192($fp)
add $s7, $s5, $s6# in handle_binary_op: temp12 := temp11 + temp10
sw $s7, -200($fp)
lw $s7, -200($fp)
li $t8, 3
sw $t8, 4($s7)# in process_expression: *temp12 = #3
sw $s7, -200($fp)
addi $t1, $fp, -84
move $s7, $t1# in process_expression: temp13 := &dataArray_
sw $s7, -204($fp)
li $s7, 3
sw $s3, -100($fp)
li $s3, 4
mul $t9, $s7, $s3# in handle_binary_op: temp14 := #3 * #4
sw $t9, -208($fp)
lw $t9, -208($fp)
lw $t2, -204($fp)
sw $t4, -172($fp)
add $t4, $t9, $t2# in handle_binary_op: temp15 := temp14 + temp13
sw $t4, -212($fp)
lw $t4, -212($fp)
sw $t0, -168($fp)
li $t0, 4
sw $t0, 4($t4)# in process_expression: *temp15 = #4
sw $t4, -212($fp)
addi $t1, $fp, -84
move $t4, $t1# in process_expression: temp16 := &dataArray_
sw $t4, -216($fp)
li $t4, 4
li $t6, 4
mul $t5, $t4, $t6# in handle_binary_op: temp17 := #4 * #4
sw $t5, -220($fp)
lw $t5, -220($fp)
lw $t3, -216($fp)
sw $t7, -184($fp)
add $t7, $t5, $t3# in handle_binary_op: temp18 := temp17 + temp16
sw $t7, -224($fp)
lw $t7, -224($fp)
sw $s0, -180($fp)
li $s0, 5
sw $s0, 4($t7)# in process_expression: *temp18 = #5
sw $t7, -224($fp)
addi $t1, $fp, -84
move $t7, $t1# in process_expression: temp19 := &dataArray_
sw $t7, -228($fp)
li $t7, 0
li $s2, 4
mul $s1, $t7, $s2# in handle_binary_op: temp20 := #0 * #4
sw $s1, -232($fp)
lw $s1, -232($fp)
lw $s4, -228($fp)
sw $s5, -196($fp)
add $s5, $s1, $s4# in handle_binary_op: temp21 := temp20 + temp19
sw $s5, -236($fp)
lw $s5, -236($fp)
sw $s6, -192($fp)
lw $s6, 4($s5)# in process_expression: temp22 := *temp21
sw $s6, -240($fp)
lw $s6, -240($fp)
move $a0, $s6# WRITE temp22: 将值移动到$a0
sw $ra, -244($fp)# WRITE temp22: 保存返回地址
jal write# WRITE temp22: 调用write函数
lw $ra, -244($fp)# WRITE temp22: 恢复返回地址
addi $t1, $fp, -84
move $t8, $t1# in process_expression: temp23 := &dataArray_
sw $t8, -244($fp)
li $t8, 1
li $s7, 4
mul $s3, $t8, $s7# in handle_binary_op: temp24 := #1 * #4
sw $s3, -248($fp)
lw $s3, -248($fp)
sw $t9, -208($fp)
lw $t9, -244($fp)
sw $t2, -204($fp)
add $t2, $s3, $t9# in handle_binary_op: temp25 := temp24 + temp23
sw $t2, -252($fp)
lw $t2, -252($fp)
lw $t0, 4($t2)# in process_expression: temp26 := *temp25
sw $t0, -256($fp)
lw $t0, -256($fp)
move $a0, $t0# WRITE temp26: 将值移动到$a0
sw $ra, -260($fp)# WRITE temp26: 保存返回地址
jal write# WRITE temp26: 调用write函数
lw $ra, -260($fp)# WRITE temp26: 恢复返回地址
addi $t1, $fp, -84
move $t4, $t1# in process_expression: temp27 := &dataArray_
sw $t4, -260($fp)
li $t4, 2
li $t6, 4
sw $t5, -220($fp)
mul $t5, $t4, $t6# in handle_binary_op: temp28 := #2 * #4
sw $t5, -264($fp)
lw $t5, -264($fp)
sw $t3, -216($fp)
lw $t3, -260($fp)
add $s0, $t5, $t3# in handle_binary_op: temp29 := temp28 + temp27
sw $s0, -268($fp)
lw $s0, -268($fp)
lw $t7, 4($s0)# in process_expression: temp30 := *temp29
sw $t7, -272($fp)
lw $t7, -272($fp)
move $a0, $t7# WRITE temp30: 将值移动到$a0
sw $ra, -276($fp)# WRITE temp30: 保存返回地址
jal write# WRITE temp30: 调用write函数
lw $ra, -276($fp)# WRITE temp30: 恢复返回地址
addi $t1, $fp, -84
move $s2, $t1# in process_expression: temp31 := &dataArray_
sw $s2, -276($fp)
li $s2, 3
sw $s1, -232($fp)
li $s1, 4
sw $s4, -228($fp)
mul $s4, $s2, $s1# in handle_binary_op: temp32 := #3 * #4
sw $s4, -280($fp)
lw $s4, -280($fp)
sw $s5, -236($fp)
lw $s5, -276($fp)
sw $s6, -240($fp)
add $s6, $s4, $s5# in handle_binary_op: temp33 := temp32 + temp31
sw $s6, -284($fp)
lw $s6, -284($fp)
lw $t8, 4($s6)# in process_expression: temp34 := *temp33
sw $t8, -288($fp)
lw $t8, -288($fp)
move $a0, $t8# WRITE temp34: 将值移动到$a0
sw $ra, -292($fp)# WRITE temp34: 保存返回地址
jal write# WRITE temp34: 调用write函数
lw $ra, -292($fp)# WRITE temp34: 恢复返回地址
addi $t1, $fp, -84
move $s7, $t1# in process_expression: temp35 := &dataArray_
sw $s7, -292($fp)
li $s7, 4
sw $s3, -248($fp)
li $s3, 4
sw $t9, -244($fp)
mul $t9, $s7, $s3# in handle_binary_op: temp36 := #4 * #4
sw $t9, -296($fp)
lw $t9, -296($fp)
sw $t2, -252($fp)
lw $t2, -292($fp)
sw $t0, -256($fp)
add $t0, $t9, $t2# in handle_binary_op: temp37 := temp36 + temp35
sw $t0, -300($fp)
lw $t0, -300($fp)
lw $t4, 4($t0)# in process_expression: temp38 := *temp37
sw $t4, -304($fp)
lw $t4, -304($fp)
move $a0, $t4# WRITE temp38: 将值移动到$a0
sw $ra, -308($fp)# WRITE temp38: 保存返回地址
jal write# WRITE temp38: 调用write函数
lw $ra, -308($fp)# WRITE temp38: 恢复返回地址
sw $ra, -308($fp)# READ temp39: 保存返回地址
jal read# READ temp39: 调用read函数
lw $ra, -308($fp)# READ temp39: 恢复返回地址
move $t6, $v0# READ temp39: 将返回值存储到temp39
sw $t5, -264($fp)
move $t5, $t6# in process_expression: val1_ := temp39
sw $t5, -312($fp)
sw $ra, -316($fp)# READ temp40: 保存返回地址
jal read# READ temp40: 调用read函数
lw $ra, -316($fp)# READ temp40: 恢复返回地址
move $t5, $v0# READ temp40: 将返回值存储到temp40
sw $t3, -260($fp)
move $t3, $t5# in process_expression: val2_ := temp40
sw $t3, -320($fp)
addi $t1, $fp, -84
move $t3, $t1# in process_expression: temp41 := &dataArray_
sw $t3, -324($fp)
li $t3, 0
sw $s0, -268($fp)
li $s0, 4
sw $t7, -272($fp)
mul $t7, $t3, $s0# in handle_binary_op: temp42 := #0 * #4
sw $t7, -328($fp)
lw $t7, -328($fp)
lw $s2, -324($fp)
add $s1, $t7, $s2# in handle_binary_op: temp43 := temp42 + temp41
sw $s1, -332($fp)
lw $s1, -332($fp)
sw $s4, -280($fp)
lw $s4, 4($s1)# in process_expression: temp44 := *temp43
sw $s4, -336($fp)
lw $s4, -336($fp)
move $a0, $s4# WRITE temp44: 将值移动到$a0
sw $ra, -340($fp)# WRITE temp44: 保存返回地址
jal write# WRITE temp44: 调用write函数
lw $ra, -340($fp)# WRITE temp44: 恢复返回地址
sw $s5, -276($fp)
addi $t1, $fp, -84
move $s5, $t1# in process_expression: temp45 := &dataArray_
sw $s5, -340($fp)
li $s5, 1
sw $s6, -284($fp)
li $s6, 4
sw $t8, -288($fp)
mul $t8, $s5, $s6# in handle_binary_op: temp46 := #1 * #4
sw $t8, -344($fp)
lw $t8, -344($fp)
lw $s7, -340($fp)
add $s3, $t8, $s7# in handle_binary_op: temp47 := temp46 + temp45
sw $s3, -348($fp)
lw $s3, -348($fp)
sw $t9, -296($fp)
lw $t9, 4($s3)# in process_expression: temp48 := *temp47
sw $t9, -352($fp)
lw $t9, -352($fp)
move $a0, $t9# WRITE temp48: 将值移动到$a0
sw $ra, -356($fp)# WRITE temp48: 保存返回地址
jal write# WRITE temp48: 调用write函数
lw $ra, -356($fp)# WRITE temp48: 恢复返回地址
sw $t2, -292($fp)
addi $t1, $fp, -84
move $t2, $t1# in process_expression: temp49 := &dataArray_
sw $t2, -356($fp)
li $t2, 2
sw $t0, -300($fp)
li $t0, 4
sw $t4, -304($fp)
mul $t4, $t2, $t0# in handle_binary_op: temp50 := #2 * #4
sw $t4, -360($fp)
lw $t4, -360($fp)
sw $t6, -308($fp)
lw $t6, -356($fp)
sw $t5, -316($fp)
add $t5, $t4, $t6# in handle_binary_op: temp51 := temp50 + temp49
sw $t5, -364($fp)
lw $t5, -364($fp)
lw $t3, 4($t5)# in process_expression: temp52 := *temp51
sw $t3, -368($fp)
lw $t3, -368($fp)
move $a0, $t3# WRITE temp52: 将值移动到$a0
sw $ra, -372($fp)# WRITE temp52: 保存返回地址
jal write# WRITE temp52: 调用write函数
lw $ra, -372($fp)# WRITE temp52: 恢复返回地址
addi $t1, $fp, -84
move $s0, $t1# in process_expression: temp53 := &dataArray_
sw $s0, -372($fp)
li $s0, 3
sw $t7, -328($fp)
li $t7, 4
sw $s2, -324($fp)
mul $s2, $s0, $t7# in handle_binary_op: temp54 := #3 * #4
sw $s2, -376($fp)
lw $s2, -376($fp)
sw $s1, -332($fp)
lw $s1, -372($fp)
sw $s4, -336($fp)
add $s4, $s2, $s1# in handle_binary_op: temp55 := temp54 + temp53
sw $s4, -380($fp)
lw $s4, -380($fp)
lw $s5, 4($s4)# in process_expression: temp56 := *temp55
sw $s5, -384($fp)
lw $s5, -384($fp)
move $a0, $s5# WRITE temp56: 将值移动到$a0
sw $ra, -388($fp)# WRITE temp56: 保存返回地址
jal write# WRITE temp56: 调用write函数
lw $ra, -388($fp)# WRITE temp56: 恢复返回地址
addi $t1, $fp, -84
move $s6, $t1# in process_expression: temp57 := &dataArray_
sw $s6, -388($fp)
li $s6, 4
sw $t8, -344($fp)
li $t8, 4
sw $s7, -340($fp)
mul $s7, $s6, $t8# in handle_binary_op: temp58 := #4 * #4
sw $s7, -392($fp)
lw $s7, -392($fp)
sw $s3, -348($fp)
lw $s3, -388($fp)
sw $t9, -352($fp)
add $t9, $s7, $s3# in handle_binary_op: temp59 := temp58 + temp57
sw $t9, -396($fp)
lw $t9, -396($fp)
lw $t2, 4($t9)# in process_expression: temp60 := *temp59
sw $t2, -400($fp)
lw $t2, -400($fp)
move $a0, $t2# WRITE temp60: 将值移动到$a0
sw $ra, -404($fp)# WRITE temp60: 保存返回地址
jal write# WRITE temp60: 调用write函数
lw $ra, -404($fp)# WRITE temp60: 恢复返回地址
lw $t0, -312($fp)
subu $sp, $sp, 4
sw $t0, 0($sp)# ARG val1_: 压栈参数
jal calculateBase# CALL calculateBase: 调用函数
addi $sp, $sp, 4# CALL calculateBase: 恢复栈指针
sw $t4, -360($fp)
move $t4, $v0# CALL calculateBase: 保存返回值
sw $t6, -356($fp)
move $t6, $t4# in process_expression: baseOut_ := temp61
sw $t6, -408($fp)
lw $t6, -320($fp)
subu $sp, $sp, 4
sw $t6, 0($sp)# ARG val2_: 压栈参数
sw $t5, -364($fp)
lw $t5, -408($fp)
subu $sp, $sp, 4
sw $t5, 0($sp)# ARG baseOut_: 压栈参数
jal determineIndex# CALL determineIndex: 调用函数
addi $sp, $sp, 8# CALL determineIndex: 恢复栈指针
sw $t3, -368($fp)
move $t3, $v0# CALL determineIndex: 保存返回值
move $s0, $t3# in process_expression: targetIdx_ := temp62
sw $s0, -416($fp)
addi $t1, $fp, -84
move $s0, $t1# in process_expression: temp63 := &dataArray_
sw $s0, -420($fp)
lw $s0, -416($fp)
li $t7, 4
sw $s2, -376($fp)
mul $s2, $s0, $t7# in handle_binary_op: temp64 := targetIdx_ * #4
sw $s2, -424($fp)
lw $s2, -424($fp)
sw $s1, -372($fp)
lw $s1, -420($fp)
sw $s4, -380($fp)
add $s4, $s2, $s1# in handle_binary_op: temp65 := temp64 + temp63
sw $s4, -428($fp)
lw $s4, -428($fp)
sw $s5, -384($fp)
lw $s5, 4($s4)# in process_expression: temp66 := *temp65
sw $s5, -432($fp)
lw $s6, -432($fp)
move $s5, $s6# in process_expression: originalVal_ := temp66
sw $s5, -436($fp)
addi $t1, $fp, -84
move $s5, $t1# in process_expression: temp67 := &dataArray_
sw $s5, -440($fp)
li $s5, 0
li $t8, 4
sw $s7, -392($fp)
mul $s7, $s5, $t8# in handle_binary_op: temp68 := #0 * #4
sw $s7, -444($fp)
lw $s7, -444($fp)
sw $s3, -388($fp)
lw $s3, -440($fp)
sw $t9, -396($fp)
add $t9, $s7, $s3# in handle_binary_op: temp69 := temp68 + temp67
sw $t9, -448($fp)
lw $t9, -448($fp)
sw $t2, -400($fp)
lw $t2, 4($t9)# in process_expression: temp70 := *temp69
sw $t2, -452($fp)
lw $t2, -452($fp)
move $a0, $t2# WRITE temp70: 将值移动到$a0
sw $ra, -456($fp)# WRITE temp70: 保存返回地址
jal write# WRITE temp70: 调用write函数
lw $ra, -456($fp)# WRITE temp70: 恢复返回地址
sw $t0, -312($fp)
addi $t1, $fp, -84
move $t0, $t1# in process_expression: temp71 := &dataArray_
sw $t0, -456($fp)
li $t0, 1
sw $t4, -404($fp)
li $t4, 4
sw $t6, -320($fp)
mul $t6, $t0, $t4# in handle_binary_op: temp72 := #1 * #4
sw $t6, -460($fp)
lw $t6, -460($fp)
sw $t5, -408($fp)
lw $t5, -456($fp)
sw $t3, -412($fp)
add $t3, $t6, $t5# in handle_binary_op: temp73 := temp72 + temp71
sw $t3, -464($fp)
lw $t3, -464($fp)
sw $s0, -416($fp)
lw $s0, 4($t3)# in process_expression: temp74 := *temp73
sw $s0, -468($fp)
lw $s0, -468($fp)
move $a0, $s0# WRITE temp74: 将值移动到$a0
sw $ra, -472($fp)# WRITE temp74: 保存返回地址
jal write# WRITE temp74: 调用write函数
lw $ra, -472($fp)# WRITE temp74: 恢复返回地址
addi $t1, $fp, -84
move $t7, $t1# in process_expression: temp75 := &dataArray_
sw $t7, -472($fp)
li $t7, 2
sw $s2, -424($fp)
li $s2, 4
sw $s1, -420($fp)
mul $s1, $t7, $s2# in handle_binary_op: temp76 := #2 * #4
sw $s1, -476($fp)
lw $s1, -476($fp)
sw $s4, -428($fp)
lw $s4, -472($fp)
sw $s6, -432($fp)
add $s6, $s1, $s4# in handle_binary_op: temp77 := temp76 + temp75
sw $s6, -480($fp)
lw $s6, -480($fp)
lw $s5, 4($s6)# in process_expression: temp78 := *temp77
sw $s5, -484($fp)
lw $s5, -484($fp)
move $a0, $s5# WRITE temp78: 将值移动到$a0
sw $ra, -488($fp)# WRITE temp78: 保存返回地址
jal write# WRITE temp78: 调用write函数
lw $ra, -488($fp)# WRITE temp78: 恢复返回地址
addi $t1, $fp, -84
move $t8, $t1# in process_expression: temp79 := &dataArray_
sw $t8, -488($fp)
li $t8, 3
sw $s7, -444($fp)
li $s7, 4
sw $s3, -440($fp)
mul $s3, $t8, $s7# in handle_binary_op: temp80 := #3 * #4
sw $s3, -492($fp)
lw $s3, -492($fp)
sw $t9, -448($fp)
lw $t9, -488($fp)
sw $t2, -452($fp)
add $t2, $s3, $t9# in handle_binary_op: temp81 := temp80 + temp79
sw $t2, -496($fp)
lw $t2, -496($fp)
lw $t0, 4($t2)# in process_expression: temp82 := *temp81
sw $t0, -500($fp)
lw $t0, -500($fp)
move $a0, $t0# WRITE temp82: 将值移动到$a0
sw $ra, -504($fp)# WRITE temp82: 保存返回地址
jal write# WRITE temp82: 调用write函数
lw $ra, -504($fp)# WRITE temp82: 恢复返回地址
addi $t1, $fp, -84
move $t4, $t1# in process_expression: temp83 := &dataArray_
sw $t4, -504($fp)
li $t4, 4
sw $t6, -460($fp)
li $t6, 4
sw $t5, -456($fp)
mul $t5, $t4, $t6# in handle_binary_op: temp84 := #4 * #4
sw $t5, -508($fp)
lw $t5, -508($fp)
sw $t3, -464($fp)
lw $t3, -504($fp)
sw $s0, -468($fp)
add $s0, $t5, $t3# in handle_binary_op: temp85 := temp84 + temp83
sw $s0, -512($fp)
lw $s0, -512($fp)
lw $t7, 4($s0)# in process_expression: temp86 := *temp85
sw $t7, -516($fp)
lw $t7, -516($fp)
move $a0, $t7# WRITE temp86: 将值移动到$a0
sw $ra, -520($fp)# WRITE temp86: 保存返回地址
jal write# WRITE temp86: 调用write函数
lw $ra, -520($fp)# WRITE temp86: 恢复返回地址
lw $s2, -408($fp)
sw $s1, -476($fp)
li $s1, 30
bgt $s2, $s1, label10
j label8# GOTO label8
label10 :
sw $s4, -472($fp)
lw $s4, -320($fp)
sw $s6, -480($fp)
li $s6, 0
bgt $s4, $s6, label7
j label8# GOTO label8
label7 :
sw $s5, -484($fp)
addi $t1, $fp, -84
move $s5, $t1# in process_expression: temp87 := &dataArray_
sw $s5, -520($fp)
lw $s5, -416($fp)
li $t8, 4
mul $s7, $s5, $t8# in handle_binary_op: temp88 := targetIdx_ * #4
sw $s7, -524($fp)
lw $s7, -524($fp)
sw $s3, -492($fp)
lw $s3, -520($fp)
sw $t9, -488($fp)
add $t9, $s7, $s3# in handle_binary_op: temp89 := temp88 + temp87
sw $t9, -528($fp)
lw $t9, -528($fp)
lw $s2, -408($fp)
sw $s2, 4($t9)# in process_expression: *temp89 = baseOut_
sw $t9, -528($fp)
j label9# GOTO label9
label8 :
addi $t1, $fp, -84
move $t9, $t1# in process_expression: temp90 := &dataArray_
sw $t9, -532($fp)
lw $s5, -416($fp)
li $t9, 4
sw $t2, -496($fp)
mul $t2, $s5, $t9# in handle_binary_op: temp91 := targetIdx_ * #4
sw $t2, -536($fp)
lw $t2, -536($fp)
sw $t0, -500($fp)
lw $t0, -532($fp)
add $t4, $t2, $t0# in handle_binary_op: temp92 := temp91 + temp90
sw $t4, -540($fp)
lw $t4, -436($fp)
li $t6, 2
sw $t5, -508($fp)
mul $t5, $t4, $t6# in handle_binary_op: temp93 := originalVal_ * #2
sw $t5, -544($fp)
lw $t5, -540($fp)
sw $t3, -504($fp)
lw $t3, -544($fp)
sw $t3, 4($t5)# in process_expression: *temp92 = temp93
sw $t5, -540($fp)
label9 :
addi $t1, $fp, -84
move $t5, $t1# in process_expression: temp94 := &dataArray_
sw $t5, -548($fp)
lw $s5, -416($fp)
li $t5, 4
sw $s0, -512($fp)
mul $s0, $s5, $t5# in handle_binary_op: temp95 := targetIdx_ * #4
sw $s0, -552($fp)
lw $s0, -552($fp)
sw $t7, -516($fp)
lw $t7, -548($fp)
add $s1, $s0, $t7# in handle_binary_op: temp96 := temp95 + temp94
sw $s1, -556($fp)
lw $s1, -556($fp)
sw $s4, -320($fp)
lw $s4, 4($s1)# in process_expression: temp97 := *temp96
sw $s4, -560($fp)
lw $s6, -560($fp)
move $s4, $s6# in process_expression: modifiedVal_ := temp97
sw $s4, -564($fp)
addi $t1, $fp, -84
move $s4, $t1# in process_expression: temp98 := &dataArray_
sw $s4, -568($fp)
li $s4, 0
li $t8, 4
sw $s7, -524($fp)
mul $s7, $s4, $t8# in handle_binary_op: temp99 := #0 * #4
sw $s7, -572($fp)
lw $s7, -572($fp)
sw $s3, -520($fp)
lw $s3, -568($fp)
sw $s2, -408($fp)
add $s2, $s7, $s3# in handle_binary_op: temp100 := temp99 + temp98
sw $s2, -576($fp)
lw $s2, -576($fp)
lw $t9, 4($s2)# in process_expression: temp101 := *temp100
sw $t9, -580($fp)
lw $t9, -580($fp)
move $a0, $t9# WRITE temp101: 将值移动到$a0
sw $ra, -584($fp)# WRITE temp101: 保存返回地址
jal write# WRITE temp101: 调用write函数
lw $ra, -584($fp)# WRITE temp101: 恢复返回地址
sw $t2, -536($fp)
addi $t1, $fp, -84
move $t2, $t1# in process_expression: temp102 := &dataArray_
sw $t2, -584($fp)
li $t2, 1
sw $t0, -532($fp)
li $t0, 4
sw $t4, -436($fp)
mul $t4, $t2, $t0# in handle_binary_op: temp103 := #1 * #4
sw $t4, -588($fp)
lw $t4, -588($fp)
lw $t6, -584($fp)
sw $t3, -544($fp)
add $t3, $t4, $t6# in handle_binary_op: temp104 := temp103 + temp102
sw $t3, -592($fp)
lw $t3, -592($fp)
sw $s5, -416($fp)
lw $s5, 4($t3)# in process_expression: temp105 := *temp104
sw $s5, -596($fp)
lw $s5, -596($fp)
move $a0, $s5# WRITE temp105: 将值移动到$a0
sw $ra, -600($fp)# WRITE temp105: 保存返回地址
jal write# WRITE temp105: 调用write函数
lw $ra, -600($fp)# WRITE temp105: 恢复返回地址
addi $t1, $fp, -84
move $t5, $t1# in process_expression: temp106 := &dataArray_
sw $t5, -600($fp)
li $t5, 2
sw $s0, -552($fp)
li $s0, 4
sw $t7, -548($fp)
mul $t7, $t5, $s0# in handle_binary_op: temp107 := #2 * #4
sw $t7, -604($fp)
lw $t7, -604($fp)
sw $s1, -556($fp)
lw $s1, -600($fp)
sw $s6, -560($fp)
add $s6, $t7, $s1# in handle_binary_op: temp108 := temp107 + temp106
sw $s6, -608($fp)
lw $s6, -608($fp)
lw $s4, 4($s6)# in process_expression: temp109 := *temp108
sw $s4, -612($fp)
lw $s4, -612($fp)
move $a0, $s4# WRITE temp109: 将值移动到$a0
sw $ra, -616($fp)# WRITE temp109: 保存返回地址
jal write# WRITE temp109: 调用write函数
lw $ra, -616($fp)# WRITE temp109: 恢复返回地址
addi $t1, $fp, -84
move $t8, $t1# in process_expression: temp110 := &dataArray_
sw $t8, -616($fp)
li $t8, 3
sw $s7, -572($fp)
li $s7, 4
sw $s3, -568($fp)
mul $s3, $t8, $s7# in handle_binary_op: temp111 := #3 * #4
sw $s3, -620($fp)
lw $s3, -620($fp)
sw $s2, -576($fp)
lw $s2, -616($fp)
sw $t9, -580($fp)
add $t9, $s3, $s2# in handle_binary_op: temp112 := temp111 + temp110
sw $t9, -624($fp)
lw $t9, -624($fp)
lw $t2, 4($t9)# in process_expression: temp113 := *temp112
sw $t2, -628($fp)
lw $t2, -628($fp)
move $a0, $t2# WRITE temp113: 将值移动到$a0
sw $ra, -632($fp)# WRITE temp113: 保存返回地址
jal write# WRITE temp113: 调用write函数
lw $ra, -632($fp)# WRITE temp113: 恢复返回地址
addi $t1, $fp, -84
move $t0, $t1# in process_expression: temp114 := &dataArray_
sw $t0, -632($fp)
li $t0, 4
sw $t4, -588($fp)
li $t4, 4
sw $t6, -584($fp)
mul $t6, $t0, $t4# in handle_binary_op: temp115 := #4 * #4
sw $t6, -636($fp)
lw $t6, -636($fp)
sw $t3, -592($fp)
lw $t3, -632($fp)
sw $s5, -596($fp)
add $s5, $t6, $t3# in handle_binary_op: temp116 := temp115 + temp114
sw $s5, -640($fp)
lw $s5, -640($fp)
lw $t5, 4($s5)# in process_expression: temp117 := *temp116
sw $t5, -644($fp)
lw $t5, -644($fp)
move $a0, $t5# WRITE temp117: 将值移动到$a0
sw $ra, -648($fp)# WRITE temp117: 保存返回地址
jal write# WRITE temp117: 调用write函数
lw $ra, -648($fp)# WRITE temp117: 恢复返回地址
lw $s0, -416($fp)
move $a0, $s0# WRITE targetIdx_: 将值移动到$a0
sw $ra, -648($fp)# WRITE targetIdx_: 保存返回地址
jal write# WRITE targetIdx_: 调用write函数
lw $ra, -648($fp)# WRITE targetIdx_: 恢复返回地址
sw $t7, -604($fp)
lw $t7, -436($fp)
move $a0, $t7# WRITE originalVal_: 将值移动到$a0
sw $ra, -648($fp)# WRITE originalVal_: 保存返回地址
jal write# WRITE originalVal_: 调用write函数
lw $ra, -648($fp)# WRITE originalVal_: 恢复返回地址
sw $s1, -600($fp)
lw $s1, -564($fp)
move $a0, $s1# WRITE modifiedVal_: 将值移动到$a0
sw $ra, -648($fp)# WRITE modifiedVal_: 保存返回地址
jal write# WRITE modifiedVal_: 调用write函数
lw $ra, -648($fp)# WRITE modifiedVal_: 恢复返回地址
sw $s6, -608($fp)
li $s6, 0
move $v0, $s6# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

