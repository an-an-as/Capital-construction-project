/// 相同个数进行抵消
extension Array where Element: Comparable {
    var majorityElement: Element? {
        var candicate = first
        var vote = 0
        forEach {
            if candicate != $0 {
                vote -= 1
                if vote < 1 {
                    candicate = $0
                    vote = 1
                }
            } else {
                vote += 1
            }
        }
        return candicate
    }
}
var integers = (1...5).map { _ in Int.random(in: 0...2) }
print(integers)
print(integers.majorityElement)
