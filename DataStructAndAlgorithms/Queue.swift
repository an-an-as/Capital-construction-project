/**
+ 因为线性表列分为顺序存储和链式存储，所以队列也可分为顺序队列和链队列,栈可以分为链栈和顺序栈，
+ 队列就是进行排队的数据结构，一个队列肯定是线性结构了，之所以称之为队列，是因为有着先入先出（FIFO ----first in first out）的特性
+ 而栈就与队列相反了，栈具有先入后出（FILO -- first in last out）的特性
+ 因为数组是在连续的内存中持有元素的，所以移除非数组尾部元素时，其他每个元素都需要移动去填补空白，这个操作的复杂度会是 O(n) (而出栈最后一个元素只需要常数的时间就能完成) */
//Queue & Stack (顺序存储)
protocol Queue {
    associatedtype Element
    mutating func enQueue(_ value:Element)
    mutating func deQueue() -> Element?
}
struct FIFOQueue<Element>:Queue {
    fileprivate var operationArray = [Element]()
    fileprivate var storageArray = [Element]()
    mutating func enQueue(_ value: Element) {
        storageArray.append(value)
    }
    mutating func deQueue() -> Element? {
        if operationArray.isEmpty {
            operationArray = storageArray.reversed()//O(n)
            storageArray.removeAll()
        }
        return operationArray.popLast()//O(1) 平摊耗时
    }
}

//version1 元素非可选
extension FIFOQueue: MutableCollection {
    var startIndex: Int { return 0 }
    var endIndex: Int {
        return storageArray.count + operationArray.count
    }
    func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }
    subscript(position:Int) -> Element {
        get {
            precondition((0...endIndex).contains(position), "out of range")
            if position < operationArray.count {
                return operationArray[operationArray.count - position - 1]
                //// operation逆向索引: 1 2 3  -> 3 2 >1< -> 3 2   storage正向索引:4,5
            } else {
                return storageArray[position - operationArray.count]
                ///超出operation range
            }
        }
        set {
            precondition((0...endIndex).contains(position), "out of range")
            if position < operationArray.count {
                operationArray[operationArray.count - position - 1] = newValue
            } else {
                storageArray[position - operationArray.count] = newValue
            }
        }
    }
}
extension FIFOQueue: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self.init(operationArray: elements.reversed(), storageArray: [])
    }
}
extension FIFOQueue: CustomStringConvertible {
    var description: String {
        let element1 = operationArray.reversed().map{ "\($0)" }.joined(separator: ", ")
        let element2 = storageArray.map{ "\($0)" }.joined(separator: ", ")
        return "\(element1),\(element2)"
    }
}
extension FIFOQueue: TextOutputStreamsliable {
    func write<Target>(to target: inout Target) where Target : TextOutputStream {
        target.write("[")
        target.write(map{ String(describing: $0) }.joined(separator: ", "))
        target.write("]")
    }
}
var list: FIFOQueue = [1,2,3,4,5]
let out = list.deQueue() ///Optional(1)
list.enQueue(6)
print(list)///[2, 3, 4, 5,6]

//version2 元素可选
public struct Queue<T> {
    fileprivate var array = [T?]()
    fileprivate var head = 0
    public var isEmpty: Bool {
        return count == 0                   ///               head
    }                                       ///   0   1   2   |
    public var count: Int {                 ///   nil nil nil 4 5
        return array.count - head           ///
    }
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    public mutating func dequeue() -> T? {                                          ///             head
        guard head < array.count, let element = array[head] else { return nil }     /// 0   1   2   |
        array[head] = nil                                                           /// nil nil nil 4 5
        head += 1                                                                   /// head / array.count = 3/5 = 0.6 > 0.25
        let percentage = Double(head)/Double(array.count)                           /// array.remove(3)
        if array.count > 50 && percentage > 0.25 {                                  /// [4,5]
            array.removeFirst(head)
            head = 0
        }
        return element
    }
    public var front: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
}

/**
 主要用于临时存储数据,稍后便会推出 Last-in first-out stack (LIFO)
 Push and pop are O(1) operations.
 */
public struct Stack<T> {
    fileprivate var array = [T]()
    public var isEmpty: Bool {
        return array.isEmpty
    }
    public var count: Int {
        return array.count
    }
    public mutating func push(_ element: T) {
        array.append(element)
    }
    public mutating func pop() -> T? {
        return array.popLast()
    }
    public var top: T? {
        return array.last
    }
}
extension Stack: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var curr = self
        return AnyIterator {
            return curr.pop()
        }
    }
}

