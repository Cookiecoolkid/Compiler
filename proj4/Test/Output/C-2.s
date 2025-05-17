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

isDivisibleBy:
subu $sp, $sp, 80# FUNCTION isDivisibleBy: 分配栈帧
sw $fp, 76($sp)# FUNCTION isDivisibleBy: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION isDivisibleBy: 保存返回地址
addiu $fp, $sp, 80# FUNCTION isDivisibleBy: 设置新的帧指针
sw $t0, -12($fp)# FUNCTION isDivisibleBy: 保存寄存器 $t0
sw $t1, -16($fp)# FUNCTION isDivisibleBy: 保存寄存器 $t1
sw $t2, -20($fp)# FUNCTION isDivisibleBy: 保存寄存器 $t2
sw $t3, -24($fp)# FUNCTION isDivisibleBy: 保存寄存器 $t3
sw $t4, -28($fp)# FUNCTION isDivisibleBy: 保存寄存器 $t4
sw $t5, -32($fp)# FUNCTION isDivisibleBy: 保存寄存器 $t5
sw $t6, -36($fp)# FUNCTION isDivisibleBy: 保存寄存器 $t6
sw $t7, -40($fp)# FUNCTION isDivisibleBy: 保存寄存器 $t7
sw $s0, -44($fp)# FUNCTION isDivisibleBy: 保存寄存器 $s0
sw $s1, -48($fp)# FUNCTION isDivisibleBy: 保存寄存器 $s1
sw $s2, -52($fp)# FUNCTION isDivisibleBy: 保存寄存器 $s2
sw $s3, -56($fp)# FUNCTION isDivisibleBy: 保存寄存器 $s3
sw $s4, -60($fp)# FUNCTION isDivisibleBy: 保存寄存器 $s4
sw $s5, -64($fp)# FUNCTION isDivisibleBy: 保存寄存器 $s5
sw $s6, -68($fp)# FUNCTION isDivisibleBy: 保存寄存器 $s6
sw $s7, -72($fp)# FUNCTION isDivisibleBy: 保存寄存器 $s7
sw $t8, -76($fp)# FUNCTION isDivisibleBy: 保存寄存器 $t8
sw $t9, -80($fp)# FUNCTION isDivisibleBy: 保存寄存器 $t9
lw $t0, 0($fp)# PARAM numParam_: 读取第1个参数
lw $t1, -4($fp)# PARAM divisorParam_: 读取第2个参数
li $t2, 0
ble $t1, $t2, label0
j label1# GOTO label1
label0 :
li $t3, 0
move $v0, $t3# RETURN #0: 设置返回值
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

label1 :
li $t4, 1
beq $t1, $t4, label2
j label3# GOTO label3
label2 :
li $t5, 1
move $v0, $t5# RETURN #1: 设置返回值
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

label3 :
div $t0, $t1
mflo $t6# in handle_binary_op: temp0 := numParam_ / divisorParam_ (get quotient)
sw $t6, -88($fp)
lw $t7, -88($fp)
move $t6, $t7# in process_expression: quotient_ := temp0
mul $s0, $t6, $t1# in handle_binary_op: temp1 := quotient_ * divisorParam_
sw $s0, -96($fp)
lw $s0, -96($fp)
beq $s0, $t0, label4
j label5# GOTO label5
label4 :
li $s1, 1
move $v0, $s1# RETURN #1: 设置返回值
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

j label6# GOTO label6
label5 :
li $s2, 0
move $v0, $s2# RETURN #0: 设置返回值
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

