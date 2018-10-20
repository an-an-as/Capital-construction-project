let regex = "^Hello$"
if regex.first == "^" { } // var first: Character? { get }
if regex.first == Optional("^") { }
//原理
func ==<T: Equatable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case (nil, nil): return true
    case let (x?, y?): return x == y  // .some(let y)
    case (_?, nil), (nil, _?): return false
    }
}
//字典获取key返回为可选类型
//为其赋值需要一个可选类型 如果没有隐式转换，你就必须写像是 myDict["someKey"] = Optional(someValue) 这样的代码
var dictWithNils: [String: Int?] = [
    "one": 1,
    "two": 2,
    "none": nil
]
var dictWithNils: [String: Int?] = [
    "one": 1,
    "two": 2,
    "none": nil
]
dictWithNils["one"]? = nil
dictWithNils["two"] = .some(nil)
let result = dictWithNils.index(forKey: "one")
print(dictWithNils[result!].value)
print(dictWithNils)
