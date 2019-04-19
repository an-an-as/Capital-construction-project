/// 枚举为一组相关的值定义了一个共同的类型，使你可以在你的代码中以类型安全的方式来使用这些值。
/// 特点:Swift 中的枚举更加灵活，不必给每一个枚举成员提供一个值。如果给枚举成员提供一个值（称为“原始”值），则该值的类型可以是字符串，字符，或是一个整型值或浮点数。
/// 此外，枚举成员可以指定任意类型的关联值存储到枚举成员中，就像其他语言中的联合体（unions）和变体（variants）。你可以在一个枚举中定义一组相关的枚举成员，每一个枚举成员都可以有适当类型的关联值。
/// 在 Swift 中，枚举类型是一等（first-class）类型。它们采用了很多在传统上只被类（class）所支持的特性，例如计算属性（computed properties），用于提供枚举值的附加信息，实例方法（instance methods），用于提供和枚举值相关联的功能。枚举也可以定义构造函数（initializers）来提供一个初始值；可以在原始实现的基础上扩展它们的功能；还可以遵循协议（protocols）来提供标准的功能。
enum CompassPoint {
    case north
    case south
    case east
    case west
}

var directionToHead = CompassPoint.west
directionToHead = .east
directionToHead = .south
switch directionToHead {
case .north:
    print("Lots of planets have a north")
case .south:
    print("Watch out for penguins")
case .east:
    print("Where the sun rises")
case .west:
    print("Where the skies are blue")
}
/// 打印 "Watch out for penguins”

///多个成员值可以出现在同一行上，用逗号隔开
enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}
let somePlanet = Planet.earth
switch somePlanet {
case .earth:
    print("Mostly harmless")
default:
    print("Not a safe place for humans")
}
/// 打印 "Mostly harmless”


//Associated Values
///可以定义 Swift 枚举来存储任意类型的关联值，如果需要的话，每个枚举成员的关联值类型可以各不相同。
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}
/// 打印 "QR code: ABCDEFGHIJKLMNOP."


//Raw Values
///枚举成员可以被默认值（称为原始值）预填充，这些原始值的类型必须相同,每个原始值在枚举声明中必须是唯一的
///原始值和关联值是不同的。原始值是在定义枚举时被预先填充的值，像上述三个 ASCII 码。对于一个特定的枚举成员，它的原始值始终不变。关联值是创建一个基于枚举成员的常量或变量时才设置的值，枚举成员的关联值可以变化。
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

//Implicitly Assigned Raw Values
///原始值的隐式赋值
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}///Plant.mercury的显式原始值为1，Planet.venus的隐式原始值为2，依次类推。
let earthsOrder = Planet.earth.rawValue
/// earthsOrder 值为 3
///当使用字符串作为枚举类型的原始值时，每个枚举成员的隐式原始值为该枚举成员的名称。
enum CompassPoint: String {
    case north, south, east, west
}
let sunsetDirection = CompassPoint.west.rawValue
/// sunsetDirection 值为 "west"


/** Initializing from a Raw Value **/
///如果在定义枚举类型的时候使用了原始值，那么将会自动获得一个初始化方法，这个方法接收一个叫做rawValue的参数，参数类型即为原始值类型，返回值则是枚举成员或nil。你可以使用这个初始化方法来创建一个新的枚举实例。
let possiblePlanet = Planet(rawValue: 7)
/// possiblePlanet 类型为 Planet? 值为 Planet.uranus

let positionToFind = 11
if let somePlanet = Planet(rawValue: positionToFind) {
    switch somePlanet {
    case .earth:
        print("Mostly harmless")
    default:
        print("Not a safe place for humans")
    }
} else {
    print("There isn't a planet at position \(positionToFind)")
}
/// 输出 "There isn't a planet at position 11

//Recursive Enumerations
///递归枚举是一种枚举类型，它有一个或多个枚举成员使用该枚举类型的实例作为关联值。使用递归枚举时，编译器会插入一个间接层。你可以在枚举成员前加上indirect来表示该成员可递归。
///(5+4)*2
indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))
func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(left, right):
        return evaluate(left) + evaluate(right)
    case let .multiplication(left, right):
        return evaluate(left) * evaluate(right)
    }
}