label6 :
isPrimeFunc:
subu $sp, $sp, 80# FUNCTION isPrimeFunc: 分配栈帧
sw $fp, 76($sp)# FUNCTION isPrimeFunc: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION isPrimeFunc: 保存返回地址
addiu $fp, $sp, 80# FUNCTION isPrimeFunc: 设置新的帧指针
sw $t0, -12($fp)# FUNCTION isPrimeFunc: 保存寄存器 $t0
sw $t1, -16($fp)# FUNCTION isPrimeFunc: 保存寄存器 $t1
sw $t2, -20($fp)# FUNCTION isPrimeFunc: 保存寄存器 $t2
sw $t3, -24($fp)# FUNCTION isPrimeFunc: 保存寄存器 $t3
sw $t4, -28($fp)# FUNCTION isPrimeFunc: 保存寄存器 $t4
sw $t5, -32($fp)# FUNCTION isPrimeFunc: 保存寄存器 $t5
sw $t6, -36($fp)# FUNCTION isPrimeFunc: 保存寄存器 $t6
sw $t7, -40($fp)# FUNCTION isPrimeFunc: 保存寄存器 $t7
sw $s0, -44($fp)# FUNCTION isPrimeFunc: 保存寄存器 $s0
sw $s1, -48($fp)# FUNCTION isPrimeFunc: 保存寄存器 $s1
sw $s2, -52($fp)# FUNCTION isPrimeFunc: 保存寄存器 $s2
sw $s3, -56($fp)# FUNCTION isPrimeFunc: 保存寄存器 $s3
sw $s4, -60($fp)# FUNCTION isPrimeFunc: 保存寄存器 $s4
sw $s5, -64($fp)# FUNCTION isPrimeFunc: 保存寄存器 $s5
sw $s6, -68($fp)# FUNCTION isPrimeFunc: 保存寄存器 $s6
sw $s7, -72($fp)# FUNCTION isPrimeFunc: 保存寄存器 $s7
sw $t8, -76($fp)# FUNCTION isPrimeFunc: 保存寄存器 $t8
sw $t9, -80($fp)# FUNCTION isPrimeFunc: 保存寄存器 $t9
lw $s3, -8($fp)# PARAM numberParam_: 读取第3个参数
li $s4, 2# in process_expression: divisorVar_ := #2
li $s5, 1
ble $s3, $s5, label7
j label8# GOTO label8
label7 :
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

label8 :
li $s7, 2
div $s3, $s7
mflo $t8# in handle_binary_op: temp2 := numberParam_ / #2 (get quotient)
sw $t8, -108($fp)
lw $t8, -108($fp)
li $t9, 1
add $t2, $t8, $t9# in handle_binary_op: temp3 := temp2 + #1
sw $t2, -112($fp)
lw $t3, -112($fp)
move $t2, $t3# in process_expression: checkLimit_ := temp3
label9 :
blt $t4, $t2, label10
j label11# GOTO label11
label10 :
subu $sp, $sp, 4# ARG divisorVar_: 压栈参数
sw $t4, 0($sp)
subu $sp, $sp, 4# ARG numberParam_: 压栈参数
sw $s3, 0($sp)
jal isDivisibleBy# CALL isDivisibleBy: 调用函数
move $t5, $v0# CALL isDivisibleBy: 保存返回值
sw $t7, -88($fp)
li $t7, 1
beq $t5, $t7, label12
j label13# GOTO label13
label12 :
sw $t6, -92($fp)
li $t6, 0
move $v0, $t6# RETURN #0: 设置返回值
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

label13 :
sw $t1, -84($fp)
li $t1, 1
sw $s0, -96($fp)
add $s0, $t4, $t1# in handle_binary_op: temp5 := divisorVar_ + #1
sw $s0, -128($fp)
lw $s0, -128($fp)
move $t4, $s0# in process_expression: divisorVar_ := temp5
j label9# GOTO label9
label11 :
sw $t0, -80($fp)
li $t0, 1
move $v0, $t0# RETURN #1: 设置返回值
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
move $s1, $v0# READ temp6: 将返回值存储到temp6
move $s2, $s1# in process_expression: numToCheck_ := temp6
subu $sp, $sp, 4# ARG numToCheck_: 压栈参数
sw $s2, 0($sp)
jal isPrimeFunc# CALL isPrimeFunc: 调用函数
sw $s4, -104($fp)
move $s4, $v0# CALL isPrimeFunc: 保存返回值
move $s5, $s4# in process_expression: primeResult_ := temp7
move $a0, $s5# WRITE primeResult_: 将值移动到$a0
subu $sp, $sp, 4# WRITE primeResult_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE primeResult_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE primeResult_: 恢复返回地址
li $s6, 0
move $v0, $s6# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

