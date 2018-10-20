import time, functools
def foo():
    print ('this is foo')

foo()


def foo1():
    start_time = time.clock()
    print ('this is foo1')
    end_time = time.clock()
    print ('foo1 执行时间为：', end_time - start_time)

foo1()


def foo3():
    print ('this is foo3')

def timeit(func):
    start_time = time.clock()
    func()
    end_time = time.clock()
    print ('used:', end_time - start_time)

timeit(foo3)



def foo4():
    print ('this is foo4')

def timeit4(func):
    def wrapper():
        start_time = time.clock()
        func()
        end_time = time.clock()
        print ('used:', end_time - start_time)
    return wrapper

foo_1 = timeit(foo4)
# 类似装饰器 修改如下

@timeit4    # foo = timeit(foo)完全等价   返回一函数封装后直接运行
def foo5():
    print ('this is foo5')

foo5()


def timeit_3_for_wraps(func):
    @functools.wraps(func)
    def wrapper():
        start=time.clock()
        func()
        end=time.clock()
        print ('used:',end-start)
    return wrapper

@timeit_3_for_wraps
def foo6():
    print ('this is foo6')

foo6()

# 在代码运行期间动态增加功能的方式，称之为“装饰器”（Decorator）
