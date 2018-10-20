/** ------------------------------------------------------------------------------
 
 ## 使用迭代器替代数组的情况
 + 数字接近无穷的时候可能不想对数组中所有的元素进行计算、或者并不想使用全部的元素;
 + 单纯的表达可以被顺序访问的一系列数据(非Array);
 + 一个 for 循环中，数组会被从头遍历到尾。如果要用 _不同的顺序_ 对数组进行遍历这时，迭代器就可能派上用场
 
 ````
 let numbers = [1, 2, 3, 4, 5]
 for _ in numbers { }
 ````
 
 为了抽象上述过程，一个核心思想就是得提供一种方法(iteratorProtocol)，使之能够依序遍历集合类型的每个元素，而又无需暴露该集合类型的内部表达方式(SequenceProtocol)。
 假设,我们管这种方法叫做Iterator，那么，顺序访问集合元素这个行为就可以抽象成一个protocol,这样就表示，所有遵从了Sequence protocol的类型，都提供了一个makeIterator方法.
 我们可以用这个方法返回的一个叫做Iterator类型的对象来顺序访问集合类型中的每一个元素。 通过IteratorProtocol，Sequence很好的把各种不同形式的数据访问细节隐藏了起来。
 
 
 ## 序列
 + Sequence 协议是集合类型结构中的基础。一个序列 (sequence) 代表的是一系列具有相同类型的值，你可以对这些值进行迭代。
 + Sequence 协议提供了许多强大的功能，满足该协议的类型都可以直接使用这些功能。
 
 ## 迭代器
 + 序列通过创建一个迭代器来提供对元素的访问。迭代器每次产生一个序列的值，并且当遍历序列时对遍历状态进行管理。
 
 
 ## 存储容器和访问方法的胶着剂 --- Iterator
 ### Iterator要完成的任务:
 1. Iterator要知道序列中元素的类型；
 2. Iterator还要有一个可以不断访问下一个元素的方法；
 
 由于Iterator不能和某个具体的序列类型相关，需要把这些信息抽象成一个protocol：
 
 ````
 protocol IteratorProtocol {
 associatedtype Element
 mutating func next() -> Element?
 }
 ````
 
 在Sequence定义里，让Iterator遵从IteratorType：
 
 ````
 protocol Sequence {
 associatedtype Iterator : IteratorProtocol
 func makeIterator() -> Iterator
 }
 ````
 
 
 当我们通过遵从Sequence实现一个支持顺序访问的序列类型时，也必须要自己实现一个与之搭配的Iterator，这个Iterator一定是对序列类型的内部形态了如指掌的，
 因为，它需要提供一个可以保存当前遍历状态，并返回遍历值的方法next，当遍历结束时，next返回nil。
 
 然后，对于所有遵从了Sequence的序列类型，我们就有了一个顺序遍历的套路：
 1. 调用makeIterator获得表达序列起始位置的Iterator；
 2. 不断调用next方法，顺序遍历序列的每一个元素；
 
 实际上，我们并不用自己定义上面的Sequence和IteratorProtocol，这里只是演示这个抽象构思的过程。
 Swift标准库中，对于支持顺序访问的序列类型，就是这样通过protocol来约束的。并且，Swift中的Array就是遵从Sequence protocol的类型。我们可以这样来遍历它：
 
 ```
 let numbers = [1, 2, 3, 4, 5]
 var begin = numbers.makeIterator()
 while let number = begin.next() {
 print(number)
 }
 ```
 
 - Note:
 1. 从概念上来说，一个迭代器是每次根据请求生成数组新元素的过程 任何类型只要遵守IteratorProtocol协议，那么它就是一个迭代器
 2. 这个协议需要一个由 IteratorProtocol 定义的关联类型：Element，以及一个用于产生新元素的 next 方法，需要每次调用返回下一个值 序列耗尽返回nil
 
 - Attention:
 1. Iterator.next只能够单次向前遍历序列，无法使用同一个Iterator对象在序列类型中反复遍历。
 2. 也就是说，IteratorProtocol只约定了可以顺序访问序列类型的最小行为集合。
 
 ---------------------------------------------------------------------------------*/

