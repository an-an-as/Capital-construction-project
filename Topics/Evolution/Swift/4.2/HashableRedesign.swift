struct Point {
    /// 如果属性发生改变就重新计算
    var x: Int { didSet { recomputeDistance() } }
    var y: Int { didSet { recomputeDistance() } }
    /// Cached. Should be ignored by Equatable and Hashable.
    private(set) var distanceFromOrigin: Double
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.distanceFromOrigin = Point.distanceFromOrigin(x: x, y: y)
    }
    ///重新计算原点到该点的距离
    private mutating func recomputeDistance() {
        distanceFromOrigin = Point.distanceFromOrigin(x: x, y: y)
    }
    ///静态计算距离
    private static func distanceFromOrigin(x: Int, y: Int) -> Double {
        return Double(x * x + y * y).squareRoot()
    }
}
extension Point: Equatable {
    static func == (lhs: Point, rhs: Point) -> Bool {
        // Ignore distanceFromOrigin for determining equality
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
extension Point: Hashable {
    func hash(into hasher: inout Hasher) {
        // Ignore distanceFromOrigin for hashing
        hasher.combine(x)
        hasher.combine(y)
    }
}
var p1 = Point(x: 3, y: 4)
print(p1.distanceFromOrigin)
p1.x = 2
print(p1.distanceFromOrigin)
print(p1.hashValue)

let p2 = Point(x: 4, y: 3)
print(p2.hashValue)
assert(p1.hashValue != p2.hashValue)
