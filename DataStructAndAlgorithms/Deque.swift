/**
 
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
    private var origin: Int
    private var capacity: Int
    private var head: Int
    init(capacity: Int = 10) {
        self.capacity = max(capacity, 1)
        self.origin = capacity
        array = [T?](repeating: nil, count: capacity)
        head = capacity
    }
}
extension Deque {
    public var count: Int {
        return array.count - head
    }
    public var isEmpty: Bool {
        return count == 0
    }
    public var peekFirst: T? {
        return isEmpty ? nil : array[head]
    }
    public var peekLast: T? {
        return isEmpty ? nil : array[count - 1]
    }
}
extension Deque {
    public mutating func append(_ element: T) {
        array.append(element)
    }
    public mutating func prepend(_ element: T) {
        if head == 0 {
            capacity *= 2
            let newSapce = [T?](repeating: nil, count: capacity)
            array.insert(contentsOf: newSapce, at: 0)///O(n) 1次
            head = capacity
        }
        head -= 1
        array[head] = element                       ///O(1) 每次   O(n)分摊到多个O(1)
    }
    @discardableResult
    public mutating func pop_front() -> T? {
        guard head < array.count, let element = array[head] else { return nil }
        array[head] = nil
        head += 1
        if capacity >= origin && head >= capacity * 2 {
            let amountToRemove = capacity + capacity/2
            array.removeFirst(amountToRemove)
            head -= amountToRemove
            capacity /= 2
        }
        return element
    }
    public mutating func pop_last() -> T? {
        return isEmpty ? nil : array.removeLast()
    }
}
var deque = Deque<Int>(capacity: 5)
(1...6).forEach { deque.prepend($0) }
// [nil, nil, nil, nil, nil, nil, nil, nil, nil, Optional(6),
/// Optional(5), Optional(4), Optional(3), Optional(2), Optional(1)]
/// origin: 5, capacity: 10, head: 9
(101...106).forEach { deque.append($0) }
// [nil, nil, nil, nil, nil, nil, nil, nil, nil, Optional(6),
/// Optional(5), Optional(4), Optional(3), Optional(2), Optional(1),
/// Optional(101), Optional(102), Optional(103), Optional(104), Optional(105), Optional(106)]
/// origin: 5, capacity: 10, head: 9
(1...11).forEach { _ in deque.pop_front() }
// [nil, nil, nil, nil, nil, Optional(106)], origin: 5, capacity: 5, head: 5)
print(deque)
