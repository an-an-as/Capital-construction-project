/**
 Dynamic casts
 Conditional protocol conformances (SE-0143) were the headline feature of Swift 4.1.
 The final piece of the proposal, runtime querying of conditional conformances, has landed in Swift 4.2.
 This means a dynamic cast to a protocol type (using is or as?), where the value conditionally conforms to the protocol, will now succeed when the conditional requirements are met.
 */
func isEncodable(_ value: Any) -> Bool {
    return value is Encodable
}
// This would return false in Swift 4.1 不支持深入到数组
let encodableArray = [1, 2, 3]
print(isEncodable(encodableArray))

// Verify that the dynamic check doesn't succeed when the conditional conformance criteria aren't met.
struct NonEncodable {}
let nonEncodableArray = [NonEncodable(), NonEncodable()]
let array = [[1], [2]]
print(isEncodable(array)) // true
assert(isEncodable(nonEncodableArray) == false)

//协议一致性现在可以在扩展中合成，而不仅仅是在类型定义上（扩展必须仍然在与类型定义相同的文件中）
enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}
// No code necessary
extension Either: Equatable where Left: Equatable, Right: Equatable {}
extension Either: Hashable where Left: Hashable, Right: Hashable {}
print(Either<Int, String>.left(42) == Either<Int, String>.left(42))
