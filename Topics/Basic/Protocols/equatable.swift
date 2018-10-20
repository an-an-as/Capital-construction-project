struct Country {
    let name: String
    let capital: String
    var visited: Bool
}
let canada = Country(name: "Canada", capital: "Ottawa", visited: true)
let australia = Country(name: "Australia", capital: "Canberra", visited: false)

let bucketList = [australia,canada]
///此时需要对 bucketList 变量进行检查，判断其中是否包含某个 Country 类型对象
let object = canada
let containsObject = bucketList.contains { (country) -> Bool in
    return  country.name == object.name &&
        country.capital == object.capital &&
        country.visited == object.visited
}///这样的话你不得不在每个不同的对象判断中拷贝代码，而且这种强耦合结构会后期对 Country 结构修改造成大麻烦
///Types that conform to the Equatable protocol can be compared for equality using the equal-to operator (==) or inequality using the not-equal-to operator (!=).
extension Country: Equatable {
    static func == (lhs: Country, rhs: Country) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.capital == rhs.capital &&
            lhs.visited == rhs.visited
    }
}
canada == bucketList[0]
bucketList.contains(canada)


// eg1
enum SSS {
    case a
    case b
}
SSS.a == SSS.b

// eg2
enum KKK : String {
    case a
    case b
}
KKK.a == KKK.b

// eg3
enum Token {
    case string(String)
    case number(Int)
    case lparen
    case rparen
}
Token.string("123") == Token.string("456")
///error: Binary operator '==' cannot be applied to two 'Token' operands
static func == (lhs: Token, rhs: Token) -> Bool {
    switch (lhs, rhs) {
    case (.string(let lhsString), .string(let rhsString)):
        return lhsString == rhsString
    case (.number(let lhsNumber), .number(let rhsNumber)):
        return lhsNumber == rhsNumber
    case (.lparen, .lparen), (.rparen, .rparen):
        return true
    default:
        return false
    }
}
//Swift4.1 合成Equatable自动实现 在某些属性不参与相等比较时，必须自己实现
enum Token:Equatable {
    case string(String)
    case number(Int)
    case lparen
    case rparen
}
