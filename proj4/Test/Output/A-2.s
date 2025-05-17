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

main:
subu $sp, $sp, 80# FUNCTION main: 分配栈帧
sw $fp, 76($sp)# FUNCTION main: 保存旧帧指针
sw $ra, 72($sp)# FUNCTION main: 保存返回地址
addiu $fp, $sp, 80# FUNCTION main: 设置新的帧指针
li $t0, 10# in process_expression: threshold_ := #10
sw $t0, -256($fp)
li $t0, 0# in process_expression: category_ := #0
sw $t0, -260($fp)
addi $sp, $sp, -4# READ temp0: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp0: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp0: 恢复返回地址
move $t0, $v0# READ temp0: 将返回值存储到temp0
move $t1, $t0# in process_expression: num1_ := temp0
sw $t1, -268($fp)
addi $sp, $sp, -4# READ temp1: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp1: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp1: 恢复返回地址
move $t1, $v0# READ temp1: 将返回值存储到temp1
move $t2, $t1# in process_expression: num2_ := temp1
sw $t2, -276($fp)
lw $t2, -268($fp)
lw $t3, -256($fp)
bgt $t2, $t3, label3
j label1# GOTO label1
label3 :
lw $t4, -276($fp)
li $t5, 0
bgt $t4, $t5, label0
j label1# GOTO label1
label0 :
li $t6, 100
move $a0, $t6# WRITE #100: 将值移动到$a0
subu $sp, $sp, 4# WRITE #100: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #100: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #100: 恢复返回地址
lw $t7, -260($fp)
li $t7, 1# in process_expression: category_ := #1
sw $t7, -260($fp)
j label2# GOTO label2
label1 :
ble $t2, $t3, label7
j label5# GOTO label5
label7 :
li $t7, 0
blt $t4, $t7, label4
j label5# GOTO label5
label4 :
li $s0, 200
move $a0, $s0# WRITE #200: 将值移动到$a0
subu $sp, $sp, 4# WRITE #200: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #200: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #200: 恢复返回地址
lw $s1, -260($fp)
li $s1, 2# in process_expression: category_ := #2
sw $s1, -260($fp)
j label6# GOTO label6
label5 :
li $s1, 250
move $a0, $s1# WRITE #250: 将值移动到$a0
subu $sp, $sp, 4# WRITE #250: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #250: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #250: 恢复返回地址
lw $s2, -260($fp)
li $s2, 3# in process_expression: category_ := #3
sw $s2, -260($fp)
label6 :
label2 :
li $s2, 0
beq $t2, $s2, label8
j label11# GOTO label11
label11 :
beq $t4, $t3, label8
j label9# GOTO label9
label8 :
li $s3, 300
move $a0, $s3# WRITE #300: 将值移动到$a0
subu $sp, $sp, 4# WRITE #300: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #300: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #300: 恢复返回地址
lw $s4, -260($fp)
li $s5, 1
beq $s4, $s5, label12
j label14# GOTO label14
label14 :
li $s6, 3
beq $s4, $s6, label12
j label13# GOTO label13
label12 :
li $s7, 310
move $a0, $s7# WRITE #310: 将值移动到$a0
subu $sp, $sp, 4# WRITE #310: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #310: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #310: 恢复返回地址
label13 :
j label10# GOTO label10
label9 :
li $t8, 400
move $a0, $t8# WRITE #400: 将值移动到$a0
subu $sp, $sp, 4# WRITE #400: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #400: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #400: 恢复返回地址
li $t9, 2
beq $s4, $t9, label15
j label16# GOTO label16
label15 :
sw $t0, -264($fp)
li $t0, 410
move $a0, $t0# WRITE #410: 将值移动到$a0
subu $sp, $sp, 4# WRITE #410: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #410: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #410: 恢复返回地址
label16 :
label10 :
sw $t1, -272($fp)
add $t1, $t2, $t4# in handle_binary_op: temp2 := num1_ + num2_
sw $t1, -280($fp)
lw $t1, -280($fp)
li $t5, 0
bgt $t1, $t5, label20
j label18# GOTO label18
label20 :
bgt $t2, $t3, label17
j label21# GOTO label21
label21 :
li $t6, 0
blt $t4, $t6, label17
j label18# GOTO label18
label17 :
li $t7, 500
move $a0, $t7# WRITE #500: 将值移动到$a0
subu $sp, $sp, 4# WRITE #500: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #500: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #500: 恢复返回地址
j label19# GOTO label19
label18 :
li $s0, 600
move $a0, $s0# WRITE #600: 将值移动到$a0
subu $sp, $sp, 4# WRITE #600: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #600: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #600: 恢复返回地址
label19 :
li $s1, 0
move $v0, $s1# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

