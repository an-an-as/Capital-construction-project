extension RandomAccessCollection {
    public func binarySearch(value: Element, precondition: (Element,Element) -> Bool) -> Index? {
        guard !isEmpty else { return nil }
        var left = startIndex
        var right = index(before: endIndex)
        while left <= right {
            let steps = distance(from: left, to: right)
            let mid = index(left, offsetBy: steps / 2)
            let candicate = self[mid]
            if precondition(candicate, value) {
                left = index(after: mid)
            } else if precondition(value, candicate) {
                right = index(before: mid)
            } else {
                return mid
            }
        }
        return nil
    }
}
extension RandomAccessCollection where Element: Comparable {
    func binarySearch(value: Element) -> Index? {
        return binarySearch(value: value, precondition: <)
    }
}
