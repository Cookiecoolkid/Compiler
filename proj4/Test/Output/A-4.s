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
li $t0, 0
addi $sp, $sp, -4# READ temp0: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp0: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp0: 恢复返回地址
move $t1, $v0# READ temp0: 将返回值存储到temp0
move $t2, $t1
li $t3, 1
label0 :
ble $t3, $t2, label1
j label2# GOTO label2
label1 :
li $t4, 1
label3 :
ble $t4, $t2, label4
j label5# GOTO label5
label4 :
li $t5, 10# in get_operand_reg: load immediate 10
mul $t6, $t3, $t5# in handle_binary_op: temp1 := i_ * #10
sw $t6, -100($fp)
# in spill_variable: store temp1 to stack
lw $t6, -100($fp)
# in load_variable: load temp1 from stack
add $t7, $t6, $t4# in handle_binary_op: temp2 := temp1 + j_
sw $t7, -104($fp)
# in spill_variable: store temp2 to stack
lw $s0, -104($fp)
# in load_variable: load temp2 from stack
move $t7, $s0
add $s1, $t3, $t4# in handle_binary_op: temp3 := i_ + j_
sw $s1, -112($fp)
# in spill_variable: store temp3 to stack
lw $s2, -112($fp)
# in load_variable: load temp3 from stack
move $s1, $s2
li $s3, 2# in get_operand_reg: load immediate 2
div $s1, $s3
mflo $s4# in handle_binary_op: temp4 := tempSum_ / #2 (get quotient)
sw $s4, -120($fp)
# in spill_variable: store temp4 to stack
lw $s4, -120($fp)
# in load_variable: load temp4 from stack
li $s5, 2# in get_operand_reg: load immediate 2
mul $s6, $s4, $s5# in handle_binary_op: temp5 := temp4 * #2
sw $s6, -124($fp)
# in spill_variable: store temp5 to stack
lw $s6, -124($fp)
# in load_variable: load temp5 from stack
beq $s6, $s1, label6
j label7# GOTO label7
label6 :
add $s7, $t0, $t7# in handle_binary_op: temp6 := totalSum_ + currentVal_
sw $s7, -128($fp)
# in spill_variable: store temp6 to stack
lw $s7, -128($fp)
# in load_variable: load temp6 from stack
move $t0, $s7
label7 :
li $t8, 1# in get_operand_reg: load immediate 1
add $t9, $t4, $t8# in handle_binary_op: temp7 := j_ + #1
sw $t9, -132($fp)
# in spill_variable: store temp7 to stack
lw $t9, -132($fp)
# in load_variable: load temp7 from stack
move $t4, $t9
j label3# GOTO label3
label5 :
li $t1, 1# in get_operand_reg: load immediate 1
add $t2, $t3, $t1# in handle_binary_op: temp8 := i_ + #1
sw $t2, -136($fp)
# in spill_variable: store temp8 to stack
lw $t2, -136($fp)
# in load_variable: load temp8 from stack
move $t3, $t2
j label0# GOTO label0
label2 :
move $a0, $t0# WRITE totalSum_: 将值移动到$a0
subu $sp, $sp, 4# WRITE totalSum_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE totalSum_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE totalSum_: 恢复返回地址
li $t5, 0# in get_operand_reg: load immediate 0
move $v0, $t5# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

