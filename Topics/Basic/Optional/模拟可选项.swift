//模拟
enum Optional<T> {
    case some(T)
    case none
}
extension Array where Element: Equatable {
    func findIndex(value: Element) -> Optional<Index> {
        var cursor = startIndex
        while cursor != endIndex {
            if self[cursor] == value {
                return .some(cursor)
            }
            formIndex(after: &cursor)
        }
        return .none
    }
}
let result = [1, 2, 3].findIndex(value: 2)
print(result) // some(1)

switch result {
case .some(let index): print(index)
case .none: print("Not exit")
}

//swift
extension Array where Element: Equatable {
    func findIndex2(value: Element) -> Index? {
        var cursor = startIndex
        while cursor != endIndex {
            if self[cursor] == value {
                return .some(cursor)
            }
            formIndex(after: &cursor)
        }
        return .none
    }
}
extension Array where Element: Equatable {
    func findIndex3(value: Element) -> Index? {
        var cursor = startIndex
        while cursor != endIndex {
            if self[cursor] == value {
                return cursor
            }
            formIndex(after: &cursor)
        }
        return nil
    }
}
switch [1, 2].findIndex2(value: 1) {
case .some(let index): print(index)
case .none: print("Not exit")
}

switch [1, 2].findIndex3(value: 2) {
case let index?: print(index)
case .none: print("Noe exit")
}
