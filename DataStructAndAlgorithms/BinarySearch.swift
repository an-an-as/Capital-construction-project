import Foundation

extension RandomAccessCollection {
    public func binarySearch(for value: Element,  precondition increasingOrder:(Element,Element)->Bool)->Index?{
        guard !isEmpty else {return nil}
        var left = startIndex
        var right = index(before: endIndex)
        while left <= right {
            let dist  = distance(from: left, to: right)
            let mid = index(left, offsetBy: dist/2)
            let candidate = self[mid]
            if increasingOrder(candidate,value){
                left = index(after: mid)
            }
            else if increasingOrder(value,candidate){
                right = index(before: mid)
            }
            else{
                return mid
            }
        }
        return nil
    }
}
extension RandomAccessCollection where Element:Comparable{
    func binarySearch(for value:Element)->Index?{
        return binarySearch(for: value, precondition: <)
    }
}

var array = [1,2,3,4,5]
array.binarySearch(for: 5) == 4
array.reversed().binarySearch(for: 5, precondition: >) == 0
