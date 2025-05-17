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
addi $t1, $fp, -256
move $t0, $t1# in process_expression: temp0 := &dataArr_
sw $t0, -416($fp)
li $t0, 0
li $t2, 4
mul $t3, $t0, $t2# in handle_binary_op: temp1 := #0 * #4
sw $t3, -420($fp)
lw $t3, -420($fp)
lw $t4, -416($fp)
add $t5, $t3, $t4# in handle_binary_op: temp2 := temp1 + temp0
sw $t5, -424($fp)
lw $t5, -424($fp)
li $t6, 10
sw $t6, 0($t5)# in process_expression: *temp2 = #10
sw $t5, -424($fp)
move $t5, $t1# in process_expression: temp3 := &dataArr_
sw $t5, -428($fp)
li $t5, 4
li $t7, 4
mul $s0, $t5, $t7# in handle_binary_op: temp4 := #4 * #4
sw $s0, -432($fp)
lw $s0, -432($fp)
lw $s1, -428($fp)
add $s2, $s0, $s1# in handle_binary_op: temp5 := temp4 + temp3
sw $s2, -436($fp)
lw $s2, -436($fp)
li $s3, 50
sw $s3, 0($s2)# in process_expression: *temp5 = #50
sw $s2, -436($fp)
addi $sp, $sp, -4# READ temp6: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp6: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp6: 恢复返回地址
move $s2, $v0# READ temp6: 将返回值存储到temp6
move $s4, $s2# in process_expression: val1_ := temp6
sw $s4, -444($fp)
addi $sp, $sp, -4# READ temp7: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp7: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp7: 恢复返回地址
move $s4, $v0# READ temp7: 将返回值存储到temp7
move $s5, $s4# in process_expression: index1_ := temp7
sw $s5, -452($fp)
move $s5, $t1# in process_expression: temp8 := &dataArr_
sw $s5, -456($fp)
lw $s5, -452($fp)
li $s6, 4
mul $s7, $s5, $s6# in handle_binary_op: temp9 := index1_ * #4
sw $s7, -460($fp)
lw $s7, -460($fp)
lw $t8, -456($fp)
add $t9, $s7, $t8# in handle_binary_op: temp10 := temp9 + temp8
sw $t9, -464($fp)
lw $t9, -464($fp)
lw $t0, -444($fp)
sw $t0, 0($t9)# in process_expression: *temp10 = val1_
sw $t9, -464($fp)
addi $sp, $sp, -4# READ temp11: 保存返回地址
sw $ra, 0($sp)
jal read# READ temp11: 调用read函数
lw $ra, 0($sp)
addi $sp, $sp, 4# READ temp11: 恢复返回地址
move $t9, $v0# READ temp11: 将返回值存储到temp11
move $t2, $t9# in process_expression: index2_ := temp11
sw $t2, -472($fp)
move $t2, $t1# in process_expression: temp12 := &dataArr_
sw $t2, -476($fp)
li $t2, 0
sw $t3, -420($fp)
li $t3, 4
sw $t4, -416($fp)
mul $t4, $t2, $t3# in handle_binary_op: temp13 := #0 * #4
sw $t4, -480($fp)
lw $t4, -480($fp)
lw $t6, -476($fp)
add $t5, $t4, $t6# in handle_binary_op: temp14 := temp13 + temp12
sw $t5, -484($fp)
lw $t5, -484($fp)
lw $t7, 0($t5)# in process_expression: temp15 := *temp14
sw $t7, -488($fp)
move $t7, $t1# in process_expression: temp16 := &dataArr_
sw $t7, -492($fp)
li $t7, 4
sw $s0, -432($fp)
mul $s0, $s5, $t7# in handle_binary_op: temp17 := index1_ * #4
sw $s0, -496($fp)
lw $s0, -496($fp)
sw $s1, -428($fp)
lw $s1, -492($fp)
add $s3, $s0, $s1# in handle_binary_op: temp18 := temp17 + temp16
sw $s3, -500($fp)
lw $s3, -500($fp)
sw $s2, -440($fp)
lw $s2, 0($s3)# in process_expression: temp19 := *temp18
sw $s2, -504($fp)
lw $s2, -488($fp)
sw $s4, -448($fp)
lw $s4, -504($fp)
add $s6, $s2, $s4# in handle_binary_op: temp20 := temp15 + temp19
sw $s6, -508($fp)
sw $s7, -460($fp)
lw $s7, -508($fp)
move $s6, $s7# in process_expression: temp_ := temp20
sw $s6, -512($fp)
move $s6, $t1# in process_expression: temp21 := &dataArr_
sw $s6, -516($fp)
lw $s6, -472($fp)
sw $t8, -456($fp)
li $t8, 4
sw $t0, -444($fp)
mul $t0, $s6, $t8# in handle_binary_op: temp22 := index2_ * #4
sw $t0, -520($fp)
lw $t0, -520($fp)
sw $t9, -468($fp)
lw $t9, -516($fp)
add $t2, $t0, $t9# in handle_binary_op: temp23 := temp22 + temp21
sw $t2, -524($fp)
lw $t2, -524($fp)
lw $t3, 0($t2)# in process_expression: temp24 := *temp23
sw $t3, -528($fp)
lw $t3, -512($fp)
sw $t4, -480($fp)
lw $t4, -528($fp)
sw $t6, -476($fp)
mul $t6, $t3, $t4# in handle_binary_op: temp25 := temp_ * temp24
sw $t6, -532($fp)
sw $t5, -484($fp)
lw $t5, -532($fp)
move $t6, $t5# in process_expression: calculatedVal_ := temp25
sw $t6, -536($fp)
move $t6, $t1# in process_expression: temp26 := &dataArr_
sw $t6, -540($fp)
li $t6, 0
sw $s5, -452($fp)
li $s5, 4
mul $t7, $t6, $s5# in handle_binary_op: temp27 := #0 * #4
sw $t7, -544($fp)
lw $t7, -544($fp)
sw $s0, -496($fp)
lw $s0, -540($fp)
sw $s1, -492($fp)
add $s1, $t7, $s0# in handle_binary_op: temp28 := temp27 + temp26
sw $s1, -548($fp)
lw $s1, -548($fp)
sw $s3, -500($fp)
lw $s3, 0($s1)# in process_expression: temp29 := *temp28
sw $s3, -552($fp)
lw $s3, -552($fp)
move $a0, $s3# WRITE temp29: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp29: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp29: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp29: 恢复返回地址
sw $s2, -488($fp)
move $s2, $t1# in process_expression: temp30 := &dataArr_
sw $s2, -556($fp)
lw $s2, -452($fp)
sw $s4, -504($fp)
li $s4, 4
sw $s7, -508($fp)
mul $s7, $s2, $s4# in handle_binary_op: temp31 := index1_ * #4
sw $s7, -560($fp)
lw $s7, -560($fp)
sw $s6, -472($fp)
lw $s6, -556($fp)
add $t8, $s7, $s6# in handle_binary_op: temp32 := temp31 + temp30
sw $t8, -564($fp)
lw $t8, -564($fp)
sw $t0, -520($fp)
lw $t0, 0($t8)# in process_expression: temp33 := *temp32
sw $t0, -568($fp)
lw $t0, -568($fp)
move $a0, $t0# WRITE temp33: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp33: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp33: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp33: 恢复返回地址
sw $t9, -516($fp)
move $t9, $t1# in process_expression: temp34 := &dataArr_
sw $t9, -572($fp)
lw $t9, -472($fp)
sw $t2, -524($fp)
li $t2, 4
sw $t3, -512($fp)
mul $t3, $t9, $t2# in handle_binary_op: temp35 := index2_ * #4
sw $t3, -576($fp)
lw $t3, -576($fp)
sw $t4, -528($fp)
lw $t4, -572($fp)
sw $t5, -532($fp)
add $t5, $t3, $t4# in handle_binary_op: temp36 := temp35 + temp34
sw $t5, -580($fp)
lw $t5, -580($fp)
lw $t6, 0($t5)# in process_expression: temp37 := *temp36
sw $t6, -584($fp)
lw $t6, -584($fp)
move $a0, $t6# WRITE temp37: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp37: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp37: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp37: 恢复返回地址
move $s5, $t1# in process_expression: temp38 := &dataArr_
sw $s5, -588($fp)
li $s5, 4
sw $t7, -544($fp)
li $t7, 4
sw $s0, -540($fp)
mul $s0, $s5, $t7# in handle_binary_op: temp39 := #4 * #4
sw $s0, -592($fp)
lw $s0, -592($fp)
sw $s1, -548($fp)
lw $s1, -588($fp)
sw $s3, -552($fp)
add $s3, $s0, $s1# in handle_binary_op: temp40 := temp39 + temp38
sw $s3, -596($fp)
lw $s3, -596($fp)
sw $s2, -452($fp)
lw $s2, 0($s3)# in process_expression: temp41 := *temp40
sw $s2, -600($fp)
lw $s2, -600($fp)
move $a0, $s2# WRITE temp41: 将值移动到$a0
subu $sp, $sp, 4# WRITE temp41: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE temp41: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE temp41: 恢复返回地址
lw $s4, -536($fp)
move $a0, $s4# WRITE calculatedVal_: 将值移动到$a0
subu $sp, $sp, 4# WRITE calculatedVal_: 保存返回地址
sw $ra, 0($sp)
jal write# WRITE calculatedVal_: 调用write函数
lw $ra, 0($sp)
addi $sp, $sp, 4# WRITE calculatedVal_: 恢复返回地址
sw $s7, -560($fp)
li $s7, 0
move $v0, $s7# RETURN #0: 设置返回值
lw $ra, -8($fp)# RETURN #0: 恢复返回地址
lw $fp, -4($fp)# RETURN #0: 恢复帧指针
addi $sp, $sp, 80
jr $ra

