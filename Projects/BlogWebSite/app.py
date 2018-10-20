#!/usr/bin/env python3
# -*- coding: utf-8 -*-
'''
async web application.
'''

import logging; logging.basicConfig(level=logging.INFO)

import asyncio, os, json, time
from datetime import datetime

from aiohttp import web
from jinja2 import Environment, FileSystemLoader

import orm
from coroweb import add_routes, add_static

def init_jinja2(app, **kw):
    logging.info('init jinja2...')
    options = dict( # 设置解析模板需要用到的环境变量 主要有 自动转换特殊字符 {%命令%} {{变量}}  重载
        autoescape = kw.get('autoescape', True), # 自动转义xml/html的特殊字符
        block_start_string = kw.get('block_start_string', '{%'),# 设置代码起始字符串
        block_end_string = kw.get('block_end_string', '%}'), # {{ name }}表示一个需要替换的变量 用{% ... %}表示指令
        variable_start_string = kw.get('variable_start_string', '{{'),
        variable_end_string = kw.get('variable_end_string', '}}'),
        auto_reload = kw.get('auto_reload', True)# 当模板文件被修改后，下次请求加载该模板文件的时候会自动加载修改后的模板文件
    )
    path = kw.get('path', None) # 关键字参数 path 如果没有定义为None
    if path is None: # 获取文件路径 templates 路径
        path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'templates')
    logging.info('set jinja2 template path: %s' % path)
    env = Environment(loader=FileSystemLoader(path), **options)  # 到指定目录文件夹下去加载模版文件 
    filters = kw.get('filters', None)
    if filters is not None:
        for name, f in filters.items():
            env.filters[name] = f # 在env中添加过滤器
    app['__templating__'] = env 
    ## 前面已经把jinjia2的环境配置都赋值给env了，这里再把env存入app的dict中，这样app就知道要去哪找模板，怎么解析模板

# 这个函数的作用就是当http请求的时候，通过logging.info输出请求的信息，其中包括请求的方法和路径
async def logger_factory(app, handler):
    async def logger(request):
        logging.info('Request: %s %s' % (request.method, request.path))
        # await asyncio.sleep(0.3)
        return (await handler(request))
    return logger

# 只有当请求方法为POST时这个函数才起作用
async def data_factory(app, handler):
    async def parse_data(request):
        if request.method == 'POST':
            if request.content_type.startswith('application/json'):
                request.__data__ = await request.json()
                logging.info('request json: %s' % str(request.__data__))
            elif request.content_type.startswith('application/x-www-form-urlencoded'):
                request.__data__ = await request.post()
                logging.info('request form: %s' % str(request.__data__))
        return (await handler(request))
    return parse_data 