//Dequeue
/**
 All enqueuing and dequeuing operations are O(1).
 
 ````
 head = capacity
 [ x, x, x, x, x, x, x, x, x, x ]
                                |
                                head
 
 enqueueFront(5)
 [ x, x, x, x, x, x, x, x, x, 5 ]           head -= 1
                              |             array[head] = element
                              head
 
 enqueueFront(7)
 [ x, x, x, x, x, x, x, x, 7, 5 ]
                           |
                           head
 
 enqueue(1)
 [ x, x, x, x, x, x, x, x, 7, 5, 1, x, x, x, x, x, x, x, x, x ]
                           |
                           head
 
 
 ````
 */
public struct Deque<T> {
    private var array: [T?]
    private var head: Int
    private var capacity: Int
    private let originalCapacity: Int
    
    public init(_ capacity: Int = 10) {
        self.capacity = max(capacity, 1)
        originalCapacity = self.capacity
        array = [T?](repeating: nil, count: capacity)
        head = capacity
    }
    public var isEmpty: Bool {
        return count == 0
    }
    public var count: Int {
        return array.count - head
    }
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }                                                                   ///                                       head == 0
    public mutating func enqueueFront(_ element: T) {                   ///  [ x, x, x, x, x, x, x, x, x, x ]  + [  5, 4, 3, 2, 1 ]
        if head == 0 {                                                  ///                               head = capacity * 2 = 10
            capacity *= 2                                               /// multiply the capacity by 2 each time 如果队列变得越来越大 改变尺寸的操作会减少 和Swift 数组相同
            let emptySpace = [T?](repeating: nil, count: capacity)
            array.insert(contentsOf: emptySpace, at: 0) ///O(n) 1次
            head = capacity
        }
        head -= 1
        array[head] = element///O(1) 每次   O(n)分摊到多个O(1) each individual call to enqueueFront() is still O(1) on average.
    }
    public mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else { return nil }
        array[head] = nil                                          ///                            head                      enqueue
        head += 1                                                  /// enqueueFront                |        10              |  15           20
        if capacity >= originalCapacity && head >= capacity*2 {    /// [ x, x, x, x, x, x, x, x, x, 6]  + [ 5, 4, 3, 2, 1 ] + [1,2,3,4,5] + [6,7,8,9,10,x,x,x,x,x]
            let amountToRemove = capacity + capacity/2             ///                   capacity = 10    origin = 5
            array.removeFirst(amountToRemove)                      ///                                                                       head:20
            head -= amountToRemove                                 ///                                                                       |
            capacity /= 2                                          /// [ x, x, x, x, x, x, x, x, x, x]  + [ x, x, x, x, x ] + [x,x,x,x,x] + [6,7,8,9,10,x,x,x,x,x]
        }                                                          ///                                                      |
        return element                                             /// capacity > 10 && head >= 2 * capacity                v 调节临界点
    }                                                              /// amountToRemove = capacity + capacity/2  = 15           对很小的数组进行微调,节省几个字节的内存是不值得的
    public mutating func dequeueBack() -> T? {                     /// array.removeFirst(15 )
        if isEmpty {                                               /// [x,x,x,x,x] + [x,x,x,9,10,x,x,x,x,x]
            return nil                                             /// head = 20 - 15 = 5
        } else {                                                   /// capacity = capacity / 2 = 5
            return array.removeLast()                              /// 删除enqueueFront的部分 origin + origin*2 -> capacity/2 + capacity
        }                                                          /// 剩余的从原始数组容量开始即 capacity / 2 = 5
    }                                                              /// head >= capacity + origin + origin  -> capacity * 2
    public func peekFront() -> T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
    public func peekBack() -> T? {
        if isEmpty {
            return nil
        } else {
            return array.last!
        }
    }
}
var deque = Deque<Int>()
deque.enqueueFront(1)
deque.enqueueFront(2)
deque.enqueueFront(3)
deque.enqueueFront(4)
deque.enqueueFront(5)
deque.enqueueFront(6)
deque.enqueue(0)
deque.enqueue(0)
deque.enqueue(0)
deque.enqueue(0)
deque.enqueue(0)
deque.enqueue(1)
deque.enqueue(2)
deque.enqueue(3)
deque.enqueue(4)
deque.enqueue(5)
deque.dequeue()
deque.dequeue()
deque.dequeue()
deque.dequeue()
deque.dequeue()
deque.dequeue()
deque.dequeue()
deque.dequeue()
deque.dequeue()
deque.dequeue()
deque.dequeue()
deque.dequeue()
deque.dequeue()
deque.dequeue()
print(deque)
///Deque<Int>(array: [nil, nil, nil, nil, nil, nil, nil, nil, Optional(4), Optional(5)], head: 8, capacity: 5, originalCapacity: 5)
