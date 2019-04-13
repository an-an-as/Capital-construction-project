/************************************   Sequence&Iterator   ********************************/
// Sequence 代表一系列具有相同类型的值，可以对其迭代
// Iterator 序列通过创建一个迭代器来提供对元素的访问。迭代器每次产生一个序列的值，并且当遍历序列时对遍历状态进行管理。

//protocol
protocol Sequence {
    associatedtype Iterator : IteratorProtocol
    //Iterator不能和某个具体的序列类型相关，需要把这些信息抽象成一个protocol
    func makeIterator() -> Iterator
    //通过该方法能够依序遍历集合类型的每个元素，而又无需暴露该集合类型的内部表达方式
}
protocol IteratorProtocol {
    associatedtype Element
    mutating func next() -> Element?
    //单向,可以保存当前遍历状态,遍历结束返回nil
}


//like for-in
let numbers = [1, 2, 3, 4, 5]
var numInterator = numbers.makeIterator()
while let num = numInterator.next() { print(num) }


//example-1 无限序列
struct FiboIterator: IteratorProtocol {
    var state = (0, 1)
    mutating func next() -> Int? {
        let nextValue = state.0
        state = (state.1, state.0 + state.1)
        return nextValue
    }
}

struct Fibonacci: Sequence {
    func makeIterator() -> FiboIterator {
        return FiboIterator()
    }
}
let fib = Fibonacci()
var fibIter = fib.makeIterator()
var i = 1
while let value = fibIter.next(), i != 10 {
    print(value)
    i += 1
}

//example-2 有限序列
struct PrefixIterator: IteratorProtocol {
    let string: String
    var offset: String.Index
    init(string: String) {
        self.string = string
        offset = string.startIndex
    }
    mutating func next() -> Substring? {
        guard offset < string.endIndex else { return nil }
        offset = string.index(after: offset)
        return string[..<offset]
    }
}
struct PrefixSequence: Sequence {
    let string: String
    func makeIterator() -> PrefixIterator {
    return PrefixIterator(string: string)
    }
}
for prefix in PrefixSequence(string: "Hello") { print(prefix) }
PrefixSequence(string: "Hello").map { $0.uppercased() }
// ["H", "HE", "HEL", "HELL", "HELLO"]”



//不稳定序列
//Don’t assume that multiple for-in loops on a sequence will either resume iteration or restart from the beginning.
//一个非集合的序列可能会在第二次 for-in 循环时产生随机的序列元素
//Iterator有时就是一个Sequence会消耗自身 同时遵守 IteratorProtocol, Sequence 后 带有默认的 makeIterator
//如果需要调用makeIterator方法获得一个单独的遍历并保存状态的对象 另外需要一个单独的对象来完成遍历任务 就要分开sequence 和 iterator 这样，无论我们遍历多少次，结果都会是一样的



//子序列
let fibo1 = Fibonacci().prefix(10)
// [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]

let fibo2 = Fibonacci().prefix(10).suffix(5)
// [5, 8, 13, 21, 34]

// 其次，是dropFirst&dropLast，用来访问序列中除去开始或结束的n个元素后，剩余的部分；
let fibo3 = Fibonacci().dropFirst(10).prefix(10)
// [5, 8, 13, 21, 34, 55, 89, 144, 233, 377]

let fibo4 = Fibonacci().prefix(10).dropLast(5)
// [0, 1, 1, 2, 3]

// 最后，是split，用于把序列按照特定的条件进行分割，并返回一个数组，数组中的每个元素，都是分割后的子序列：
let fiboArray = fibo1.split(whereSeparator: { $0 % 2 == 0 })
// 1 1 | 3 5 | 13 21

//比较首尾是否相同
extension Sequence where Element: Equatable, SubSequence: Sequence,SubSequence.Element == Element {
    func headMirrorsTail(_ n: Int) -> Bool {
        let head = prefix(n)
        let tail = suffix(n).reversed()
        return head.elementsEqual(tail)
    }
}
[1,2,3,4,2,1].headMirrorsTail(2) // true





/************************************   AnySequence&AnyIterator   ********************************/
//值语意
let seq = stride(from: 0, to: 10, by: 1)
var i1 = seq.makeIterator()
i1.next() // Optional(0)
i1.next() // Optional(1)

var i2 = i1
i1.next() // Optional(2)
i1.next() // Optional(3)
i2.next() // Optional(2)
i2.next() // Optional(3)

//引用语意
var i3 = AnyIterator(i1)
var i4 = i3
i3.next() // Optional(4)
i4.next() // Optional(5)
i3.next() // Optional(6)
i3.next() // Optional(7)

//基于函数
func fiboIterator() -> AnyIterator<Int> {
    var state = (0, 1)
    return AnyIterator {
        let theNext = state.0
        state = (state.1, state.0 + state.1)
        return theNext
    }
}
let fiboSequence = AnySequence(fiboIterator)
Array(fiboSequence.prefix(10))
// [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]


let tenToOne = sequence(first: 10, next: {
    guard $0 != 1 else { return nil }
    return $0 - 1
})
Array(tenToOne)
//[10, 9, 8, 7, 6, 5, 4, 3, 2, 1]


let fiboSequence2 = sequence(state: (0, 1), next: { (state: inout (Int, Int)) -> Int? in
    let theNext = state.0
    state = (state.1, state.0 + state.1)
    return theNext
})
Array(fiboSequence2.prefix(10))
// 返回类型:UnfoldSequence  在函数式编程中 reduce 又常被叫做 fold。reduce 将一个序列缩减 (或者说折叠) 为一个单一的返回值，而 sequence 则将一个单一的值展开形成一个序列
