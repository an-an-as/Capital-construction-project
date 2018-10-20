//: Playground - noun: a place where people can play
import UIKit
/// protocol Hashable : Equatable
///除了将自定义类型存入数组外，有时候我们还需要将其存入 Dictionary、Set。甚至某些场景下还需要将其作为键值对中的 Key，这就涉及到哈希函数以及哈希值的碰撞问题了。
///Swift 标准库里的类型，例如：String, Integer, Bool 都已经哈希函数并且可以通过 hashValue 属性直接获得哈希值：

let hello  = "hello"
let world = "world"
let hello2 = "hello"
hello.hashValue                 /// 4799432177974197528 如果对象相等则这两个对象的 hash 值一定相等。
hello2.hashValue                /// 4799432177974197528

"\(hello) \(world)".hashValue   /// 3658945855109305670 如果两个对象 hash 值相等，这两个对象不一定相等。
"hello world".hashValue         /// 3658945855109305670


//eg
struct Country:Equatable {
    let name: String
    let capital: String
    var visited: Bool
}

///哈希冲突
extension String {
    var djb2hash: Int {
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
    var sdbmhash: Int {
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(0) {
            Int($1) &+ ($0 << 6) &+ ($0 << 16) - $0
        }
    }
}
extension Country: Hashable {
    var hashValue: Int {
        return name.djb2hash ^ capital.hashValue ^ visited.hashValue
    }
}

let canada = Country(name: "Canada", capital: "Ottawa", visited: true)
let counts = [canada: 2000]
let cn = Country(name: "China", capital: "BeiJing", visited: true)
counts[cn] ?? 0


//****************************** swift4.1 ******************************
///编译器合成的 hash 函数能保证高质量，但很有可能不是最优的 可以自己实现
struct Country:Equatable,Hashable {
    let name: String
    let capital: String
    var visited: Bool
}
let canada = Country(name: "Canada", capital: "Ottawa", visited: true)
let london = Country(name: "London", capital: "London", visited: false)
canada.hashValue ///  7212417208197217414   相同的对象哈希值一样冲突 需要解决
london.hashValue ///  -3697443649684358944
