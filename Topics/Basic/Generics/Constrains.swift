protocol Container {
    associatedtype ItemType
    mutating func append(_ item: ItemType)
    var count: Int { get }
    subscript(pos: Int) -> ItemType { get }
}
struct Stack<Element>: Container {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
    mutating func append(_ item: Element) {
        self.push(item)
    }
    var count: Int {
        return items.count
    }
    subscript(pos: Int) -> Element {
        return items[pos]
    }
}
func allItemsMatch<C1: Container, C2: Container> (_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
        if someContainer.count != anotherContainer.count {
            return false
        }
        for index in 0..<someContainer.count {
            if someContainer[index] != anotherContainer[index] {
                return false
            }
        }
        return true
}
var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")

var stack = Stack<String>()
stack.append("ass")
var arrayOfStrings = ["uno", "dos", "tres"]
if allItemsMatch(stackOfStrings, stack) {
    print("All items match.")
} else {
    print("Not all items match.")
}/// 打印 “All items match.

