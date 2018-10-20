func foo() {
    defer {
        print("finally")
    }
    do {
        throw NSError()
        print("impossible")
    } catch {
        print("handle error")
    }
}
///函数 return 前执行 defer 。在这个例子里，就是先 print 出 "handle error" 再 print 出 "finally"。

//清理
func foo() {
    let fileDescriptor = open(url.path, O_EVTONLY)
    defer {
        close(fileDescriptor)
    }
    // use fileDescriptor...
}

//解锁
func foo() {
    objc_sync_enter(lock)
    defer {
        objc_sync_exit(lock)
    }
    // do something...
}

func foo(completion: () -> Void) {
    defer {
        self.isLoading = false
        completion()
    }
    guard error == nil else { return }
    // handle success
}
func foo() {
    print("1")
    defer {
        print("6")
    }
    print("2")
    defer {
        print("5")
    }
    print("3")
    defer {
        print("4")
    }
}//123456
