import functools
# decorator就是一个返回函数的高阶函数。
def log(func):
    @functools.wraps(func) # 把原始函数的__name__等属性复制到wrapper()函数中
    def wrapper(*args, **kw):
        print('call %s():' % func.__name__)
        return func(*args, **kw)
    return wrapper # 调用log 执行wrapper传入参数 

@log
def now():
    print('2015-3-25')

now()

# 如果decorator本身需要传入参数 自定义内容
def log2(text):
    def decorator(func):
        @functools.wraps(func) # 如果不加 返回return 返回函数那么最终就是等价于wrapper
        def wrapper(*args, **kw):
            print('%s %s():' % (text, func.__name__))
            return func(*args, **kw)
        wrapper.__method__ = 'GET'
        return wrapper
    return decorator

@log2('execute')
def now2():
    print('2015-3-25')

print(now2.__name__)
print(now2.__method__)

