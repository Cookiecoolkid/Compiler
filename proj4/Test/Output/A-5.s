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

processHelper:
subu $sp, $sp, 80# FUNCTION processHelper: 分配栈帧
sw $fp, 76($sp)# FUNCTION processHelper: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION processHelper: 保存返回地址
addiu $fp, $sp, 80# FUNCTION processHelper: 设置新的帧指针
sw $t0, -12($fp)# FUNCTION processHelper: 保存寄存器 $t0
sw $t1, -16($fp)# FUNCTION processHelper: 保存寄存器 $t1
sw $t2, -20($fp)# FUNCTION processHelper: 保存寄存器 $t2
sw $t3, -24($fp)# FUNCTION processHelper: 保存寄存器 $t3
sw $t4, -28($fp)# FUNCTION processHelper: 保存寄存器 $t4
sw $t5, -32($fp)# FUNCTION processHelper: 保存寄存器 $t5
sw $t6, -36($fp)# FUNCTION processHelper: 保存寄存器 $t6
sw $t7, -40($fp)# FUNCTION processHelper: 保存寄存器 $t7
sw $s0, -44($fp)# FUNCTION processHelper: 保存寄存器 $s0
sw $s1, -48($fp)# FUNCTION processHelper: 保存寄存器 $s1
sw $s2, -52($fp)# FUNCTION processHelper: 保存寄存器 $s2
sw $s3, -56($fp)# FUNCTION processHelper: 保存寄存器 $s3
sw $s4, -60($fp)# FUNCTION processHelper: 保存寄存器 $s4
sw $s5, -64($fp)# FUNCTION processHelper: 保存寄存器 $s5
sw $s6, -68($fp)# FUNCTION processHelper: 保存寄存器 $s6
sw $s7, -72($fp)# FUNCTION processHelper: 保存寄存器 $s7
sw $t8, -76($fp)# FUNCTION processHelper: 保存寄存器 $t8
sw $t9, -80($fp)# FUNCTION processHelper: 保存寄存器 $t9
lw $t0, 0($fp)# PARAM val_: 读取第1个参数
li $t1, 0# in get_operand_reg: load immediate 0
blt $t0, $t1, label0
j label1# GOTO label1
label0 :
li $t2, 2# in get_operand_reg: load immediate 2
mul $t3, $t0, $t2# in handle_binary_op: temp0 := val_ * #2
sw $t3, -84($fp)
# in spill_variable: store temp0 to stack
lw $t3, -84($fp)
# in load_variable: load temp0 from stack
move $v0, $t3# RETURN temp0: 设置返回值
lw $t9, -80($fp)# RETURN temp0: 恢复寄存器$t9
lw $t8, -76($fp)# RETURN temp0: 恢复寄存器$t8
lw $s7, -72($fp)# RETURN temp0: 恢复寄存器$s7
lw $s6, -68($fp)# RETURN temp0: 恢复寄存器$s6
lw $s5, -64($fp)# RETURN temp0: 恢复寄存器$s5
lw $s4, -60($fp)# RETURN temp0: 恢复寄存器$s4
lw $s3, -56($fp)# RETURN temp0: 恢复寄存器$s3
lw $s2, -52($fp)# RETURN temp0: 恢复寄存器$s2
lw $s1, -48($fp)# RETURN temp0: 恢复寄存器$s1
lw $s0, -44($fp)# RETURN temp0: 恢复寄存器$s0
lw $t7, -40($fp)# RETURN temp0: 恢复寄存器$t7
lw $t6, -36($fp)# RETURN temp0: 恢复寄存器$t6
lw $t5, -32($fp)# RETURN temp0: 恢复寄存器$t5
lw $t4, -28($fp)# RETURN temp0: 恢复寄存器$t4
lw $t3, -24($fp)# RETURN temp0: 恢复寄存器$t3
lw $t2, -20($fp)# RETURN temp0: 恢复寄存器$t2
lw $t1, -16($fp)# RETURN temp0: 恢复寄存器$t1
lw $t0, -12($fp)# RETURN temp0: 恢复寄存器$t0
lw $ra, -8($fp)# RETURN temp0: 恢复返回地址
lw $fp, -4($fp)# RETURN temp0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

