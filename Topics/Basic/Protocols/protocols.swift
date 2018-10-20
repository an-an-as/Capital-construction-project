//类型抹消
public protocol IteratorProtocol {
    associatedtype Element
    public mutating func next() -> Element?
}
struct ConstantIterator: IteratorProtocol {
    mutating func next() -> Int? {
        return 1
    }
}
let iterator: IteratorProtocol = ConstantIterator()




class IntIterator {
    var nextImpl: () -> Int?
    init<I: IteratorProtocol>(_ iterator: I) where I.Element == Int {
        var iteratorCopy = iterator
        self.nextImpl = { iteratorCopy.next() }
    }
}
var iter = IntIterator(ConstantIterator())
iter = IntIterator([1,2,3].makeIterator())

/// 具体的迭代器类型 (I) 只在初始化函数中被使用，在那之后，它被“抹消”了
/// 类型系统会将关联类型推断为 Int
extension IntIterator: IteratorProtocol {
    func next() -> Int? {
        return nextImpl()
    }
}
class AnyIterator<A>: IteratorProtocol {
    var nextImpl: () -> A?
    init<I: IteratorProtocol>(_ iterator: I) where I.Element == A {
        var iteratorCopy = iterator
        self.nextImpl = { iteratorCopy.next() }
    }
    func next() -> A? {
        return nextImpl()
    }
}
/// 创建类型抹消的简单算法:
/// 首先，我们创建一个名为 AnyProtocolName 的结构体或者类。然后，对于每个关联类型，我们添加一个泛型参数。
/// 接下来，对于协议的每个方法，我们将其实现存储在 AnyProtocolName 中的一个属性中。最后，我们添加一个将想要抹消的具体类型泛型化的初始化方法；
/// 它的任务是在闭包中捕获我们传入的对象，并将闭包赋值给上面步骤中的属性。

///对于像 IteratorProtocol 这样的简单协议，这只需要很少的几行代码，但是对于更复杂的协议 (比如 Sequence)，就有很多事情要做了。
///更糟糕的是，因为每有一个协议方法，就需要一个新的属性与其对应，所以对象或者结构体占用的尺寸会随着协议方法数量的增加而线性增长。
///标准库采用了一种不同的策略来处理类型抹消：它使用了类继承的方式，来把具体的迭代器类型隐藏在子类中，同时面向客户端的类仅仅只是对元素类型的泛型化类型。
struct ConstantIterator: IteratorProtocol {
    mutating func next() -> Int? {
        return 1
    }
}
class IteratorBox<Element>: IteratorProtocol {
    func next() -> Element? {
        fatalError("This method is abstract.")
    }
}
class IteratorBoxHelper<I: IteratorProtocol>: IteratorBox<I.Element> {
    var iterator: I
    init(_ iterator: I) {
        self.iterator = iterator
    }
    override func next() -> I.Element? {
        return iterator.next()
    }
}
let iter: IteratorBox<Int> = IteratorBoxHelper(ConstantIterator())







//存在盒子
///通过协议类型创建一个变量的时候，这个变量会被包装到一个叫做存在容器的盒子中
func f<C: CustomStringConvertible>(_ x: C) -> Int { ///协议当作范型参数
    return MemoryLayout.size(ofValue: x)
}
func g(_ x: CustomStringConvertible) -> Int { ///协议当作类型
    return MemoryLayout.size(ofValue: x)
}
f(5) /// 8      f 接受的是泛型参数，整数 5 会被直接传递给这个函数，而不需要经过任何包装。所以它的大小是 8 字节,也就是 64 位系统中 Int 的尺寸
g(5) /// 40
/// 对于 g，整数会被封装到一个存在容器中。对于普通的协议 (也就是没有被约束为只能由 class 实现的协议)，会使用不透明存在容器 (opaque existential container)
/// 不透明存在容器中含有一个存储值的缓冲区 (大小为三个指针，也就是 24 字节)
/// 一些元数据 (一个指针，8 字节)；以及若干个目击表 (0 个或者多个指针，每个 8 字节)。如果值无法放在缓冲区里，那么它将被存储到堆上，缓冲区里将变为存储引用，它将指向值在堆上的地址。
/// 元数据里包含关于类型的信息 (比如是否能够按条件进行类型转换等)


/// 目击表是让动态派发成为可能的关键。它为一个特定的类型将协议的实现进行编码：对于协议中的每个方法，表中会包含一个指向特定类型中的实现的入口。有时候这被称为 vtable。
/// addCircle 不是协议定义的一部分 (或者说，它不是协议所要求实现的内容)，所以它也不在目击表中。
/// 因此，编译器除了静态地调用协议的默认实现以外，别无选择。一旦我们将 addCircle 添加为协议必须实现的方法，它就将被添加到目击表中，于是我们就可以通过动态派发对其进行调用了

/// 不透明存在容器的尺寸取决于目击表个数的多少，每个协议会对应一个目击表
