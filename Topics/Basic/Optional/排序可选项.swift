var numbers = ["five", "4", "3", "2", "1"]
typealias SortDescriptor<T> = (T, T) -> Bool
func makeSortDescriptor<Element, Result>(_ transform: @escaping (Element) -> Result,
                                         _ isAscending: @escaping (Result, Result) -> Bool) -> SortDescriptor<Element> {
    return { (param1: Element, param2: Element) in
        return isAscending(transform(param1), transform(param2))
    }
}
func isAscending<T: Comparable>(_ compare: @escaping (T, T) -> Bool) -> (T?, T?) -> Bool {
    return { (lhs, rhs) in
        switch (lhs, rhs) {
        case (nil, nil): return false
        case (nil, _): return false
        case (_, nil): return true
        case let (lhs?, rhs?): return compare(lhs, rhs)
        default: fatalError()
        }
    }
}
let intDescriptor = makeSortDescriptor({ Int($0) }, isAscending(<))
numbers.sort(by: intDescriptor)
print(numbers) // ["1", "2", "3", "4", "five"]

