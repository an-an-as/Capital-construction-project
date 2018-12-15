// 在一个范围内取随机值
for _ in 1...3 {
    print(Int.random(in: 1..<100))
}
// 使用指定的随机生成数据源(如洗牌算法)遵循RandomNumberGenerator协议的数据源
for _ in 1...10 {
    var generator = SystemRandomNumberGenerator()
    print(Int.random(in: 1...1_000, using: &generator))
}
enum Weekday: CaseIterable {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    static func random<G: RandomNumberGenerator>(using generator: inout G) -> Weekday {
        return Weekday.allCases.randomElement(using: &generator)!
    }
    static func random() -> Weekday {
        var g = SystemRandomNumberGenerator()
        return Weekday.random(using: &g)
    }
}
enum CompassDirection: CaseIterable {
    case north, south, east, west
}
print("There are \(CompassDirection.allCases.count) directions.")
/// Prints "There are 4 directions."
let caseList = CompassDirection.allCases.map({ "\($0)" }).joined(separator: ", ")
/// caseList == "north, south, east, west"


//Double
for _ in 1...3 {
    print(Double.random(in: 10.0..<20.0))
}
/// Prints "18.1900709259179"
/// Prints "14.2286325689993"
/// Prints "13.1485686260762"
