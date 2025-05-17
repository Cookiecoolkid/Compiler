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
li $t0, 0# in process_expression: totalSum_ := #0
sw $t0, -256($fp)
addi $sp, $sp, -4# READ temp0: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp0: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp0: 恢复返回地址
move $t0, $v0# READ temp0: 将返回值存储到temp0
move $t1, $t0# in process_expression: n_ := temp0
sw $t1, -264($fp)
li $t1, 1# in process_expression: i_ := #1
sw $t1, -268($fp)
label0 :
lw $t1, -268($fp)
lw $t2, -264($fp)
ble $t1, $t2, label1
j label2# GOTO label2
label1 :
li $t3, 1# in process_expression: j_ := #1
sw $t3, -272($fp)
label3 :
lw $t3, -272($fp)
ble $t3, $t2, label4
j label5# GOTO label5
label4 :
li $t4, 10
mul $t5, $t1, $t4# in handle_binary_op: temp1 := i_ * #10
sw $t5, -276($fp)
lw $t5, -276($fp)
add $t6, $t5, $t3# in handle_binary_op: temp2 := temp1 + j_
sw $t6, -280($fp)
lw $t7, -280($fp)
move $t6, $t7# in process_expression: currentVal_ := temp2
sw $t6, -284($fp)
add $t6, $t1, $t3# in handle_binary_op: temp3 := i_ + j_
sw $t6, -288($fp)
lw $s0, -288($fp)
move $t6, $s0# in process_expression: tempSum_ := temp3
sw $t6, -292($fp)
lw $t6, -292($fp)
li $s1, 2
div $t6, $s1
mflo $s2# in handle_binary_op: temp4 := tempSum_ / #2 (get quotient)
sw $s2, -296($fp)
lw $s2, -296($fp)
li $s3, 2
mul $s4, $s2, $s3# in handle_binary_op: temp5 := temp4 * #2
sw $s4, -300($fp)
lw $s4, -300($fp)
beq $s4, $t6, label6
j label7# GOTO label7
label6 :
lw $s5, -256($fp)
lw $s6, -284($fp)
add $s7, $s5, $s6# in handle_binary_op: temp6 := totalSum_ + currentVal_
sw $s7, -304($fp)
lw $s7, -304($fp)
move $s5, $s7# in process_expression: totalSum_ := temp6
sw $s5, -256($fp)
label7 :
li $s5, 1
add $t8, $t3, $s5# in handle_binary_op: temp7 := j_ + #1
sw $t8, -308($fp)
lw $t8, -308($fp)
move $t3, $t8# in process_expression: j_ := temp7
sw $t3, -272($fp)
j label3# GOTO label3
label5 :
li $t3, 1
add $t9, $t1, $t3# in handle_binary_op: temp8 := i_ + #1
sw $t9, -312($fp)
lw $t9, -312($fp)
move $t1, $t9# in process_expression: i_ := temp8
sw $t1, -268($fp)
j label0# GOTO label0
label2 :
lw $t1, -256($fp)
move $a0, $t1# WRITE totalSum_: 将值移动到$a0
subu $sp, $sp, 4# WRITE totalSum_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE totalSum_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE totalSum_: 恢复返回地址
sw $t0, -260($fp)
li $t0, 0
move $v0, $t0# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

