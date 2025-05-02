.data
newline: .asciiz "\n"

.globl main

.text
# int inc(int a)
inc:
    # 参数 a 已经在 $a0
    addi $sp, $sp, -4        # 为 b 分配空间
    addi $t0, $a0, 1         # b = a + 1  
    sw $t0, 0($sp)           # 保存 b
    lw $v0, 0($sp)           # 返回值放入 $v0
    addi $sp, $sp, 4         # 回收 b 的空间
    jr $ra                   # 返回

# int main()
main:
    addi $sp, $sp, -8        # 为 lcVar 和 rcVar 分配空间
    li $t0, 2
    mul $t0, $t0, $t0        # lcVar = 2 * 2
    sw $t0, 0($sp)           # 保存 lcVar

    move $a0, $t0            # 准备调用 inc(lcVar)
    jal inc                  # 调用 inc

    move $t1, $v0            # rcVar = return value
    sw $t1, 4($sp)           # 保存 rcVar

    li $v0, 0                # return 0
    addi $sp, $sp, 8         # 回收 lcVar 和 rcVar 空间
    jr $ra
