import asyncio
# asyncio可以实现单线程并发IO操作。
from aiohttp import web # http://aiohttp.readthedocs.io/en/stable/index.html#
# 利用 aiohttp 来构造一个最简单的web服务器
loop = asyncio.get_event_loop()


async def index(request):
    await asyncio.sleep(0.5)
    return web.Response(body=b'<h1>HELLO WORLD</h1>', content_type='text/html')

# 第一步，编写一个用@asyncio.coroutine装饰的函数：
# 第二步，传入的参数需要自己从request中获取：
# 最后，需要自己构造Response对象
async def hello(request):
    await asyncio.sleep(0.5)
    text = '<h1>hello, %s!</h1>' % request.match_info['name']
    return web.Response(body=text.encode('utf-8'), content_type='text/html')

async def init(loop):# 协程的线程池
    app = web.Application(loop=loop)
    app.router.add_route('GET', '/', index) # 获取
    app.router.add_route('GET', '/hello/{name}', hello) # {需要的参数}    http://127.0.0.1:8000/hello/word
    srv = await loop.create_server(app.make_handler(), '127.0.0.1', 8000)
    print('Server started at http://127.0.0.1:8000...')
    return srv


loop.run_until_complete(init(loop))
loop.run_forever()
# 