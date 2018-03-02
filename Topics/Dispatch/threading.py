import time, threading
def loop():
    n = 0
    while n < 5:
        n = n + 1
        time.sleep(1)

t = threading.Thread(target=loop, name='LoopThread')
t.start()
t.join()
