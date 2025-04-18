import gdb

# [Usage]: gdb [executable file] -x gdb_debug.py

def setup_debug():
    # 设置断点并运行程序
    gdb.execute('b /home/cookiecoolkid/Compiler/proj3/Code/translate.c:767')
    gdb.execute('run ../Test/test4.cmm ../Output/test4.ir')
    gdb.execute('layout src')
    gdb.execute('set pagination off')

# 注册调试设置函数
gdb.execute('set confirm off')  # 关闭确认提示
setup_debug()

# 继续执行，进入调试模式
# gdb.execute('continue')