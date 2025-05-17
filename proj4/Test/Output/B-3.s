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
li $t3, 2# in get_operand_reg: load immediate 2
div $t0, $t3
mflo $t4# in handle_binary_op: temp0 := idxParam_ / #2 (get quotient)
sw $t4, -92($fp)
# in spill_variable: store temp0 to stack
lw $t4, -92($fp)
# in load_variable: load temp0 from stack
li $t5, 2# in get_operand_reg: load immediate 2
mul $t6, $t4, $t5# in handle_binary_op: temp1 := temp0 * #2
sw $t6, -96($fp)
# in spill_variable: store temp1 to stack
lw $t6, -96($fp)
# in load_variable: load temp1 from stack
beq $t6, $t0, label0
j label1# GOTO label1
label0 :
li $t7, 5# in get_operand_reg: load immediate 5
add $s0, $t0, $t7# in handle_binary_op: temp2 := idxParam_ + #5
sw $s0, -100($fp)
# in spill_variable: store temp2 to stack
lw $s1, -100($fp)
# in load_variable: load temp2 from stack
move $s0, $s1
j label2# GOTO label2
label1 :
li $s2, 3# in get_operand_reg: load immediate 3
mul $s3, $t0, $s2# in handle_binary_op: temp3 := idxParam_ * #3
sw $s3, -108($fp)
# in spill_variable: store temp3 to stack
lw $s3, -108($fp)
# in load_variable: load temp3 from stack
move $s0, $s3
label2 :
add $s4, $t1, $s0# in handle_binary_op: temp4 := oldValParam_ + valueModifier_
sw $s4, -112($fp)
# in spill_variable: store temp4 to stack
lw $s4, -112($fp)
# in load_variable: load temp4 from stack
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
li $s7, 50# in get_operand_reg: load immediate 50
bgt $s5, $s7, label5
j label4# GOTO label4
label5 :
li $t8, 5# in get_operand_reg: load immediate 5
blt $s6, $t8, label3
j label4# GOTO label4
label3 :
li $t9, 1# in get_operand_reg: load immediate 1
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
li $t2, 10# in get_operand_reg: load immediate 10
blt $s5, $t2, label8
j label7# GOTO label7
label8 :
li $t3, 0# in get_operand_reg: load immediate 0
bgt $s6, $t3, label6
j label7# GOTO label7
label6 :
li $t4, 1# in get_operand_reg: load immediate 1
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
li $t5, 0# in get_operand_reg: load immediate 0
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
li $t2, 0
li $t6, 0
move $t7, $s1
li $t0, 0# in get_operand_reg: load immediate 0
li $s2, 4# in get_operand_reg: load immediate 4
mul $s3, $t0, $s2# in handle_binary_op: temp6 := #0 * #4
sw $s3, -140($fp)
# in spill_variable: store temp6 to stack
lw $t0, -140($fp)
# in load_variable: load temp6 from stack
add $t1, $s3, $t4# in handle_binary_op: temp7 := temp6 + temp5
sw $t1, -144($fp)
# in spill_variable: store temp7 to stack
lw $t1, -144($fp)
# in load_variable: load *temp7 from stack
li $t1, 5
move $s0, $s1
li $s4, 1# in get_operand_reg: load immediate 1
li $s7, 4# in get_operand_reg: load immediate 4
mul $t8, $s4, $s7# in handle_binary_op: temp9 := #1 * #4
sw $s4, -152($fp)
# in spill_variable: store temp9 to stack
add $s4, $t8, $s0# in handle_binary_op: temp10 := temp9 + temp8
sw $s4, -156($fp)
# in spill_variable: store temp10 to stack
lw $s4, -156($fp)
# in load_variable: load *temp10 from stack
li $s4, 8
move $t9, $s1
li $s5, 2# in get_operand_reg: load immediate 2
li $s6, 4# in get_operand_reg: load immediate 4
mul $t3, $s5, $s6# in handle_binary_op: temp12 := #2 * #4
sw $t3, -164($fp)
# in spill_variable: store temp12 to stack
add $t3, $s6, $t9# in handle_binary_op: temp13 := temp12 + temp11
sw $t3, -168($fp)
# in spill_variable: store temp13 to stack
lw $t3, -168($fp)
# in load_variable: load *temp13 from stack
li $t3, 3
move $t5, $s1
li $t2, 3# in get_operand_reg: load immediate 3
li $t6, 4# in get_operand_reg: load immediate 4
mul $t7, $t2, $t6# in handle_binary_op: temp15 := #3 * #4
sw $t4, -124($fp)
# in spill_variable: store temp15 to stack
add $t4, $t7, $t5# in handle_binary_op: temp16 := temp15 + temp14
sw $t4, -124($fp)
# in spill_variable: store temp16 to stack
li $t4, 12
move $s2, $s1
li $s3, 4# in get_operand_reg: load immediate 4
li $t0, 4# in get_operand_reg: load immediate 4
mul $t1, $s3, $t0# in handle_binary_op: temp18 := #4 * #4
sw $t1, -184($fp)
# in spill_variable: store temp18 to stack
add $t1, $s3, $s2# in handle_binary_op: temp19 := temp18 + temp17
sw $t0, -188($fp)
# in spill_variable: store temp19 to stack
lw $t0, -188($fp)
# in load_variable: load *temp19 from stack
li $t0, 7
addi $sp, $sp, -4# READ temp20: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp20: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp20: 恢复返回地址
move $s7, $v0# READ temp20: 将返回值存储到temp20
move $t8, $s7
addi $sp, $sp, -4# READ temp21: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp21: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp21: 恢复返回地址
move $s0, $v0# READ temp21: 将返回值存储到temp21
move $s4, $s0
addi $sp, $sp, -4# READ temp22: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp22: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp22: 恢复返回地址
move $s5, $v0# READ temp22: 将返回值存储到temp22
move $s6, $s5
li $t9, 5# in get_operand_reg: load immediate 5
bgt $s6, $t9, label9
j label10# GOTO label10
label9 :
li $s6, 5
label10 :
li $t3, 0# in get_operand_reg: load immediate 0
blt $s6, $t3, label11
j label12# GOTO label12
label11 :
li $s6, 0
label12 :
label13 :
blt $t9, $s6, label14
j label15# GOTO label15
label14 :
move $t2, $s1
li $t6, 4# in get_operand_reg: load immediate 4
mul $t7, $t9, $t6# in handle_binary_op: temp24 := loopCounter_ * #4
sw $t3, -224($fp)
# in spill_variable: store temp24 to stack
add $t3, $t7, $t2# in handle_binary_op: temp25 := temp24 + temp23
sw $t3, -228($fp)
# in spill_variable: store temp25 to stack
move $t3, $s1
li $t5, 4# in get_operand_reg: load immediate 4
mul $t4, $t9, $t5# in handle_binary_op: temp27 := loopCounter_ * #4
sw $t2, -124($fp)
# in spill_variable: store temp27 to stack
add $t2, $t4, $t3# in handle_binary_op: temp28 := temp27 + temp26
sw $t2, -236($fp)
# in spill_variable: store temp28 to stack
lw $t2, 0($t5)
subu $sp, $sp, 4# ARG valueModifierIn_: 压栈参数
sw $t8, 0($sp)
subu $sp, $sp, 4# ARG temp29: 压栈参数
sw $t2, 0($sp)
subu $sp, $sp, 4# ARG loopCounter_: 压栈参数
sw $t9, 0($sp)
jal getNextValue# CALL getNextValue: 调用函数
move $s3, $v0# CALL getNextValue: 保存返回值
lw $s2, -228($fp)
# in load_variable: load *temp25 from stack
move $s2, $s3
move $t1, $s1
li $t0, 4# in get_operand_reg: load immediate 4
mul $s7, $t9, $t0# in handle_binary_op: temp32 := loopCounter_ * #4
sw $s7, -252($fp)
# in spill_variable: store temp32 to stack
lw $t0, -252($fp)
# in load_variable: load temp32 from stack
add $s4, $s7, $t1# in handle_binary_op: temp33 := temp32 + temp31
sw $s4, -256($fp)
# in spill_variable: store temp33 to stack
lw $s0, -256($fp)
# in load_variable: load temp33 from stack
lw $s4, 0($s0)
lw $s5, -204($fp)
# in load_variable: load complexCheckValIn_ from stack
subu $sp, $sp, 4# ARG complexCheckValIn_: 压栈参数
sw $s5, 0($sp)
subu $sp, $sp, 4# ARG temp34: 压栈参数
sw $s4, 0($sp)
jal checkComplexCondition# CALL checkComplexCondition: 调用函数
move $s6, $v0# CALL checkComplexCondition: 保存返回值
li $t6, 1# in get_operand_reg: load immediate 1
beq $s6, $t6, label16
j label17# GOTO label17
label16 :
lw $t7, -128($fp)
# in load_variable: load conditionMetCounter_ from stack
li $t4, 1# in get_operand_reg: load immediate 1
add $t3, $t7, $t4# in handle_binary_op: temp36 := conditionMetCounter_ + #1
sw $t3, -124($fp)
# in spill_variable: store temp36 to stack
lw $t3, -124($fp)
# in load_variable: load temp36 from stack
move $t6, $t3
label17 :
li $t5, 1# in get_operand_reg: load immediate 1
add $t8, $t9, $t5# in handle_binary_op: temp37 := loopCounter_ + #1
sw $t8, -268($fp)
# in spill_variable: store temp37 to stack
lw $t5, -268($fp)
# in load_variable: load temp37 from stack
move $t9, $t8
j label13# GOTO label13
label15 :
move $t2, $s1
li $s2, 0# in get_operand_reg: load immediate 0
li $s3, 4# in get_operand_reg: load immediate 4
mul $s7, $s2, $s3# in handle_binary_op: temp39 := #0 * #4
sw $s7, -184($fp)
# in spill_variable: store temp39 to stack
lw $s3, -184($fp)
# in load_variable: load temp39 from stack
add $t0, $s7, $t2# in handle_binary_op: temp40 := temp39 + temp38
sw $t0, -276($fp)
# in spill_variable: store temp40 to stack
lw $t1, -276($fp)
# in load_variable: load temp40 from stack
lw $t0, 0($t1)
move $a0, $t0# WRITE temp41: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp41: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp41: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp41: 恢复返回地址
lw $s0, -212($fp)
# in load_variable: load loopExecLimit_ from stack
li $s5, 0# in get_operand_reg: load immediate 0
bgt $s0, $s5, label18
j label19# GOTO label19
label18 :
move $s4, $s1
li $s6, 1# in get_operand_reg: load immediate 1
sub $t7, $s0, $s6# in handle_binary_op: temp43 := loopExecLimit_ - #1
sw $t6, -288($fp)
# in spill_variable: store temp43 to stack
li $t6, 4# in get_operand_reg: load immediate 4
mul $t4, $t7, $t6# in handle_binary_op: temp44 := temp43 * #4
sw $t4, -124($fp)
# in spill_variable: store temp44 to stack
lw $t4, -124($fp)
# in load_variable: load temp44 from stack
add $t3, $t4, $s4# in handle_binary_op: temp45 := temp44 + temp42
sw $t3, -292($fp)
# in spill_variable: store temp45 to stack
lw $t9, -292($fp)
# in load_variable: load temp45 from stack
lw $t3, 0($t9)
move $a0, $t3# WRITE temp46: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp46: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp46: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp46: 恢复返回地址
j label20# GOTO label20
label19 :
move $t8, $s1
li $t5, 0# in get_operand_reg: load immediate 0
li $s2, 4# in get_operand_reg: load immediate 4
mul $s7, $t5, $s2# in handle_binary_op: temp48 := #0 * #4
sw $s7, -184($fp)
# in spill_variable: store temp48 to stack
lw $s2, -184($fp)
# in load_variable: load temp48 from stack
add $s3, $s7, $t8# in handle_binary_op: temp49 := temp48 + temp47
sw $s3, -304($fp)
# in spill_variable: store temp49 to stack
lw $s3, 0($s7)
move $a0, $s3# WRITE temp50: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp50: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp50: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp50: 恢复返回地址
label20 :
lw $t2, -128($fp)
# in load_variable: load conditionMetCounter_ from stack
move $a0, $t2# WRITE conditionMetCounter_: 将值移动到$a0
subu $sp, $sp, 4# WRITE conditionMetCounter_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE conditionMetCounter_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE conditionMetCounter_: 恢复返回地址
move $a0, $t1# WRITE loopCounter_: 将值移动到$a0
subu $sp, $sp, 4# WRITE loopCounter_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE loopCounter_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE loopCounter_: 恢复返回地址
li $t0, 0# in get_operand_reg: load immediate 0
move $v0, $t0# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