label1 :
li $t4, 10# in get_operand_reg: load immediate 10
add $t5, $t0, $t4# in handle_binary_op: temp1 := val_ + #10
sw $t5, -88($fp)
# in spill_variable: store temp1 to stack
lw $t5, -88($fp)
# in load_variable: load temp1 from stack
move $v0, $t5# RETURN temp1: 设置返回值
lw $t9, -80($fp)# RETURN temp1: 恢复寄存器$t9
lw $t8, -76($fp)# RETURN temp1: 恢复寄存器$t8
lw $s7, -72($fp)# RETURN temp1: 恢复寄存器$s7
lw $s6, -68($fp)# RETURN temp1: 恢复寄存器$s6
lw $s5, -64($fp)# RETURN temp1: 恢复寄存器$s5
lw $s4, -60($fp)# RETURN temp1: 恢复寄存器$s4
lw $s3, -56($fp)# RETURN temp1: 恢复寄存器$s3
lw $s2, -52($fp)# RETURN temp1: 恢复寄存器$s2
lw $s1, -48($fp)# RETURN temp1: 恢复寄存器$s1
lw $s0, -44($fp)# RETURN temp1: 恢复寄存器$s0
lw $t7, -40($fp)# RETURN temp1: 恢复寄存器$t7
lw $t6, -36($fp)# RETURN temp1: 恢复寄存器$t6
lw $t5, -32($fp)# RETURN temp1: 恢复寄存器$t5
lw $t4, -28($fp)# RETURN temp1: 恢复寄存器$t4
lw $t3, -24($fp)# RETURN temp1: 恢复寄存器$t3
lw $t2, -20($fp)# RETURN temp1: 恢复寄存器$t2
lw $t1, -16($fp)# RETURN temp1: 恢复寄存器$t1
lw $t0, -12($fp)# RETURN temp1: 恢复寄存器$t0
lw $ra, -8($fp)# RETURN temp1: 恢复返回地址
lw $fp, -4($fp)# RETURN temp1: 恢复帧指针
addi $sp, $sp, 80
jr $ra

recursiveWithHelperCall:
subu $sp, $sp, 80# FUNCTION recursiveWithHelperCall: 分配栈帧
sw $fp, 76($sp)# FUNCTION recursiveWithHelperCall: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION recursiveWithHelperCall: 保存返回地址
addiu $fp, $sp, 80# FUNCTION recursiveWithHelperCall: 设置新的帧指针
sw $t0, -12($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $t0
sw $t1, -16($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $t1
sw $t2, -20($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $t2
sw $t3, -24($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $t3
sw $t4, -28($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $t4
sw $t5, -32($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $t5
sw $t6, -36($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $t6
sw $t7, -40($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $t7
sw $s0, -44($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $s0
sw $s1, -48($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $s1
sw $s2, -52($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $s2
sw $s3, -56($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $s3
sw $s4, -60($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $s4
sw $s5, -64($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $s5
sw $s6, -68($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $s6
sw $s7, -72($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $s7
sw $t8, -76($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $t8
sw $t9, -80($fp)# FUNCTION recursiveWithHelperCall: 保存寄存器 $t9
lw $t6, -4($fp)# PARAM n_: 读取第2个参数
li $t7, 0# in get_operand_reg: load immediate 0
ble $t6, $t7, label2
j label3# GOTO label3
label2 :
li $s0, 0# in get_operand_reg: load immediate 0
move $v0, $s0# RETURN #0: 设置返回值
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

j label4# GOTO label4
label3 :
subu $sp, $sp, 4# ARG n_: 压栈参数
sw $t6, 0($sp)
jal processHelper# CALL processHelper: 调用函数
move $s1, $v0# CALL processHelper: 保存返回值
move $s2, $s1
li $s3, 2# in get_operand_reg: load immediate 2
sub $s4, $t6, $s3# in handle_binary_op: temp3 := n_ - #2
sw $s4, -104($fp)
# in spill_variable: store temp3 to stack
lw $s4, -104($fp)
# in load_variable: load temp3 from stack
subu $sp, $sp, 4# ARG temp3: 压栈参数
sw $s4, 0($sp)
jal recursiveWithHelperCall# CALL recursiveWithHelperCall: 调用函数
move $s5, $v0# CALL recursiveWithHelperCall: 保存返回值
move $s6, $s5
add $s7, $s2, $s6# in handle_binary_op: temp5 := helperVal_ + recursiveVal_
sw $s7, -116($fp)
# in spill_variable: store temp5 to stack
lw $s7, -116($fp)
# in load_variable: load temp5 from stack
move $v0, $s7# RETURN temp5: 设置返回值
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

label4 :
main:
subu $sp, $sp, 80# FUNCTION main: 分配栈帧
sw $fp, 76($sp)# FUNCTION main: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION main: 保存返回地址
addiu $fp, $sp, 80# FUNCTION main: 设置新的帧指针
addi $sp, $sp, -4# READ temp6: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp6: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp6: 恢复返回地址
move $t8, $v0# READ temp6: 将返回值存储到temp6
move $t9, $t8
subu $sp, $sp, 4# ARG input_: 压栈参数
sw $t9, 0($sp)
jal recursiveWithHelperCall# CALL recursiveWithHelperCall: 调用函数
move $t1, $v0# CALL recursiveWithHelperCall: 保存返回值
move $t2, $t1
move $a0, $t2# WRITE finalResult_: 将值移动到$a0
subu $sp, $sp, 4# WRITE finalResult_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE finalResult_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE finalResult_: 恢复返回地址
li $t3, 0# in get_operand_reg: load immediate 0
move $v0, $t3# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

