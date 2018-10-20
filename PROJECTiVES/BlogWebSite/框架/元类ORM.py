#!/usr/bin/env python3
# -*- coding: utf-8 -*-

' Simple ORM using metaclass '

class Field(object):
    def __init__(self, name, column_type):
        self.name = name
        self.column_type = column_type

    def __str__(self):
        return '<%s:%s>' % (self.__class__.__name__, self.name)

class StringField(Field):
    def __init__(self, name):
        super(StringField, self).__init__(name, 'varchar(100)')

class IntegerField(Field):
    def __init__(self, name):
        super(IntegerField, self).__init__(name, 'bigint')


class ModelMetaclass(type): # 通过元类创建基类 通过继承基类 创建不同的 类 类里面定义属性和值 这样元类可以搜索到全部 
    def __new__(cls, name, bases, attrs):# 元类的好处就是可以得到所有的attrs 里面包含所有 通过元类创建的类的类属性和值
        if name=='Model': # User 定义了具体的字段属性 id name等  所以下面的处理排除通过元类创建的Model
            return type.__new__(cls, name, bases, attrs)# name 可以得到所有通过元类创建的类的名字 metaclass = ...
        print('Found model: %s' % name) # 这里通过元类创建了Model User继承Model 排除Model 就是有User
        mappings = dict() # 创建字点 把User里面的属性 和 值 存到字典 (通过元类扩展了字典 那么可以遍历出所有这些类)
        for k, v in attrs.items():   # attrs里面都是字典对象 Model(dict) 所以可以遍历
            if isinstance(v, Field): # k 是继承基类创建的属性 v 是该属性的值 User的属性 通过Field创建
                print('Found mapping: %s ==> %s' % (k, v)) 
                mappings[k] = v  # 把所有类User Login啊  里面的属性和值存入字典 然后从原有的类中删除 类属性的名字为key
        for k in mappings.keys(): # 遍历所有的属性
            attrs.pop(k) # 从类属性中删除该Field属性，否则，容易造成运行时错误（实例的属性会遮盖类的同名属性）
        attrs['__mappings__'] = mappings # 为所有的类User Loggin 创建字典属性(所有继承自元类的属性都在元类汇总然后分发)
        attrs['__table__'] = name #所有的类的名字 即所有的表
        return type.__new__(cls, name, bases, attrs)

class Model(dict, metaclass=ModelMetaclass): # 通过元类创建
    def __init__(self, **kw): #关键字参数
        super(Model, self).__init__(**kw) # 找到父类 然后爸Model对象Self转换为Model对象 然后调用自己的初始化发方法

    def __getattr__(self, key):
        try:
            return self[key]
        except KeyError:
            raise AttributeError(r"'Model' object has no attribute '%s'" % key)

    def __setattr__(self, key, value):
        self[key] = value

    def save(self): # 保存插入值
        fields = []
        params = []
        args = []
        for k, v in self.__mappings__.items(): # 遍历__mappings__ 子类对象的属性 和 值存储在mappings
            fields.append(v.name) # 存储所有的属性的值(File对象)的 字段名
            print("%s---<"%v)
            params.append('?')
            args.append(getattr(self, k, None))# 通过getattr 获取当前初始化的属性k的值 如果没有返回None
            # getattr() 函数用于返回一个对象属性值
            print("=====%s"%args)
        sql = 'insert into %s (%s) values (%s)' % (self.__table__, ','.join(fields), ','.join(params))
        print('SQL: %s' % sql)
        print('ARGS: %s' % str(args))

# testing code:

class User(Model): 
    # 元类会删除 创建字段名 和 sql一致 保存在__mapping__里 
    # 再次初始化创建的时候 
    id = IntegerField('id') # 创建id 字段对象 id.name 字段名 id.column_type 类型
    name = StringField('username') # 字段名
    email = StringField('email') 
    password = StringField('password')  
    # ⚠️ User 定义好后存储在__mapping___ 然后删除 mapping 里的id 字段
    # ⚠️ 初始化后 id的 具体数据 通过getattr() 获取对象的属性值 如果遍历出maapping的id 和 初始化的id不一致那么就返回None 

class Demo(Model):
    key = StringField('as')
# 在字段下插入内容
u = User(id=12345, name='Michael', email='test@orm.org', password='my-pwd')
u.save()

d = Demo(key = 'aaaa')
d.save()