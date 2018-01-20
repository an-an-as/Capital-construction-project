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
extension FIFOQueue:Collection{
    var startIndex:Int {return 0}
    var endIndex:Int {return operation.count + storage.count}
    func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }
    subscript (position:Int)->Element{
        precondition((startIndex..<endIndex).contains(position),"Must in the range")
        if position < operation.endIndex{
            return operation[operation.count - 1 - position]
        }
        return storage[position - operation.count]
    }
}
extension FIFOQueue:ExpressibleByArrayLiteral{
    init(arrayLiteral elements: Element...) {
        self.init(storage: [], operation: elements.reversed())
    }
}
extension FIFOQueue:CustomStringConvertible{
    var description: String{
        let element1 = self.operation.reversed().map{String(describing:$0)}.joined(separator: ",")
        let element2 = self.storage.map{String(describing:$0)}.joined(separator: ",")
        return "\(element1),\(element2)"
    }
}
