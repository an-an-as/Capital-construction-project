import Foundation
// 文本表示
let str = 100.description

// 哈希表示
var hasher = Hasher()
hasher.combine(23)
hasher.combine("Hello")
let hashValue = hasher.finalize()
print(hashValue)                    ///-6575654425159297442
print("23Hello".hashValue)          ///-1029313248264156967
print(("23" + "Hello").hashValue)   ///-1029313248264156967
///将22加入Hasher
22.hash(into: &hasher)
print(hasher.finalize())            ///3226089243286984190

// 镜像表示
let mirror = 12.customMirror
mirror.children
mirror.subjectType
mirror.displayStyle
