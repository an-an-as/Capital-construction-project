import asyncio
import aiomysql

loop = asyncio.get_event_loop()

async def test_example():
    conn = await aiomysql.connect(host='127.0.0.1', port=3306,
                                       user='root', password='team3dstar', db='Demo',
                                       loop=loop)

    cur = await conn.cursor(aiomysql.DictCursor) # 创建光标对象 返回结果默认是元祖 可设置字典
   # await cur.execute("SELECT User,Host FROM user") # 光标执行 显示用户名
    await cur.execute("SHOW DATABASES") # execute(query, args=None)
    await cur.execute("USE Demo")
    await cur.execute("SHOW TABLES")
    await cur.execute("SELECT * FROM websites")
    print(cur.description)
    print(cur.rowcount)  # 有多少行
    print(cur.rownumber) # 行索引。这个只读属性提供了在结果集中游标的当前基于0的索引，如果不能确定索引，则不提供该索引。
    print(cur.lastrowid) 
    # 这个只读属性返回以前的INSERT或UPDATE语句生成的AUTO_INCREMENT列的值，
    # 或者在没有这样的值时没有返回值。例如，如果您对包含AUTO_INCREMENT列的表执行插入操作，
    # 那么光标。lastrowid返回新行的AUTO_INCREMENT值。
    print(cur.arraysize)
    # 将通过Cursor.fetchmany()调用返回多少行。
    # 这个读/写属性指定一次使用Cursor.fetchmany()的行数。它默认值为1，每次取一行。
    r = await cur.fetchall()
    print(r)
    await cur.close() # 结束输入
    conn.close()      # 结束链接

loop.run_until_complete(test_example())