import inspect
def a(a, b=0, *c, d, e=1, **f): 
    pass
aa = inspect.signature(a) # 获取函数的表达签名
print("inspect.signature（fn)是:%s" % aa) # 

bb = aa.parameters # [(获取所有参数)]
for name ,parameter in bb.items(): 
    print(name,parameter) # name: a b c d e f parameter 具体映射 a b=0 *c d e=1 **f
print("signature.paramerters属性是:%s" % bb)
print("ignature.paramerters属性的类型是%s" % type(bb)) # mappingproxy 映射代理
print("\n")

for cc, dd in bb.items(): # 映射代理
    print("mappingproxy.items()返回的两个值分别是：%s和%s" % (cc, dd)) # a 和 a b和b=0 c 和 *c
    print("mappingproxy.items()返回的两个值的类型分别是：%s和%s" % (type(cc), type(dd))) # 'str' inspect.Parameter'
    print("\n")
    ee = dd.kind # 参数所属种类 a b 位置参数 c可变位置参数 后面 是制定关键字参数 最后**f是 可变关键字参数
    print("Parameter.kind属性是:%s" % ee) 
    #  POSITIONAL_OR_KEYWORD (a,b=0)  VAR_POSITIONAL(*c) KEYWORD_ONLY(d 在*c后 指定关键字参数 e) VAR_KEYWORD(**f)
    print("Parameter.kind属性的类型是:%s" % type(ee))# enum '_ParameterKind'
    print("\n")
    gg = dd.default# 参数的默认值  分别是 0  1 inspect._empty inspect._empty  1 inspect._empty
    print("Parameter.default的值是: %s" % gg) 
    print("Parameter.default的属性是: %s" % type(gg))
    print("\n")


ff = inspect.Parameter.KEYWORD_ONLY
print("inspect.Parameter.KEYWORD_ONLY的值是:%s" % ff)
print("inspect.Parameter.KEYWORD_ONLY的类型是:%s" % type(ff))