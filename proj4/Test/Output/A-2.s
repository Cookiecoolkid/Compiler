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
li $t0, 10
li $t1, 0
addi $sp, $sp, -4# READ temp0: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp0: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp0: 恢复返回地址
move $t2, $v0# READ temp0: 将返回值存储到temp0
move $t3, $t2
addi $sp, $sp, -4# READ temp1: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp1: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp1: 恢复返回地址
move $t4, $v0# READ temp1: 将返回值存储到temp1
move $t5, $t4
bgt $t3, $t0, label3
j label1# GOTO label1
label3 :
li $t6, 0# in get_operand_reg: load immediate 0
bgt $t5, $t6, label0
j label1# GOTO label1
label0 :
li $t7, 100# in get_operand_reg: load immediate 100
move $a0, $t7# WRITE #100: 将值移动到$a0
subu $sp, $sp, 4# WRITE #100: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #100: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #100: 恢复返回地址
li $t1, 1
j label2# GOTO label2
label1 :
ble $t3, $t0, label7
j label5# GOTO label5
label7 :
li $s0, 0# in get_operand_reg: load immediate 0
blt $t5, $s0, label4
j label5# GOTO label5
label4 :
li $s1, 200# in get_operand_reg: load immediate 200
move $a0, $s1# WRITE #200: 将值移动到$a0
subu $sp, $sp, 4# WRITE #200: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #200: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #200: 恢复返回地址
li $t1, 2
j label6# GOTO label6
label5 :
li $s2, 250# in get_operand_reg: load immediate 250
move $a0, $s2# WRITE #250: 将值移动到$a0
subu $sp, $sp, 4# WRITE #250: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #250: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #250: 恢复返回地址
li $t1, 3
label6 :
label2 :
li $s3, 0# in get_operand_reg: load immediate 0
beq $t3, $s3, label8
j label11# GOTO label11
label11 :
beq $t5, $t0, label8
j label9# GOTO label9
label8 :
li $s4, 300# in get_operand_reg: load immediate 300
move $a0, $s4# WRITE #300: 将值移动到$a0
subu $sp, $sp, 4# WRITE #300: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #300: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #300: 恢复返回地址
li $s5, 1# in get_operand_reg: load immediate 1
beq $t1, $s5, label12
j label14# GOTO label14
label14 :
li $s6, 3# in get_operand_reg: load immediate 3
beq $t1, $s6, label12
j label13# GOTO label13
label12 :
li $s7, 310# in get_operand_reg: load immediate 310
move $a0, $s7# WRITE #310: 将值移动到$a0
subu $sp, $sp, 4# WRITE #310: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #310: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #310: 恢复返回地址
label13 :
j label10# GOTO label10
label9 :
li $t8, 400# in get_operand_reg: load immediate 400
move $a0, $t8# WRITE #400: 将值移动到$a0
subu $sp, $sp, 4# WRITE #400: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #400: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #400: 恢复返回地址
li $t9, 2# in get_operand_reg: load immediate 2
beq $t1, $t9, label15
j label16# GOTO label16
label15 :
li $t2, 410# in get_operand_reg: load immediate 410
move $a0, $t2# WRITE #410: 将值移动到$a0
subu $sp, $sp, 4# WRITE #410: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #410: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #410: 恢复返回地址
label16 :
label10 :
add $t4, $t3, $t5# in handle_binary_op: temp2 := num1_ + num2_
sw $t4, -104($fp)
lw $t4, -104($fp)
li $t6, 0# in get_operand_reg: load immediate 0
bgt $t4, $t6, label20
j label18# GOTO label18
label20 :
bgt $t3, $t0, label17
j label21# GOTO label21
label21 :
li $t7, 0# in get_operand_reg: load immediate 0
blt $t5, $t7, label17
j label18# GOTO label18
label17 :
li $s0, 500# in get_operand_reg: load immediate 500
move $a0, $s0# WRITE #500: 将值移动到$a0
subu $sp, $sp, 4# WRITE #500: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #500: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #500: 恢复返回地址
j label19# GOTO label19
label18 :
li $s1, 600# in get_operand_reg: load immediate 600
move $a0, $s1# WRITE #600: 将值移动到$a0
subu $sp, $sp, 4# WRITE #600: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE #600: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE #600: 恢复返回地址
label19 :
li $s2, 0# in get_operand_reg: load immediate 0
move $v0, $s2# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