print(evaluate(product))
/// 打印 "18"



enum CarBrand {
    case  BMW
    case  AUDI
    case  BENZ
}
let myBrand = CarBrand.BMW
if case .BMW = myBrand {
    print("宝马")
}
enum CarBrand {
    case  BMW(name:String,Production:String)
    case  AUDI(name:String,Production:String)
    case  BENZ(name:String,Production:String)
}
let myCar = CarBrand.BMW(name: "宝马",Production: "德国")
switch myCar {
case let CarBrand.BMW(name,Production):
    print("This car named \(name)，from\(Production)")
default: () // 不做任何处理
}
let myBrand = CarBrand.BMW(name: "宝马",Production: "德国")
if case let CarBrand.BMW(name, Production) = myBrand{
    print("\(name),\(Production)")
}
enum CarBrand {
    case  BMW
    case  AUDI
    case  BENZ
}
let myBrand = CarBrand.BMW
if case .BMW = myBrand {
    print("宝马")
}
enum CarBrand {
    case  BMW(name:String,Production:String)
    case  AUDI(name:String,Production:String)
    case  BENZ(name:String,Production:String)
}
let myCar = CarBrand.BMW(name: "宝马",Production: "德国")
switch myCar {
case let CarBrand.BMW(name,Production):
    print("This car named \(name)，from\(Production)")
default: () // 不做任何处理
}
let myBrand = CarBrand.BMW(name: "宝马",Production: "德国")
if case let CarBrand.BMW(name, Production) = myBrand{
    print("\(name),\(Production)")
}

// swift中提供了associatedtype关键字来支持泛型
import Foundation
/// 实现该协议的类需要有Sc和ClassEnumation类型、他们都有各自的继承
protocol FindStudentProtocol {
    associatedtype ClassEnumation: RawRepresentable
    associatedtype Sc: School
}
/// 该协议继承子School在该协议内使用了School的方法 同事继承子该协议的类型需要继承School
/// 遵循RawRepresentable 使用rawValue的初始化方法,rawValue返回一个值 和枚举进行匹配 通过RawRepresentable可以利用编译器使得String更加Distinct
/// 限制条件RawRepresentable.RawValue 类型是String 关联到具体的类型内的枚举值必须是String
extension FindStudentProtocol where Self: School, ClassEnumation.RawValue == String {
    func findClass(_ className: String) -> ClassEnumation {
        guard let myClass = ClassEnumation(rawValue: "-Chemical-\(className)-") else { fatalError("class error") }
        return myClass
    }
    func schoolName() -> String {
        return schoolName()
    }
}
class School {
    let name = "MIT"
    func schoolName() -> String {
        return name
    }
}
class Student: School, FindStudentProtocol {
    typealias Sc = MySchool             /// 名字不一致
    class MySchool: School {}           /// 名字一致就不要typealias
    enum ClassEnumation: String {       /// 枚举继承了RawRepresentable
        case classA = "-Chemical-A-"
        case classB = "-Physics-B-"
    }
    func identifier(_ selectedClass: String ) {
        switch findClass(selectedClass) {
        case .classA:
            print(schoolName() + ClassEnumation.classA.rawValue)
        case .classB:
            print(schoolName() + ClassEnumation.classB.rawValue)
        }
    }
}
let student = Student()
student.identifier("A")

enum Demo {
    case demo
}
enum Demo2: Int {
    case num = 1
}

let test = Demo.demo
switch test {
case .demo:
    print("ok")
}
if case .demo = test { print("ok") }

if let test2 = Demo2(rawValue: 2) {
    switch test2 {
    case .num:
        print("ok")
    }
} else {
    print("不存在")
}

enum Segue: String {
    case detail = "VC1"
}
let detail = Segue(rawValue: "VC1")!
if case .detail = detail {
    print("匹配成功")
}
