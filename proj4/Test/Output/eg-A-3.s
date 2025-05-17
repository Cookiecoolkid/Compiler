.data
_prompt: .asciiz "Enter an integer:"
_ret: .asciiz "\n"
.globl main
.text
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
  addi $sp, $sp, -8
  sw $fp, 0($sp)
  sw $ra, 4($sp)
  move $fp, $sp
  addi $sp, $sp, -160
  li $t0, 0
  li $t1, 4
  lw $t2, -24($fp)
  mul $t2, $t0, $t1
  sw $t2, -24($fp)
  addi $t0, $fp, -20
  lw $t1, -24($fp)
  lw $t2, -28($fp)
  add $t2, $t0, $t1
  sw $t2, -28($fp)
  li $t0, 10
  lw $t7, -28($fp)
  sw $t0, 0($t7)
  li $t0, 4
  li $t1, 4
  lw $t2, -32($fp)
  mul $t2, $t0, $t1
  sw $t2, -32($fp)
  addi $t0, $fp, -20
  lw $t1, -32($fp)
  lw $t2, -36($fp)
  add $t2, $t0, $t1
  sw $t2, -36($fp)
  li $t0, 50
  lw $t7, -36($fp)
  sw $t0, 0($t7)
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal read
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  lw $t0, -40($fp)
  move $t0, $v0
  sw $t0, -40($fp)
  lw $t0, -44($fp)
  lw $t1, -40($fp)
  move $t0, $t1
  sw $t0, -44($fp)
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal read
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  lw $t0, -48($fp)
  move $t0, $v0
  sw $t0, -48($fp)
  lw $t0, -52($fp)
  lw $t1, -48($fp)
  move $t0, $t1
  sw $t0, -52($fp)
  lw $t0, -52($fp)
  li $t1, 4
  lw $t2, -56($fp)
  mul $t2, $t0, $t1
  sw $t2, -56($fp)
  addi $t0, $fp, -20
  lw $t1, -56($fp)
  lw $t2, -60($fp)
  add $t2, $t0, $t1
  sw $t2, -60($fp)
  lw $t0, -44($fp)
  lw $t7, -60($fp)
  sw $t0, 0($t7)
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal read
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  lw $t0, -64($fp)
  move $t0, $v0
  sw $t0, -64($fp)
  lw $t0, -68($fp)
  lw $t1, -64($fp)
  move $t0, $t1
  sw $t0, -68($fp)
  li $t0, 0
  li $t1, 4
  lw $t2, -72($fp)
  mul $t2, $t0, $t1
  sw $t2, -72($fp)
  addi $t0, $fp, -20
  lw $t1, -72($fp)
  lw $t2, -76($fp)
  add $t2, $t0, $t1
  sw $t2, -76($fp)
  lw $t0, -52($fp)
  li $t1, 4
  lw $t2, -80($fp)
  mul $t2, $t0, $t1
  sw $t2, -80($fp)
  addi $t0, $fp, -20
  lw $t1, -80($fp)
  lw $t2, -84($fp)
  add $t2, $t0, $t1
  sw $t2, -84($fp)
  lw $t0, -76($fp)
  lw $t0, 0($t0)
  lw $t1, -84($fp)
  lw $t1, 0($t1)
  lw $t2, -88($fp)
  add $t2, $t0, $t1
  sw $t2, -88($fp)
  lw $t0, -92($fp)
  lw $t1, -88($fp)
  move $t0, $t1
  sw $t0, -92($fp)
  lw $t0, -68($fp)
  li $t1, 4
  lw $t2, -96($fp)
  mul $t2, $t0, $t1
  sw $t2, -96($fp)
  addi $t0, $fp, -20
  lw $t1, -96($fp)
  lw $t2, -100($fp)
  add $t2, $t0, $t1
  sw $t2, -100($fp)
  lw $t0, -92($fp)
  lw $t1, -100($fp)
  lw $t1, 0($t1)
  lw $t2, -104($fp)
  mul $t2, $t0, $t1
  sw $t2, -104($fp)
  lw $t0, -108($fp)
  lw $t1, -104($fp)
  move $t0, $t1
  sw $t0, -108($fp)
  li $t0, 0
  li $t1, 4
  lw $t2, -112($fp)
  mul $t2, $t0, $t1
  sw $t2, -112($fp)
  addi $t0, $fp, -20
  lw $t1, -112($fp)
  lw $t2, -116($fp)
  add $t2, $t0, $t1
  sw $t2, -116($fp)
  lw $t0, -116($fp)
  lw $t0, 0($t0)
  move $a0, $t0
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal write
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  li $t0, 0
  lw $t1, -120($fp)
  move $t1, $t0
  sw $t1, -120($fp)
  lw $t0, -52($fp)
  li $t1, 4
  lw $t2, -124($fp)
  mul $t2, $t0, $t1
  sw $t2, -124($fp)
  addi $t0, $fp, -20
  lw $t1, -124($fp)
  lw $t2, -128($fp)
  add $t2, $t0, $t1
  sw $t2, -128($fp)
  lw $t0, -128($fp)
  lw $t0, 0($t0)
  move $a0, $t0
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal write
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  li $t0, 0
  lw $t1, -132($fp)
  move $t1, $t0
  sw $t1, -132($fp)
  lw $t0, -68($fp)
  li $t1, 4
  lw $t2, -136($fp)
  mul $t2, $t0, $t1
  sw $t2, -136($fp)
  addi $t0, $fp, -20
  lw $t1, -136($fp)
  lw $t2, -140($fp)
  add $t2, $t0, $t1
  sw $t2, -140($fp)
  lw $t0, -140($fp)
  lw $t0, 0($t0)
  move $a0, $t0
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal write
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  li $t0, 0
  lw $t1, -144($fp)
  move $t1, $t0
  sw $t1, -144($fp)
  li $t0, 4
  li $t1, 4
  lw $t2, -148($fp)
  mul $t2, $t0, $t1
  sw $t2, -148($fp)
  addi $t0, $fp, -20
  lw $t1, -148($fp)
  lw $t2, -152($fp)
  add $t2, $t0, $t1
  sw $t2, -152($fp)
  lw $t0, -152($fp)
  lw $t0, 0($t0)
  move $a0, $t0
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal write
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  li $t0, 0
  lw $t1, -156($fp)
  move $t1, $t0
  sw $t1, -156($fp)
  lw $t0, -108($fp)
  move $a0, $t0
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal write
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  li $t0, 0
  lw $t1, -160($fp)
  move $t1, $t0
  sw $t1, -160($fp)
  lw $ra, 4($fp)
  addi $sp, $fp, 8
  li $t0, 0
  lw $fp, 0($fp)
  move $v0, $t0
  jr $ra
