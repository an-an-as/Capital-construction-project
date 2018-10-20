from functools import cmp_to_key
import functools
from functools import wraps
from functools import update_wrapper

# cmp_to_key 该函数主要用于将程序转换成Python 3格式的，因为Python 3中不支持比较函数。
def compare(ele1,ele2):
    return ele1 - ele2

a = [2,3,1]
print (sorted(a, key = cmp_to_key(compare)))



def add(a,b):
    return a + b
add3 = functools.partial(add,3)
add5 = functools.partial(add,5)
# 某一次使用只需要更改其中的一部分参数，其他的参数都保持不变时，partial对象就可以将这些不变的对象冻结起来
print (add3(4))
print (add5(10))




a = range(1,6)
print (functools.reduce(lambda x,y:x+y,a))



from functools import wraps
from functools import update_wrapper
def decorator0(f):
    def wrapper(*args, **kwds):
        print ('Calling decorated function---------------------0')
        return f(*args, **kwds)
    return wrapper

def decorator1(f):
    def wrapper(*args, **kwds):
        print ('Calling decorated function---------------------1')
        return f(*args, **kwds)
    return wrapper

@decorator0
def example():
    """Docstring"""
    print ('Called example function')

example() 
print ( '--------------------------------' )

update_wrapper(example,decorator1)
example()

