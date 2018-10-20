//version 1
infix operator !!
func !! <T>(lhs: T?, rhs: () -> String ) -> T {
    if let value = lhs { return value }
    fatalError(rhs())
}
let oicq = ["number": 123]
print(oicq["number"] !! { return "⚠️not exit"})

//version 2
infix operator !!!
func !!! <T>(lhs: T?, rhs: @autoclosure () -> String) -> T {
    guard let value = lhs else { fatalError(rhs) }
    return value
}
let result = Int("123") !!! "error"
print(result)

infix operator !?
func !? <T: ExpressibleByStringLiteral> (lhs: T?, rhs: @autoclosure () -> (String, T)) -> T {
    assert(lhs != nil, rhs().0) //debug
    return lhs ?? rhs().1       //发布后使用的默认值
}
let student = ["name": "jack"]
let name = student["n"] !? ("not exit", "不存在")
print("发布后: \(name)")

//version 3
let bodyTemperature: Double? = 37.0
let bloodGlucose: Double? = nil
print(bodyTemperature)
print("Blood glucose level: \(bloodGlucose)") // 警告文本中有optional nil

infix operator ???: NilCoalescingPrecedence
public func ??? <T>(optional: T?, defaultValue: @autoclosure () -> String) -> String {
    switch optional {
    case let value?: return String(describing: value)
    case nil: return defaultValue()
    }
}
print("Body temperature: \(bodyTemperature ??? "n/a")")
print("Blood glucose level: \(bloodGlucose ??? "n/a")")
