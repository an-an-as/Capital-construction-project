import Foundation

protocol Queue{
    associatedtype Element
    mutating func enQueue(_ value:Element)
    mutating func deQueue()->Element?
}
struct FIFOQueue<Element>:Queue{
    fileprivate var storage:[Element] = []
    fileprivate var operation:[Element] = []
    mutating func enQueue(_ value:Element){
        storage.append(value)
    }
    mutating func deQueue()->Element?{
        if operation.isEmpty{
            operation = storage.reversed()
            storage.removeAll()
        }
        return operation.popLast()
    }
}
