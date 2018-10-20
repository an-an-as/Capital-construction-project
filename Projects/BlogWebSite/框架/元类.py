# 要创建一个class对象，type()函数依次传入3个参数：
# class的名称；
# 继承的父类集合，注意Python支持多重继承，如果只有一个父类，别忘了tuple的单元素写法；
# class的方法名称与函数绑定，这里我们把函数fn绑定到方法名hello上。

def fn(self,name = "hellp"):
    print("%s"%name)

Hello = type('Hello',(object,),dict(hello = fn))
h = Hello()
h.hello()

# metaclass是类的模板，所以必须从`type`类型派生： 先定义metaclass，然后创建类, 最后创建实例
class ListMetaclass(type):
    def __new__(cls, name, bases, attrs):
        if name=='MyList':
            return type.__new__(cls, name, bases, attrs)
        print(name)
        for k,v in attrs.items():
            print(k,v)
        attrs['add'] = lambda self, value: self.append(value) # 属性add 方法
        return type.__new__(cls, name, bases, attrs)
# __new__()方法接收到的参数依次是：
# 当前准备创建的类的对象
# 类的名字
# 类继承的父类集合
# 类的方法集合

# 在创建MyList时，要通过ListMetaclass.__new__()来创建 扩展了list
class MyList(list,metaclass = ListMetaclass):
    pass

class MyList2(MyList):
    id = "asd"
    

L = MyList2()
L.add(1)
#print(L)

#def demo():
#    print("s")

# print(demo.__qualname__)    # 函数的限定名称


print("%s-%s"%("s",  s"))




