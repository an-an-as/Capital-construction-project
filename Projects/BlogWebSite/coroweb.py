#!/usr/bin/env python3
# -*- coding: utf-8 -*-


import asyncio, os, inspect, logging
# 高阶函数模块, 提供常用的高阶函数, 如wraps
import functools
from urllib import parse
from aiohttp import web
# apis.py是自己定义的
from apis import APIError
# 这是个装饰器，在handlers模块中被引用，其作用是给http请求添加请求方法和请求路径这两个属性
# 装饰器可以详见之前的教程
# 这是个三层嵌套的decorator（装饰器），目的是可以在decorator本身传入参数
# 这个装饰器将一个函数映射为一个URL处理函数
def get(path): # 传入参数
    '''
    Define decorator @get('/path')
    '''
    def decorator(func):   
        # 该装饰器的作用是解决一些函数签名的问题
        # 比如若没有该装饰器,wrapper.__name__将为"wrapper"
        # 加了装饰器,wrapper.__name__就等于func.__name__
        @functools.wraps(func)
        def wrapper(*args, **kw):
            return func(*args, **kw)
        wrapper.__method__ = 'GET'  # 通过装饰器加上__method__属性,用于表示http method
        wrapper.__route__ = path	# 给原始函数添加请求路径 path
        return wrapper
    return decorator
# 这样，一个函数通过@get(path)的装饰就附带了URL信息

def post(path):
    '''
    Define decorator @post('/path')
    '''
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kw):
            return func(*args, **kw)
        wrapper.__method__ = 'POST'
        wrapper.__route__ = path
        return wrapper
    return decorator

# 函数的参数fn本身就是个函数，下面五个函数是针对fn函数的参数做一些处理判断
# 关于其中涉及inspect模块的内容我专门写了一篇博客，如有不懂可以查看
# http://blog.csdn.net/weixin_35955795/article/details/53053762

# 这个函数将得到fn函数中的没有默认值的关键词参数的元组
def get_required_kw_args(fn):
    args = []
    # 获得函数fn的全部参数
    # inspect.signature: return a signature object for the given callable(fn or cls..)
    # a signature(签名,特征值) object represents the call signature of a function and it return annotation(注释).
    # 即一个signature对象表示一个函数或方法的调用签名,我们说两个函数的函数名,参数完全一样的,他们就是一个函数,大概call signature(调用签名)就是指这些吧
    # signature.parameters属性,返回一个参数名的有序映射
    params = inspect.signature(fn).parameters
    for name, param in params.items():
        if param.kind == inspect.Parameter.KEYWORD_ONLY and param.default == inspect.Parameter.empty:
            args.append(name)
    return tuple(args)

# 这个函数将得到fn函数中的关键词参数的元组
def get_named_kw_args(fn):
    args = []
    params = inspect.signature(fn).parameters
    for name, param in params.items():
        if param.kind == inspect.Parameter.KEYWORD_ONLY:
            args.append(name)
    return tuple(args)

# 判断fn有没有关键词参数，如果有就输出True
def has_named_kw_args(fn):
    params = inspect.signature(fn).parameters
    for name, param in params.items():
        if param.kind == inspect.Parameter.KEYWORD_ONLY:
            return True

# 判断fn有没有可变的关键词参数（**），如果有就输出True
def has_var_kw_arg(fn):
    params = inspect.signature(fn).parameters
    for name, param in params.items():
        if param.kind == inspect.Parameter.VAR_KEYWORD:
            return True

#判断fn的参数中有没有参数名为request的参数
def has_request_arg(fn):
    # 这里是把之前函数的一句语句拆分为两句，拆分原因是后面要使用中间量sig
    sig = inspect.signature(fn)
    params = sig.parameters
    found = False  # 这个函数默认输出没有参数名为request的参数
    for name, param in params.items():
        if name == 'request':
            found = True
            continue  # 下面的代码不执行，直接进入下一个循环
        # 如果找到了request参数，又找到了其他参数是POSITIONAL_OR_KEYWORD（不是VAR_POSITIONAL、KEYWORD_ONLY、VAR_KEYWORD参数）
        # request参数必须是最后一个位置和关键词参数
        if found and (param.kind != inspect.Parameter.VAR_POSITIONAL and param.kind != inspect.Parameter.KEYWORD_ONLY and param.kind != inspect.Parameter.VAR_KEYWORD):
            raise ValueError('request parameter must be the last named parameter in function: %s%s' % (fn.__name__, str(sig)))
    return found


