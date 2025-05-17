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
# in spill_variable: store temp0 to stack
lw $t2, -88($fp)
# in load_variable: load temp0 from stack
li $t3, 1# in get_operand_reg: load immediate 1
sub $t4, $t2, $t3# in handle_binary_op: temp1 := temp0 - #1
sw $t4, -92($fp)
# in spill_variable: store temp1 to stack
lw $t5, -92($fp)
# in load_variable: load temp1 from stack
move $t4, $t5
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
li $t6, 5
li $t7, 0
li $s0, 0
label0 :
blt $t7, $t6, label1
j label2# GOTO label2
label1 :
move $s1, $s2
li $s3, 4# in get_operand_reg: load immediate 4
mul $s4, $t7, $s3# in handle_binary_op: temp3 := outerIdx_ * #4
sw $s4, -120($fp)
# in spill_variable: store temp3 to stack
lw $s4, -120($fp)
# in load_variable: load temp3 from stack
add $s5, $s4, $s1# in handle_binary_op: temp4 := temp3 + temp2
sw $s5, -124($fp)
# in spill_variable: store temp4 to stack
addi $sp, $sp, -4# READ temp5: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp5: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp5: 恢复返回地址
move $s5, $v0# READ temp5: 将返回值存储到temp5
lw $s6, -124($fp)
# in load_variable: load *temp4 from stack
move $s6, $s5
li $s7, 1# in get_operand_reg: load immediate 1
add $t8, $t7, $s7# in handle_binary_op: temp6 := outerIdx_ + #1
sw $t8, -132($fp)
# in spill_variable: store temp6 to stack
lw $t8, -132($fp)
# in load_variable: load temp6 from stack
move $t7, $t8
j label0# GOTO label0
label2 :
li $t7, 0
li $t9, 1# in get_operand_reg: load immediate 1
sub $t0, $t6, $t9# in handle_binary_op: temp7 := arrayDataSize_ - #1
sw $t0, -136($fp)
# in spill_variable: store temp7 to stack
lw $t1, -136($fp)
# in load_variable: load temp7 from stack
move $t0, $t1
label3 :
blt $t7, $t0, label4
j label5# GOTO label5
label4 :
li $s0, 0
subu $sp, $sp, 4# ARG outerIdx_: 压栈参数
sw $t7, 0($sp)
subu $sp, $sp, 4# ARG arrayDataSize_: 压栈参数
sw $t6, 0($sp)
jal calculateInnerLoopLimit# CALL calculateInnerLoopLimit: 调用函数
move $t2, $v0# CALL calculateInnerLoopLimit: 保存返回值
move $t3, $t2
label6 :
blt $s0, $t3, label7
j label8# GOTO label8
label7 :
move $t5, $s2
li $t4, 4# in get_operand_reg: load immediate 4
mul $s3, $s0, $t4# in handle_binary_op: temp10 := innerIdx_ * #4
sw $t4, -156($fp)
# in spill_variable: store temp10 to stack
add $t4, $s3, $t5# in handle_binary_op: temp11 := temp10 + temp9
sw $t4, -160($fp)
# in spill_variable: store temp11 to stack
lw $s4, -160($fp)
# in load_variable: load temp11 from stack
lw $t4, 0($s4)
move $s1, $s2
li $s6, 1# in get_operand_reg: load immediate 1
add $s5, $s0, $s6# in handle_binary_op: temp14 := innerIdx_ + #1
sw $s5, -172($fp)
# in spill_variable: store temp14 to stack
lw $s5, -172($fp)
# in load_variable: load temp14 from stack
li $s7, 4# in get_operand_reg: load immediate 4
mul $t8, $s5, $s7# in handle_binary_op: temp15 := temp14 * #4
sw $t8, -176($fp)
# in spill_variable: store temp15 to stack
lw $t8, -176($fp)
# in load_variable: load temp15 from stack
add $t9, $t8, $s1# in handle_binary_op: temp16 := temp15 + temp13
sw $t9, -180($fp)
# in spill_variable: store temp16 to stack
lw $t1, -180($fp)
# in load_variable: load temp16 from stack
lw $t9, 0($t1)
bgt $t4, $t9, label9
j label10# GOTO label10
label9 :
move $t0, $s2
li $t7, 4# in get_operand_reg: load immediate 4
mul $t6, $s0, $t7# in handle_binary_op: temp19 := innerIdx_ * #4
sw $t6, -192($fp)
# in spill_variable: store temp19 to stack
lw $t6, -192($fp)
# in load_variable: load temp19 from stack
add $t2, $t6, $t0# in handle_binary_op: temp20 := temp19 + temp18
sw $t2, -196($fp)
# in spill_variable: store temp20 to stack
lw $t3, -196($fp)
# in load_variable: load temp20 from stack
lw $t2, 0($t3)
move $s3, $t2
move $t5, $s2
li $s4, 4# in get_operand_reg: load immediate 4
mul $s6, $s0, $s4# in handle_binary_op: temp23 := innerIdx_ * #4
sw $s6, -212($fp)
# in spill_variable: store temp23 to stack
lw $s4, -212($fp)
# in load_variable: load temp23 from stack
add $s5, $s6, $t5# in handle_binary_op: temp24 := temp23 + temp22
sw $s5, -216($fp)
# in spill_variable: store temp24 to stack
move $s5, $s2
li $s7, 1# in get_operand_reg: load immediate 1
add $t8, $s0, $s7# in handle_binary_op: temp26 := innerIdx_ + #1
sw $t8, -224($fp)
# in spill_variable: store temp26 to stack
lw $t8, -224($fp)
# in load_variable: load temp26 from stack
li $s1, 4# in get_operand_reg: load immediate 4
mul $t1, $t8, $s1# in handle_binary_op: temp27 := temp26 * #4
sw $t1, -228($fp)
# in spill_variable: store temp27 to stack
lw $t1, -228($fp)
# in load_variable: load temp27 from stack
add $t4, $t1, $s5# in handle_binary_op: temp28 := temp27 + temp25
sw $t4, -232($fp)
# in spill_variable: store temp28 to stack
lw $t9, -232($fp)
# in load_variable: load temp28 from stack
lw $t4, 0($t9)
lw $t7, -216($fp)
# in load_variable: load *temp24 from stack
move $t7, $t4
move $t6, $s2
li $t0, 1# in get_operand_reg: load immediate 1
add $t3, $s0, $t0# in handle_binary_op: temp31 := innerIdx_ + #1
sw $t3, -244($fp)
# in spill_variable: store temp31 to stack
lw $t0, -244($fp)
# in load_variable: load temp31 from stack
li $s3, 4# in get_operand_reg: load immediate 4
mul $t2, $t3, $s3# in handle_binary_op: temp32 := temp31 * #4
sw $t2, -248($fp)
# in spill_variable: store temp32 to stack
lw $t2, -248($fp)
# in load_variable: load temp32 from stack
add $s6, $t2, $t6# in handle_binary_op: temp33 := temp32 + temp30
sw $s6, -252($fp)
# in spill_variable: store temp33 to stack
lw $s6, -252($fp)
# in load_variable: load *temp33 from stack
lw $s4, -204($fp)
# in load_variable: load swapHolder_ from stack
move $s6, $s4
label10 :
li $t5, 1# in get_operand_reg: load immediate 1
add $s7, $s0, $t5# in handle_binary_op: temp34 := innerIdx_ + #1
sw $t5, -256($fp)
# in spill_variable: store temp34 to stack
move $s0, $s7
j label6# GOTO label6
label8 :
lw $t5, -104($fp)
# in load_variable: load outerIdx_ from stack
li $t8, 1# in get_operand_reg: load immediate 1
add $s1, $t5, $t8# in handle_binary_op: temp35 := outerIdx_ + #1
sw $s1, -260($fp)
# in spill_variable: store temp35 to stack
lw $s1, -260($fp)
# in load_variable: load temp35 from stack
move $t5, $s1
j label3# GOTO label3
label5 :
li $t5, 0
label11 :
lw $t1, -100($fp)
# in load_variable: load arrayDataSize_ from stack
blt $t5, $t1, label12
j label13# GOTO label13
label12 :
move $s5, $s2
li $t9, 4# in get_operand_reg: load immediate 4
mul $t7, $t5, $t9# in handle_binary_op: temp37 := outerIdx_ * #4
sw $t7, -268($fp)
# in spill_variable: store temp37 to stack
lw $t7, -268($fp)
# in load_variable: load temp37 from stack
add $t4, $t7, $s5# in handle_binary_op: temp38 := temp37 + temp36
sw $t4, -272($fp)
# in spill_variable: store temp38 to stack
lw $t3, -272($fp)
# in load_variable: load temp38 from stack
lw $t4, 0($t3)
move $a0, $t4# WRITE temp39: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp39: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp39: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp39: 恢复返回地址
li $t0, 1# in get_operand_reg: load immediate 1
add $s3, $t5, $t0# in handle_binary_op: temp40 := outerIdx_ + #1
sw $s3, -280($fp)
# in spill_variable: store temp40 to stack
lw $t0, -280($fp)
# in load_variable: load temp40 from stack
move $t5, $s3
j label11# GOTO label11
label13 :
li $t2, 0# in get_operand_reg: load immediate 0
move $v0, $t2# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

