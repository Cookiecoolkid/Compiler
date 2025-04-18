import gdb

# [Usage]: gdb [executable file] -x gdb_debug.py

def setup_debug():
    # 设置断点并运行程序
    gdb.execute('b translate_compSt')
    gdb.execute('run ../Test/test3.cmm ../Output/test3.ir')
    gdb.execute('layout src')
    gdb.execute('set pagination off')

# 注册调试设置函数
gdb.execute('set confirm off')  # 关闭确认提示
setup_debug()

# 继续执行，进入调试模式
# gdb.execute('continue')