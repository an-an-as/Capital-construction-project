/**
 + 该模式涉及到一个单一的类，该类负责创建自己的对象，同时确保只有单个对象被创建。
 + 这个类提供了一种访问其唯一的对象的方式，可以直接访问，不需要实例化该类的对象。
 
 + 单例类只能有一个实例。
 + 单例类必须自己创建自己的唯一实例。
 + 单例类必须给所有其他对象提供这一实例。
 ----
 
 + 意图：保证一个类仅有一个实例，并提供一个访问它的全局访问点。
 + 主要解决：一个全局使用的类频繁地创建与销毁。
 + 何时使用：当您想控制实例数目，节省系统资源的时候。
 + 如何解决：判断系统是否已经有这个单例，如果有则返回，如果没有则创建。
 + 关键代码：构造函数是私有的。
 + 应用实例：
 + 1、一个党只能有一个书记。
 + 2、Windows 是多进程多线程的，在操作一个文件的时候，就不可避免地出现多个进程或线程同时操作一个文件的现象，所以所有文件的处理必须通过唯一的实例来进行。
 + 3、一些设备管理器常常设计为单例模式，比如一个电脑有两台打印机，在输出的时候就要处理不能两台打印机打印同一个文件。
 + 优点：
 + 1、在内存里只有一个实例，减少了内存的开销，尤其是频繁的创建和销毁实例（比如管理学院首页页面缓存）。
 + 2、避免对资源的多重占用（比如写文件操作）。
 + 缺点：没有接口，不能继承，与单一职责原则冲突，一个类应该只关心内部逻辑，而不关心外面怎么样来实例化。
 + 使用场景：
 + 1、要求生产唯一序列号。
 + 2、WEB 中的计数器，不用每次刷新都在数据库里加一次，用单例先缓存起来。
 + 3、创建的一个对象需要消耗的资源过多，比如 I/O 与数据库的连接等。
 
 注意事项：getInstance() 方法中需要使用同步锁 synchronized (Singleton.class) 防止多线程同时进入造成 instance 被多次实例化。
 */

//使用GCD来创建单例
//dispatch_once_t swift3.0 deprecated!
import Foundation
func getBufferAddress<T>(of array: [T]) -> String {
    return array.withUnsafeBufferPointer{ buffer in
        return String(describing: buffer.baseAddress)
    }
}
class SingletonManager {
    static private var onceToken: dispatch_once_t = 0
    static private var staticInstance: SingletonManager? = nil
    static func sharedInstance() -> SingletonManager {
        dispatch_once(&onceToken) {
            staticInstance = SingletonManager()
        }
        return staticInstance!
    }
    private init() {}
}

let single1 = SingletonManager.sharedInstance()
let single2 = SingletonManager.sharedInstance()
unsafeAddressOf(single1)
unsafeAddressOf(single2)


//version2 利用静态存储属性进行创建
public class SingletonPattern {
    static private let instance = SingletonPattern()
    static public func sharedInstance() -> SingletonPattern {
        return instance
    }
    init() {}
}
func address<T>(_ point: T) -> String {
    return String.init(format: "%018p", unsafeBitCast(point, to: Int.self))
}
let singleton1 = SingletonPattern.sharedInstance()
let singleton2 = SingletonPattern.sharedInstance()
print(address(singleton1)) // 0x0000000100f11ae0
print(address(singleton2)) // 0x0000000100f11ae0
