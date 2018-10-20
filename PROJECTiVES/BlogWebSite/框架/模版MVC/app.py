#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from flask import Flask, request, render_template

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def home():
    return render_template('home.html')# Flask通过render_template()函数来实现模板的渲染 Flask默认支持jinja2
# 在Jinja2模板中， {{ name }}表示一个需要替换的变量 用{% ... %}表示指令
@app.route('/signin', methods=['GET']) 
def signin_form():
    return render_template('form.html')

@app.route('/signin', methods=['POST'])
def signin():# 获取HTML内 username 的值
    username = request.form['username'] # <p><input name="username" placeholder="Username" value="{{ username }}"></p>
    password = request.form['password'] # 获取HTML内容
    if username=='admin' and password=='password':
        return render_template('signin-ok.html', username=username)
    return render_template('form.html', message='Bad username or password', username=username)
    # 渲染登陆表  {% if message %}
    #<p style="color:red">{{ message }}</p>
    #{% endif %}
    # <p>Welcome, {{ username }}!</p>
if __name__ == '__main__':
    app.run()