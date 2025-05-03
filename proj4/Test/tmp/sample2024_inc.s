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

inc:
  addi $sp, $sp, -8
  sw $fp, 0($sp)
  sw $ra, 4($sp)
  move $fp, $sp
  addi $sp, $sp, -8
  lw $t0, 8($fp)
  li $t1, 1
  lw $t2, -4($fp)
  add $t2, $t0, $t1
  sw $t2, -4($fp)
  lw $t0, -8($fp)
  lw $t1, -4($fp)
  move $t0, $t1
  sw $t0, -8($fp)
  lw $ra, 4($fp)
  addi $sp, $fp, 8
  lw $t0, -8($fp)
  lw $fp, 0($fp)
  move $v0, $t0
  jr $ra
main:
  addi $sp, $sp, -8
  sw $fp, 0($sp)
  sw $ra, 4($sp)
  move $fp, $sp
  addi $sp, $sp, -16
  li $t0, 2
  li $t1, 2
  lw $t2, -4($fp)
  mul $t2, $t0, $t1
  sw $t2, -4($fp)
  lw $t0, -8($fp)
  lw $t1, -4($fp)
  move $t0, $t1
  sw $t0, -8($fp)
  addi $sp, $sp, -4
  lw $t0, -8($fp)
  sw $t0, 0($sp)
  jal inc
  addi $sp, $sp, 4
  lw $t0, -12($fp)
  move $t0, $v0
  sw $t0, -12($fp)
  lw $t0, -16($fp)
  lw $t1, -12($fp)
  move $t0, $t1
  sw $t0, -16($fp)
  lw $ra, 4($fp)
  addi $sp, $fp, 8
  li $t0, 0
  lw $fp, 0($fp)
  move $v0, $t0
  jr $ra
