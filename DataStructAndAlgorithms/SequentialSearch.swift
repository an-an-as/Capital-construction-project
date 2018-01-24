import Foundation

extension RandomAccessCollection {
    public func sequentialSearch(for value:Element, by precondition:(Element,Element)->Bool)->Index?{
        guard !isEmpty else{ return nil }
        var left = startIndex
        let right = index(before: endIndex)
        while left <= right {
            let candidate = self[left]
            if precondition(candidate,value){
                return left
            }
            else {
                formIndex(after: &left)
            }
        }
        return nil
    }
}
extension RandomAccessCollection where Element:Comparable{
    func sequentialSearch(for value:Element)->Index?{
        return sequentialSearch(for: value, by: ==)
    }
}

Array(5...10).sequentialSearch(for: 6)
["A","B","C"].sequentialSearch(for: "C")
[6,5,4,3,2].sequentialSearch(for: 5, by: <)
