/// 扩展 就是为一个已有的类、结构体、枚举类型或者协议类型添加新功能。这包括在没有权限获取原始源代码的情况下扩展类型的能力（即 逆向建模 ）
/// 功能:
/// 添加计算型属性和计算型类型属性
/// 定义实例方法和类型方法
/// 提供新的构造器
/// 定义下标
/// 定义和使用新的嵌套类型
/// 使一个已有类型符合某个协议
/// ⚠️扩展可以为一个类型添加新的功能，但是不能重写已有的功能
extension SomeType {
    /// new functionality to add to SomeType goes here
}
extension SomeType: SomeProtocol, AnotherProtocol {
    /// implementation of protocol requirements goes here
}


/************************  Computed Properties  *************************/
///⚠️cannot add stored properties, or add property observers to existing properties.
extension Double {
    var km: Double { return self * 1_000.0 }
    var m : Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
let oneInch = 25.4.mm
print("One inch is \(oneInch) meters")
/// 打印 “One inch is 0.0254 meters”
let threeFeet = 3.ft
print("Three feet is \(threeFeet) meters")
let aMarathon = 42.km + 195.m
print("A marathon is \(aMarathon) meters long")
/// 打印 “A marathon is 42195.0 meters long”


/****************************  Initializers  ***************************/
/// Extensions can add new convenience initializers to a class, but they cannot add new designated initializers or deinitializers to a class.
/// 扩展可以为已有类型添加新的构造器。这可以让你扩展其它类型，将你自己定制类型作为其构造器参数，或者提供该类型的原始实现中未提供的额外初始化选项。
/// 扩展能为类添加新的便利构造器，但是它们不能为类添加新的指定构造器或析构器。指定构造器和析构器必须总是由原始的类实现来提供。
/// 如果你使用扩展为一个值类型添加构造器，同时该值类型的原始实现中未定义任何定制的构造器且所有存储属性提供了默认值，那么我们就可以在扩展中的构造器里调用默认构造器和逐一成员构造器。
/// 正如在值类型的构造器代理中描述的，如果你把定制的构造器写在值类型的原始实现中，上述规则将不再适用。
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    ///所有存储属性有默认值 未提供构造器
}
let defaultRect = Rect()
let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0),size: Size(width: 5.0, height: 5.0))
/// provides default values for all of its stored properties and does not define any custom initializers
extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}
let centerRect = Rect(center: Point(x: 4.0, y: 4.0),size: Size(width: 3.0, height: 3.0))



/*************************** Methods ****************************/
/// 通过扩展添加的实例方法也可以修改该实例本身。结构体和枚举类型中修改 self 或其属性的方法必须将该实例方法标注为 mutating，正如来自原始实现的可变方法一样
extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}
3.repetitions({
    print("Hello!")
})
/// Hello!
/// Hello!
/// Hello!


/******************** Mutating Instance Methods *********************/
extension Int {
    mutating func square() {
        self = self * self
    }
}
var someInt = 3
someInt.square()
/// someInt 的值现在是 9


/********************* Subscripts *********************/
extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}
746381295[0]
/// 返回 5
746381295[1]
/// 返回 9
746381295[2]
/// 返回 2
746381295[8]
/// 返回 7
746381295[9]
/// 返回 0，即等同于：
0746381295[9]



/********************* Nested Types *********************/
///扩展可以为已有的类、结构体和枚举添加新的嵌套类型：
extension Int {
    enum Kind {
        case Negative, Zero, Positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .Zero
        case let x where x > 0:
            return .Positive
        default:
            return .Negative
        }
    }
}

func printIntegerKinds(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .Negative:
            print("- ", terminator: "")
        case .Zero:
            print("0 ", terminator: "")
        case .Positive:
            print("+ ", terminator: "")
        }
    }
    print("")
}
printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
/// 打印 “+ + - 0 - 0 + ”









