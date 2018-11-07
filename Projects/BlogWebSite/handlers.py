#!/usr/bin/env python3
# -*- coding: utf-8 -*-
__author__ = 'Michael Liao'
' url handlers '
import re, time, json, logging, hashlib, base64, asyncio
from coroweb import get, post
from models import User, Comment, Blog, next_id


# @get('/') # 通过装饰器动态的添加属性     index.__route__   index.__method__
#async def index(request):
#    users = await User.findAll()     # 获取所有表的信息
#    return {
#        '__template__': 'test.html', # 返回字典 
#        'users': users
#    }

@get('/')
def index(request):
    summary = 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
    blogs = [
        Blog(id='1', name='Test Blog', summary=summary, created_at=time.time()-120),
        Blog(id='2', name='Something New', summary=summary, created_at=time.time()-3600),
        Blog(id='3', name='Learn Swift', summary=summary, created_at=time.time()-7200)
    ]
    return {
        '__template__': 'blogs.html',
        'blogs': blogs
    }