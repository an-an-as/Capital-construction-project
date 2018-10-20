#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
Override configurations.
'''

# 用来覆盖某些默认设置： config_default.py作为开发环境的标准配置，把config_override.py作为生产环境的标准配置
configs = {
    'db': {
        'host': '127.0.0.1'
    }
}