# 定义RequestHandler类，封装url处理函数
# RequestHandler的目的是从url函数中分析需要提取的参数,从request中获取必要的参数
# 调用url参数，将结果转换位web.response
# fn就是handler中的函数
# app.router.add_route(method, path, RequestHandler(app, fn))  # 注册request handler
class RequestHandler(object): # 处理请求
    #初始化自身的属性
    def __init__(self, app, fn):
        self._app = app
        self._func = fn # handle 中 index 
        # 下面的属性是对传入的fn的参数的一些判断
        self._has_request_arg = has_request_arg(fn) # 是否有 request 参数 并且是位置参数
        self._has_var_kw_arg = has_var_kw_arg(fn) # 是否有可变参数
        self._has_named_kw_args = has_named_kw_args(fn) # 是否有关键字参数
        self._named_kw_args = get_named_kw_args(fn) # 获取关键字名字 KEYWORD_ONLY
        self._required_kw_args = get_required_kw_args(fn) #获取关键字参数 
        
    # 定义__call__参数后，其实例可以被视为函数
    # 此处参数为request
    # RequestHandle类中有__callable__方法，因此addroute中RequestHandler(app, fn)相当于创建了一个url处理函数，函数名就是fn
    async def __call__(self, request):
        kw = None    # 假设不存在关键字参数
        # 如果fn的参数有可变的关键字参数或关键字参数
        if self._has_var_kw_arg or self._has_named_kw_args or self._required_kw_args:

            # http method为post的处理
            if request.method == 'POST':
                # content_type是request提交的消息主体类型，没有就返回丢失消息主体类型
                if not request.content_type:
                    return web.HTTPBadRequest('Missing Content-Type.')
                # 把request.content_type转化为小写
                ct = request.content_type.lower()
                # application/json表示消息主体是序列化后的json字符串
                if ct.startswith('application/json'):
                    params = await request.json()  # 用json方法读取信息
                    if not isinstance(params, dict):  # 如果读取出来的信息类型不是dict
                        # 那json对象一定有问题
                        return web.HTTPBadRequest('JSON body must be object.')
                    kw = params  # 把读取出来的dict复制给kw
                # 以下2种content type都表示消息主体是表单
                elif ct.startswith('application/x-www-form-urlencoded') or ct.startswith('multipart/form-data'):
                    # request.post方法从request body读取POST参数,即表单信息,并包装成字典赋给kw变量
                    params = await request.post()
                    kw = dict(**params)
                else:  # post的消息主体既不是json对象，又不是浏览器表单，那就只能返回不支持该消息主体类型
                    return web.HTTPBadRequest('Unsupported Content-Type: %s' % request.content_type)

            # http method为get的处理 
            if request.method == 'GET':
                # request.query_string表示url中的查询字符串
                # 比如我百度ReedSun，得到网址为https://www.baidu.com/s?ie=UTF-8&wd=ReedSun
                # 其中‘ie=UTF-8&wd=ReedSun’就是查询字符串
                qs = request.query_string
                if qs:
                    kw = dict()
                    # parse.parse_qs(qs, keep_blank_values=False, strict_parsing=False)函数的作用是解析一个给定的字符串
                    # keep_blank_values默认为False，指示是否忽略空白值，True不忽略，False忽略
                    # strict_parsing如果是True，遇到错误是会抛出ValueError错误，如果是False会忽略错误
                    # 这个函数将返回一个字典，其中key是等号之前的字符串，value是等号之后的字符串但会是列表
                    # 比如上面的例子就会返回{'ie': ['UTF-8'], 'wd': ['ReedSun']}
                    for k, v in parse.parse_qs(qs, True).items():
                        kw[k] = v[0]

        # 如果经过以上处理 kw是None，即上面if语句块没有被执行
        # 则获取请求的abstract math info(抽象数学信息),并以字典形式存入kw
        # match_info主要是保存像@get('/blog/{id}')里面的id，就是路由路径里的参数
        if kw is None:
            kw = dict(**request.match_info)
        else:
            # 如果经过以上处理了，kw不为空了，而且没有可变的关键字参数，但是有关键字参数
            if not self._has_var_kw_arg and self._named_kw_args:
                # 下面五行代码的意思是将kw中key为关键字参数的项提取出来保存为新的kw
                # 即剔除kw中key不是fn的关键字参数的项
                copy = dict()
                for name in self._named_kw_args:
                    if name in kw:
                        copy[name] = kw[name]
                kw = copy
            # 遍历request.match_info(abstract math info),再把abstract math info的值加入kw中
            # 若其key即存在于abstract math info又存在于kw中,发出重复参数警告
            for k, v in request.match_info.items(): #不懂
                if k in kw:
                    logging.warning('Duplicate arg name in named arg and kw args: %s' % k)
                kw[k] = v

        # 如果fn的参数有request，则再给kw中加上request的key和值
        if self._has_request_arg:
            kw['request'] = request

        # 如果fn的参数有，没有默认值的关键字参数
        # 这个if语句块主要是为了检查一下kw
        if self._required_kw_args:
            for name in self._required_kw_args:
                # kw必须包含全部没有默认值的关键字参数，如果发现遗漏则说明有参数没传入，报错
                if not name in kw:
                    return web.HTTPBadRequest('Missing argument: %s' % name)
        # 以上过程即为从request中获得必要的参数，并组成kw
        # kw的建立过程比较繁琐，我做了一张思维导图，详见本目录下RequestHandler.png
        
        # 以下调用handler处理，并返回response        
        logging.info('call with args: %s' % str(kw))
        try:
            print("Aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
            print(self._func)
            print(self._func.__name__) 
            r = await self._func(**kw)  # 执行handler模块里的函数
            print(r)
            return r
        except APIError as e:
            return dict(error=e.error, data=e.data, message=e.message)
        
# 向app中添加静态文件目录
def add_static(app):
    # os.path.abspath(__file__), 返回当前脚本的绝对路径(包括文件名)
    # os.path.dirname(), 去掉文件名,返回目录路径
    # os.path.join(), 将分离的各部分组合成一个路径名
    # 因此以下操作就是将本文件同目录下的static目录(即www/static/)加入到应用的路由管理器中
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'static')
    # app = web.Application(loop=loop)这是在app.py模块中定义的
    app.router.add_static('/static/', path)
    logging.info('add static %s => %s' % ('/static/', path))