# 处理视图函数返回值，制作response的middleware 一个视图函数，简称视图，是一个简单的Python 函数，它接受Web请求并且返回Web响应。
# 请求对象request的处理工序：logger_factory => response_factory => RequestHandler().__call__ => handler
# 响应对象response的处理工序：  
# 1、由视图函数处理request后返回数据  
# 2、@get@post装饰器在返回对象上附加'__method__'和'__route__'属性，使其附带URL信息  
# 3、response_factory对处理后的对象，经过一系列类型判断，构造出真正的web.Response对象  
async def response_factory(app, handler):
    async def response(request):
        logging.info('Response handler...')
        r = await handler(request)
        # 如果相应结果为StreamResponse，直接返回
        # StreamResponse是aiohttp定义response的基类,即所有响应类型都继承自该类
        # StreamResponse主要为流式数据而设计
        if isinstance(r, web.StreamResponse):
            return r
        # 如果相应结果为字节流，则将其作为应答的body部分，并设置响应类型为流型
        if isinstance(r, bytes): 
            resp = web.Response(body=r)
            # Content-Type，用于定义网络文件的类型和网页的编码，决定文件接收方将以什么形式、什么编码读取这个文件
            resp.content_type = 'application/octet-stream'
            return resp
        # 如果响应结果为字符串
        if isinstance(r, str):
            # 判断响应结果是否为重定向，如果是，返回重定向后的结果
            # 重定向 redirect 将各种网络请求重新定个方向转到其它位置
            if r.startswith('redirect:'):
                return web.HTTPFound(r[9:]) # 即把r字符串之前的"redirect:"去掉
            resp = web.Response(body=r.encode('utf-8')) # 然后以utf8对其编码，并设置响应类型为html型
            resp.content_type = 'text/html;charset=utf-8'
            return resp
        # 如果响应结果是字典，则获取他的jinja2模板信息，此处为jinja2.env
        if isinstance(r, dict):
            template = r.get('__template__')
        # 若不存在对应模板，则将字典调整为json格式返回，并设置响应类型为json
        # ensure_ascii：默认True，仅能输出ascii格式数据。故设置为False。  
        # default：r对象会先被传入default中的函数进行处理，然后才被序列化为json对象  
        # __dict__：以dict形式返回对象属性和值的映射  
            if template is None: # 不带模板信息，返回json对象 
                resp = web.Response(body=json.dumps(r, ensure_ascii=False, default=lambda o: o.__dict__).encode('utf-8'))
                resp.content_type = 'application/json;charset=utf-8'
                return resp
            else:
                # 带模板信息，渲染模板  
                # app['__templating__']获取已初始化的Environment对象，调用get_template()方法返回Template对象  
                # 调用Template对象的render()方法，传入r渲染模板，返回unicode格式字符串，将其用utf-8编码  
                resp = web.Response(body=app['__templating__'].get_template(template).render(**r).encode('utf-8'))
                resp.content_type = 'text/html;charset=utf-8'
                return resp
        # 如果响应结果为整数型，且在100和600之间
        # 则此时r为状态码，即404，500等
        if isinstance(r, int) and r >= 100 and r < 600:
            return web.Response(r)
        # 如果响应结果为长度为2的元组
        # 元组第一个值为整数型且在100和600之间
        # 则t为http状态码，m为错误描述，返回状态码和错误描述
        if isinstance(r, tuple) and len(r) == 2:
            t, m = r
            if isinstance(t, int) and t >= 100 and t < 600:
                return web.Response(t, str(m))
        # default:
        resp = web.Response(body=str(r).encode('utf-8'))
        resp.content_type = 'text/plain;charset=utf-8'
        return resp
    return response

# 时间过滤器，作用是返回日志创建的时间，用于显示在日志标题下面
def datetime_filter(t):
    delta = int(time.time() - t)
    if delta < 60:
        return u'1分钟前'
    if delta < 3600:
        return u'%s分钟前' % (delta // 60)
    if delta < 86400:
        return u'%s小时前' % (delta // 3600)
    if delta < 604800:
        return u'%s天前' % (delta // 86400)
    dt = datetime.fromtimestamp(t)
    return u'%s年%s月%s日' % (dt.year, dt.month, dt.day)

# 调用asyncio实现异步IO
async def init(loop):
    await orm.create_pool(loop=loop, host='127.0.0.1', port=3306, user='root', password='team3dstar', db='awesome')
    # 创建app对象，同时传入上文定义的拦截器middlewares 使用模版 
    # resp = web.Response(body=app['__templating__'].get_template(template).render(**r).encode('utf-8'))
    # resp.content_type = 'text/html;charset=utf-8'
    # return resp
    app = web.Application(loop=loop, middlewares=[ logger_factory, response_factory ])
    # 初始化jinja2模板，并传入时间过滤器  app['__templating__'] = env  模版路径等配置信息存入app
    init_jinja2(app, filters=dict(datetime=datetime_filter))
    # 获取请求返回 返回test.html 和数据库 user 参数
    add_routes(app, 'handlers')
    #  根据 handlers 模块注册 app.router.add_route(method, path, RequestHandler(app, fn))调用 __call__ 此时的app已经设置好模版 可以读取dict
    #  r = await self._func(**kw)  
    #  执行handler模块里的函数 返回 {__temolate__ : tesst.html}   这样当有请求的时候要获取设么样的内容就由handles处理 
    add_static(app)
    srv = await loop.create_server(app.make_handler(), '127.0.0.1', 9000)
    logging.info('server started at http://127.0.0.1:9000...')
    return srv

loop = asyncio.get_event_loop()
loop.run_until_complete(init(loop))
loop.run_forever()