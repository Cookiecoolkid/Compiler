.data
prompt1: .asciiz "Enter first number: "
prompt2: .asciiz "Enter second number: "
result:  .asciiz "Sum is: "

.text
.globl main

main:
    # 打印提示1
    li $v0, 4
    la $a0, prompt1
    syscall

    # 读取第一个整数
    li $v0, 5
    syscall
    move $t0, $v0     # 把第一个数保存在 $t0

    # 打印提示2
    li $v0, 4
    la $a0, prompt2
    syscall

    # 读取第二个整数
    li $v0, 5
    syscall
    move $t1, $v0     # 把第二个数保存在 $t1

    # 相加
    add $t2, $t0, $t1

    # 打印结果提示
    li $v0, 4
    la $a0, result
    syscall

    # 打印结果
    li $v0, 1
    move $a0, $t2
    syscall

    # 退出程序
    li $v0, 10
    syscall