# 把请求处理函数注册到app
# 处理将针对http method 和path进行
# 下面的add_routes函数的一部分
def add_route(app, fn):
    method = getattr(fn, '__method__', None)  # 获取fn.__method__属性,若不存在将返回None
    path = getattr(fn, '__route__', None)     # 获取fn.__route__属性,若不存在将返回None
    if path is None or method is None:        # 如果两个属性其中之一没有值，那就会报错
        raise ValueError('@get or @post not defined in %s.' % str(fn))
    # 如果函数fn是不是一个协程或者生成器，就把这个函数编程协程
    if not asyncio.iscoroutinefunction(fn) and not inspect.isgeneratorfunction(fn):
        fn = asyncio.coroutine(fn)
    logging.info('add route %s %s => %s(%s)' % (method, path, fn.__name__, ', '.join(inspect.signature(fn).parameters.keys())))
    app.router.add_route(method, path, RequestHandler(app, fn))  # 注册request handler
    # ⚠️⚠️⚠️==========================================
    # 请求方法 路径 请求html 


    
# 将handlers模块中所有请求处理函数提取出来交给add_route自动去处理
def add_routes(app, module_name): # app.py -> add_routes -> handlers.py
    # 如果handlers模块在当前目录下，传入的module_name就是handlers
    # 如果handlers模块在handler目录下  那传入的module_name就是handler.handlers

    # Python rfind() 返回字符串最后一次出现的位置，如果没有匹配项则返回-1。
    # str.rfind(str, beg=0 end=len(string))
    # str -- 查找的字符串
    # beg -- 开始查找的位置，默认为0
    # end -- 结束查找位置，默认为字符串的长度。
    # 返回字符串最后一次出现的位置(索引数），如果没有匹配项则返回-1。
    n = module_name.rfind('.')
    if n == (-1):
        # __import__(module_name[, globals[, locals[, fromlist]]]) 可选参数默认为globals(),locals(),[]
        # 例如>>> mod = __import__("test", globals(), locals())
        #     >>> mod
        #     <module 'test' from 'C:\\Users\\shabi\\test.py'>
        mod = __import__(module_name, globals(), locals()) # 加载模块内所有全局和局部变量
        # __import__() 函数用于动态加载类和函数 。
    else: # handles 如果在文件handle下  module_name就是handler.handlers
        name = module_name[n+1:]  # 当module_name为handler.handlers时，[n+1:]就是取.后面的部分，也就是handlers
        # 下面的语句相当于执行了两个步骤，传入的module_name是aaa.bbb
        # 第一个步骤获取aaa模块的信息
        # 第二个步骤通过getattr()方法取得子模块名, 如aaa.bbb
        # gloabls locals 基于字典的访问局部变量和全局变量的方式  [:n]就是到n的索引 handle  [name]文件加下的handles
        mod = getattr(__import__(module_name[:n], globals(), locals(), [name]), name)
    # dir()不带参数时，返回当前范围内的变量、方法和定义的 类型列表；带参数时，返回参数的属性、方法列表。
    # 如果参数包含方法__dir__()，该方法将被调用。如果参数不包含__dir__()，该方法将最大限度地收集参数信息。
    for attr in dir(mod): # 返回mod对象所有的 方法 和属性
        if attr.startswith('_'):
            continue
        # 排除私有属性之后，用getattr调用handlers模块里的属性（方法）
        # fn就是handlers里的函数
        fn = getattr(mod, attr)  #getattr() 函数用于返回一个对象属性值 和 方法。
        if callable(fn):  # 查看提取出来的属性是不是函数
            method = getattr(fn, '__method__', None) # 获取对象属性 通过装饰器动态加载
            path = getattr(fn, '__route__', None) # 
            # 如果是函数，再判断是否有__method__和__route__属性，如果存在则使用app_route函数注册
            if method and path:
                add_route(app, fn) # 得到属性后调用 add_route


# add_route(app,model_name)
# rfind('.')判断模块是否在文件夹下 
# 在当前目录下就加载得到模块mod __import__(module_name, globals(), locals()) 
# 不在当前通过getattr获取自模块名 getattr(__import__(module_name[:n], globals(), locals(), [name]), name)

# 获取模块后遍历 dir(mod) 里面的属性名 和 方法名
# 通过callable() 判断 dir(mod) 遍历出的方法   handles 里的 index 函数 通过get装饰器 动态加载的属性 __method__ __route__'
# 获取属性 调用add_route