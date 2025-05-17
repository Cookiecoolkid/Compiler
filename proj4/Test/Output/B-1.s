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
li $t1, 50# in get_operand_reg: load immediate 50
bgt $t0, $t1, label0
j label1# GOTO label1
label0 :
li $t2, 2# in get_operand_reg: load immediate 2
div $t0, $t2
mflo $t3# in handle_binary_op: temp0 := inputParam_ / #2 (get quotient)
sw $t3, -84($fp)
# in spill_variable: store temp0 to stack
lw $t4, -84($fp)
# in load_variable: load temp0 from stack
move $t3, $t4
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
li $t5, 10# in get_operand_reg: load immediate 10
add $t6, $t0, $t5# in handle_binary_op: temp1 := inputParam_ + #10
sw $t6, -92($fp)
# in spill_variable: store temp1 to stack
lw $t6, -92($fp)
# in load_variable: load temp1 from stack
move $t3, $t6
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
sw $s1, -104($fp)
# in spill_variable: store temp2 to stack
lw $s1, -104($fp)
# in load_variable: load temp2 from stack
li $s2, 5# in get_operand_reg: load immediate 5
div $s1, $s2
mflo $s3# in handle_binary_op: temp3 := temp2 / #5 (get quotient)
sw $s3, -108($fp)
# in spill_variable: store temp3 to stack
lw $s4, -108($fp)
# in load_variable: load temp3 from stack
move $s3, $s4
li $s5, 0# in get_operand_reg: load immediate 0
blt $s3, $s5, label3
j label4# GOTO label4
label3 :
li $s6, 0# in get_operand_reg: load immediate 0
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
li $s7, 4# in get_operand_reg: load immediate 4
bgt $s3, $s7, label5
j label6# GOTO label6
label5 :
li $t8, 4# in get_operand_reg: load immediate 4
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
move $t9, $t1
li $t2, 0# in get_operand_reg: load immediate 0
li $t4, 4# in get_operand_reg: load immediate 4
mul $t0, $t2, $t4# in handle_binary_op: temp5 := #0 * #4
sw $t0, -124($fp)
# in spill_variable: store temp5 to stack
lw $t0, -124($fp)
# in load_variable: load temp5 from stack
add $t5, $t0, $t9# in handle_binary_op: temp6 := temp5 + temp4
sw $t5, -128($fp)
# in spill_variable: store temp6 to stack
lw $t5, -128($fp)
# in load_variable: load *temp6 from stack
li $t5, 1
move $t6, $t1
li $t3, 1# in get_operand_reg: load immediate 1
li $t7, 4# in get_operand_reg: load immediate 4
mul $s0, $t3, $t7# in handle_binary_op: temp8 := #1 * #4
sw $t3, -136($fp)
# in spill_variable: store temp8 to stack
add $t3, $s0, $t6# in handle_binary_op: temp9 := temp8 + temp7
sw $t3, -140($fp)
# in spill_variable: store temp9 to stack
lw $t3, -140($fp)
# in load_variable: load *temp9 from stack
li $t3, 2
move $s1, $t1
li $s2, 2# in get_operand_reg: load immediate 2
li $s4, 4# in get_operand_reg: load immediate 4
mul $s5, $s2, $s4# in handle_binary_op: temp11 := #2 * #4
sw $s4, -148($fp)
# in spill_variable: store temp11 to stack
add $s4, $s5, $s1# in handle_binary_op: temp12 := temp11 + temp10
sw $s4, -152($fp)
# in spill_variable: store temp12 to stack
lw $s4, -152($fp)
# in load_variable: load *temp12 from stack
li $s4, 3
move $s6, $t1
li $s7, 3# in get_operand_reg: load immediate 3
li $t8, 4# in get_operand_reg: load immediate 4
mul $s3, $s7, $t8# in handle_binary_op: temp14 := #3 * #4
sw $s3, -160($fp)
# in spill_variable: store temp14 to stack
lw $s3, -160($fp)
# in load_variable: load temp14 from stack
add $t2, $s3, $s6# in handle_binary_op: temp15 := temp14 + temp13
sw $t2, -164($fp)
# in spill_variable: store temp15 to stack
lw $t2, -164($fp)
# in load_variable: load *temp15 from stack
li $t2, 4
move $t4, $t1
li $t0, 4# in get_operand_reg: load immediate 4
li $t9, 4# in get_operand_reg: load immediate 4
mul $t5, $t0, $t9# in handle_binary_op: temp17 := #4 * #4
sw $t0, -172($fp)
# in spill_variable: store temp17 to stack
add $t0, $t5, $t4# in handle_binary_op: temp18 := temp17 + temp16
sw $t0, -176($fp)
# in spill_variable: store temp18 to stack
lw $t0, -176($fp)
# in load_variable: load *temp18 from stack
li $t0, 5
addi $sp, $sp, -4# READ temp19: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp19: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp19: 恢复返回地址
move $t7, $v0# READ temp19: 将返回值存储到temp19
move $s0, $t7
addi $sp, $sp, -4# READ temp20: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp20: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp20: 恢复返回地址
move $t6, $v0# READ temp20: 将返回值存储到temp20
move $t3, $t6
subu $sp, $sp, 4# ARG val1_: 压栈参数
sw $s0, 0($sp)
jal calculateBase# CALL calculateBase: 调用函数
move $s2, $v0# CALL calculateBase: 保存返回值
move $s5, $s2
subu $sp, $sp, 4# ARG val2_: 压栈参数
sw $t3, 0($sp)
subu $sp, $sp, 4# ARG baseOut_: 压栈参数
sw $s5, 0($sp)
jal determineIndex# CALL determineIndex: 调用函数
move $s1, $v0# CALL determineIndex: 保存返回值
move $s4, $s1
move $s7, $t1
li $t8, 4# in get_operand_reg: load immediate 4
mul $s3, $s4, $t8# in handle_binary_op: temp24 := targetIdx_ * #4
sw $s3, -216($fp)
# in spill_variable: store temp24 to stack
lw $s3, -216($fp)
# in load_variable: load temp24 from stack
add $s6, $s3, $s7# in handle_binary_op: temp25 := temp24 + temp23
sw $s6, -220($fp)
# in spill_variable: store temp25 to stack
lw $t2, -220($fp)
# in load_variable: load temp25 from stack
lw $s6, 0($t2)
move $t9, $s6
li $t5, 30# in get_operand_reg: load immediate 30
bgt $s5, $t5, label10
j label8# GOTO label8
label10 :
li $t4, 0# in get_operand_reg: load immediate 0
bgt $t3, $t4, label7
j label8# GOTO label8
label7 :
move $t5, $t1
li $t0, 4# in get_operand_reg: load immediate 4
mul $t7, $s4, $t0# in handle_binary_op: temp28 := targetIdx_ * #4
sw $t4, -236($fp)
# in spill_variable: store temp28 to stack
add $t4, $t7, $t5# in handle_binary_op: temp29 := temp28 + temp27
sw $t0, -240($fp)
# in spill_variable: store temp29 to stack
lw $t0, -240($fp)
# in load_variable: load *temp29 from stack
move $t0, $s5
j label9# GOTO label9
label8 :
move $t6, $t1
li $s0, 4# in get_operand_reg: load immediate 4
mul $s2, $s4, $s0# in handle_binary_op: temp31 := targetIdx_ * #4
sw $s2, -248($fp)
# in spill_variable: store temp31 to stack
lw $s0, -248($fp)
# in load_variable: load temp31 from stack
add $s1, $s2, $t6# in handle_binary_op: temp32 := temp31 + temp30
sw $s1, -252($fp)
# in spill_variable: store temp32 to stack
li $s1, 2# in get_operand_reg: load immediate 2
mul $t8, $t9, $s1# in handle_binary_op: temp33 := originalVal_ * #2
sw $t8, -256($fp)
# in spill_variable: store temp33 to stack
lw $t8, -252($fp)
# in load_variable: load *temp32 from stack
lw $s3, -256($fp)
# in load_variable: load temp33 from stack
move $t8, $s3
label9 :
move $s7, $t1
li $t2, 4# in get_operand_reg: load immediate 4
mul $s6, $s4, $t2# in handle_binary_op: temp35 := targetIdx_ * #4
sw $s6, -264($fp)
# in spill_variable: store temp35 to stack
lw $t2, -264($fp)
# in load_variable: load temp35 from stack
add $t3, $s6, $s7# in handle_binary_op: temp36 := temp35 + temp34
sw $t3, -268($fp)
# in spill_variable: store temp36 to stack
lw $t7, -268($fp)
# in load_variable: load temp36 from stack
lw $t3, 0($t7)
move $t5, $t3
move $a0, $s4# WRITE targetIdx_: 将值移动到$a0
subu $sp, $sp, 4# WRITE targetIdx_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE targetIdx_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE targetIdx_: 恢复返回地址
move $a0, $t9# WRITE originalVal_: 将值移动到$a0
subu $sp, $sp, 4# WRITE originalVal_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE originalVal_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE originalVal_: 恢复返回地址
move $a0, $t5# WRITE modifiedVal_: 将值移动到$a0
subu $sp, $sp, 4# WRITE modifiedVal_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE modifiedVal_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE modifiedVal_: 恢复返回地址
li $t4, 0# in get_operand_reg: load immediate 0
move $v0, $t4# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

