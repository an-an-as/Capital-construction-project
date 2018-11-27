
/// 属性
/// 属性将值与特定的类、结构或枚举相关联
/// 存储属性将常量和变量值存储为实例的一部分, 而计算属性计算不存储值。
/// 计算的属性由类、结构和枚举提供。存储属性仅由类和结构提供。

/// 存储属性
/// 存储的属性是作为特定类或结构的实例的一部分存储的常量或变量。
/// 存储属性可以是可变存储属性(由var关键字引入), 也可以是常量存储属性 (由let关键字引入)
/// 可以为存储的属性提供默认值作为其定义的一部分, 如 "默认属性值"中所述。
/// 还可以在初始化过程中设置和修改存储属性的初始值。

struct FixedLengthRange {
    var firstValue: Int
    let length: Int
}
var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
/// the range represents integer values 0, 1, and 2
rangeOfThreeItems.firstValue = 6
/// the range now represents integer values 6, 7, and 8
let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4)
// this range represents integer values 0, 1, 2, and 3
rangeOfFourItems.firstValue = 6
// this will report an error, even though firstValue is a variable property


/// ⚠️注意
/// 如果创建结构的实例并将该实例分配给常量, 则不能修改该实例的属性, 即使这些属性被声明为变量属性:
/// 必须将计算属性 (包括只读计算属性) 声明为var关键字的变量属性, 因为它们的值不是固定的。
/// 此行为是由于结构是值类型.当值类型的实例标记为常量时, 其所有属性也是如此。
/// 对于引用类型类, 情况并非如此。如果将引用类型的实例分配给常量, 仍然可以更改该实例的变量属性。

/// 计算属性 全局变量常量 局部变量 计算变量
/// 全局变量是在任何函数、方法、闭包或类型上下文之外定义的变量。
/// 局部变量是在函数、方法或闭包上下文中定义的变量。
/// 计算变量计算它们的值, 而不是存储它, 它们的编写方式与计算属性相同
struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) { //  shorthand notation:   newValue.x
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}
var square = Rect(origin: Point(x: 0.0, y: 0.0), size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center
square.center = Point(x: 15.0, y: 15.0)
print("square.origin is now at (\(square.origin.x), \(square.origin.y))")
// Prints "square.origin is now at (10.0, 10.0)"
// Read-Only Computed Properties
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {
        return width * height * depth
    }
}
let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