//Fibonacci
struct FiboIterator: IteratorProtocol {
    var state = (0, 1)
    mutating func next() -> Int? {
        let nextValue = state.0               ///返回元组的第一个数
        state = (state.1, state.0 + state.1)  ///斐波那契数列 下一个数 是前面数的和
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

//逆向计算
struct ReverseIndexIterator: IteratorProtocol {
    var index: Int
    init<T>(array: [T]) {
        index = array.index(before: array.endIndex)
    }
    ///迭代器却封装了数组序列值的计算
    mutating func next() -> Int? {
        guard index >= 0 else { return nil }
        defer { index -= 1 }
        return index
    }
}
let letters = ["A", "B", "C"]
var iterator = ReverseIndexIterator(array: letters)
while let i = iterator.next() {
    print("Element \(i) of the array is \(letters[i])")
}

/**
 Element 2 of the array is C
 Element 1 of the array is B
 Element 0 of the array is A */


///在某些情况下，迭代器并不需要生成 nil 值。比如，我们可以定义一个迭代器用来生成“无数个”二的幂值 (直到该值变为某个极大值，致使 NSDecimalNumber 溢出)
struct PowerIterator: IteratorProtocol {
    var power: NSDecimalNumber = 1
    mutating func next() -> NSDecimalNumber? {
        power = power.multiplying(by: 2)
        return power
    }
}
///可以使用 PowerIterator 来检视增长中的大数组序列值 比如，在实现一个在每次迭代都为数组序列值乘以二的指数搜索算法时我们就需要这么做
extension PowerIterator {
    mutating func find(where predicate: (NSDecimalNumber) -> Bool) -> NSDecimalNumber? {
        while let x = next() {
            if predicate(x) { return x }
        }
        return nil
    }
}
///计算二的幂值中大于 1000 的最小值
var powerIterator = PowerIterator()
_ = powerIterator.find { $0.intValue > 1000 } /// Optional(1024)

///生成其它类型的迭代器
///通定义迭代器将数据的生成与使用分离开来。生成过程可能会涉及到打开一个文件或是一个 URL，并且会处理过程中抛出的错误。
///将这些隐藏在一份简单的迭代器协议之后，可以确保用代码去操作生成的数据时，不必再考虑这些问题。我们的实现方案甚至可以让我们逐行读取文件，而且对于迭代器的使用者来说，他们的代码可以保持不变。”
struct FileLinesIterator: IteratorProtocol {
    let lines: [String]
    var currentLine: Int = 0
    init(filename: String) throws {
        let contents: String = try String(contentsOfFile: filename)///init(contentsOfFile path: String) throws
        lines = contents.components(separatedBy: .newlines)///func components(separatedBy separator: CharacterSet) -> [String]
    }
    mutating func next() -> String? {
        guard currentLine < lines.endIndex else { return nil }
        defer { currentLine += 1 }
        return lines[currentLine]
    }
}

///编写一些适用于所有迭代器的泛型函数
extension IteratorProtocol {
    mutating func find(predicate: (Element) -> Bool) -> Element? {
        while let x = next() { if predicate(x) { return x }
        }
        return nil
    }
}
///由于调用了 next，迭代器可能会被 find 方法修改，所以我们需要在类型声明中添加 mutating 标注。
///查询条件应当是一个可以将生成元素映射为布尔值的函数。如果需要引用迭代器中的类型，我们可以使用它的关联类型 Element。
///最后，注意我们查询一个符合条件的值是可能失败的。为此，find 会返回一个可选值，在迭代器被耗尽时返回 nil。

///层级式的组合迭代器也是可行的。
///比如，你可能希望限制生成元素的个数，缓冲生成的值，或是编码已生成的数据。
///这里有个小例子，我们构建了一个迭代器转换器，它可以用参数中的 limit 值来限制参数迭代器所生成的结果个数
struct LimitIterator<I: IteratorProtocol>: IteratorProtocol {
    var limit = 0
    var iterator: I
    init(limit: Int, iterator: I) {
        self.limit = limit
        self.iterator = iterator
    }
    mutating func next() -> I.Element? {
        guard limit > 0 else { return nil }
        limit -= 1
        return iterator.next()
    }
}
///在填充固定大小的数组，或是以某种方式缓冲已生成的元素时，这样的迭代器可能会很有用

/// 在编写迭代器时，为每个迭代器引入一个新的结构体有时是一件很繁琐的事情。
///Swift 提供了一个简单的 AnyIterator<Element> 结构体，其中的元素类型是一个泛型。要初始化该结构体，既可以传入一个已有的迭代器，也可以传入一个 next 函数
///AnyIterator 不仅实现了 Iterator 协议，也实现了 Sequence 协议,使用 AnyIterator 可以使我们更为简短地定义迭代器
extension Int {
    func countDown() -> AnyIterator<Int> {
        var i = self - 1
        return AnyIterator {
            guard i >= 0 else { return nil }
            defer { i -= 1 }
            return i
        }
    }
}
///依据 AnyIterator 来定义能够对迭代器进行操作和组合的函数。比如，我们可以拼接两个基础元素类型相同的迭代器
func +<I: IteratorProtocol, J: IteratorProtocol>(first: I, second: J) -> AnyIterator<I.Element> where I.Element == J.Element {
    var i = first
    var j = second
    return AnyIterator { i.next() ?? j.next() }
}
///返回的迭代器会先读取 first 迭代器的所有元素；在该迭代器被耗尽之后，则会从 second 迭代器中生成元素。如果两个迭代器都返回 nil，该合成迭代器也会返回 nil
///通过对第二个参数进行延迟化处理，可以改进上文的定义
func +<I: IteratorProtocol, J: IteratorProtocol>(first: I, second: @escaping @autoclosure () -> J)-> AnyIterator<I.Element> where I.Element == J.Element{
    var one = first
    var other: J? = nil
    return AnyIterator {
        if other != nil {
            return other!.next()
        } else if let result = one.next() {
            return result
        } else {
            other = second()
            return other!.next()
        }
    }
}
///迭代器为序列提供了基础类型
///迭代器提供了一个“单次触发”的机制以反复地计算出下一个元素。这种机制不支持返查或重新生成已经生成过的元素，我们想要做到这个的话就只能再创建一个新的迭代器。协议 SequenceType 则为这些功能提供了一组合适的接口
///每一个序列都有一个关联的迭代器类型和一个创建新迭代器的方法。我们可以据此使用该迭代器来遍历序列



struct ReverseArrayIndices<T>: Sequence {
    let array: [T]
    init(array: [T]) {
        self.array = array
    }
    func makeIterator() -> ReverseIndexIterator {
        return ReverseIndexIterator(array: array)
    }
}
struct ReverseIndexIterator: IteratorProtocol {
    var index: Int
    init<T>(array: [T]) {
        index = array.index(before: array.endIndex)
    }
    ///迭代器却封装了数组序列值的计算
    mutating func next() -> Int? {
        guard index >= 0 else { return nil }
        defer { index -= 1 }
        return index
    }
}
///每当我们希望遍历 ReverseArrayIndices 结构体中存储的数组时，我们可以调用 makeIterator 方法来生成一个需要的迭代器
var array = ["one", "two", "three"]
let reverseSequence = ReverseArrayIndices(array: array)
var reverseIterator = reverseSequence.makeIterator()
while let i = reverseIterator.next() {
    print("Index \(i) is \(array[i])")
}
/**
 Index 2 is three
 Index 1 is two
 Index 0 is one */
///对比之前仅仅使用迭代器的例子，同一个序列可以被第二次遍历 —— 为此我们只需要调用 makeIterator() 来生成一个新的迭代器就可以了。
///通过在 Sequence 的定义中封装迭代器的创建过程，开发者在使用序列时不必再担心潜在的迭代器创建问题。这与面向对象理念中的将使用和创建进行分离的思想是一脉相承的，代码亦由此具有了更高的内聚性。


for i in ReverseArrayIndices(array: array) {
    print("Index \(i) is \(array[i])")
}
/**
 Index 2 is three
 Index 1 is two
 Index 0 is one*/

//延迟话序列
(1...10).filter { $0 % 3 == 0 }.map { $0 * $0 } /// [9, 36, 81]
var result: [Int] = []
for element in 1...10 {
    if element % 3 == 0 {
        result.append(element * element)
    }
}
result // [9, 36, 81]
///“利用 for 循环编写出的命令式版本会更为复杂。
///不过命令式版本还是有一个好处的：执行起来更快。它只对序列进行了一次迭代，并且将过滤和映射合并为一步。
///同时，数组 result 也只被创建了一次。在函数式版本中，不止序列被迭代了两次（过滤与映射各一次），还生成了一个过渡数组用于将 filter 的结果传递至 map 操作。
///通过使用 LazySequence，我们可以在链式操作的同时，一次性计算出应用了所有操作之后的结果。通过这种方法，每个元素的 filter 与 map 操作也可以被合并为一步
let lazyResult = (1...10).lazy.filter { $0 % 3 == 0 }.map { $0 * $0 }
///在将多个方法同时进行链接时，使用 lazy 来合并所有的循环，就可以写出一段性能足以媲美命令式版本的代码了








