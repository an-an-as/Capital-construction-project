/********************      Defining a Base Class    *********************/
class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
        
    }
}
let someVehicle = Vehicle()
print("Vehicle: \(someVehicle.description)")





/********************     Subclassing    *********************/
class Bicycle: Vehicle {
    var hasBasket = false
}
let bicycle = Bicycle()
bicycle.hasBasket = true

bicycle.currentSpeed = 15.0
print("Bicycle: \(bicycle.description)")


class Tandem: Bicycle {
    var currentNumberOfPassengers = 0
}
let tandem = Tandem()
tandem.hasBasket = true
tandem.currentNumberOfPassengers = 2
tandem.currentSpeed = 22.0
print("Tandem: \(tandem.description)")





/********************    Overriding Methods    *********************/
class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo")
    }
}
let train = Train()
train.makeNoise()

// 多态下的静态参数
class Shape {
    enum Color { case red, yellow, green }
    func draw(color: Color = .red) {
        ///默认参数.red 静态绑定 在多态运行时动态绑定真正的方法后还会根据调用该方法对象的类型进行绑定函数参数
        print("A \(color) shape.")
    }
}
class Square: Shape {
    override func draw(color: Color = .yellow) {
        print("A \(color) square.")
    }
}
class Circle: Shape {
    override func draw(color: Color = .green) {
        print("A \(color) circle.")
    }
}
let s = Square()
let c = Circle()

s.draw() // A yellow square
c.draw() // a green circle
//如果在多态的情况下
let square:Shape = Square()
let circle:Shape = Circle()
square.draw() // 参数都是基类Shape的  A red square.
circle.draw() // A red circle.
/**
 在Swift里，继承而来的方法调用是在运行时动态派发的，Swift会在运行时动态选择一个对象真正要调用的方法。但是方法的参数，出于性能的考虑，却是静态绑定的，编译器会根据调用方法的对象的类型，绑定函数的参数。
 于是，就造成了之前派生类方法的实现，基类方法的默认参数这样的结果。所以，直接修改继承得来方法的默认参数，并不是个好主意。
 
 如果你知道定义在extension中的方法，是不能被重定义的，就看到了一丝曙光。
 我们可以把绘画的过程抽象在一个extension方法里，供外部统一调用，然后把真正的绘制过程定义成一个可以重定义的方法
 */


class NewShape {
    enum Color { case red, yellow, green }
    func doDraw(of color: Color) {
        print("A \(color) shape.")
    }
}
// 在重定义继承方法的同时，又继承到基类的默认参数  extension中的方法，是不能被重定义的
extension NewShape {
    func draw(color: Color = .red) { //不可以在派生类中修改
        doDraw(of: color)
    }
}
class NewSquare: NewShape {
    override func doDraw(of color: NewShape.Color) {
        print("A \(color) square.")
    }
}

class NewCircle: NewShape {
    override func doDraw(of color: NewShape.Color) {
        print("A \(color) circle.")
    }
}

let newSquare = NewSquare()
let newCircle = NewCircle()
newSquare.draw() //A red square.
newSquare.doDraw(of: .green)//A green square.
newCircle.draw()//A red circle.






/*****************************  Template method  ******************/
///  所有可以被重写的方法都应该只被类型自身使用，而对外的API都应该是不可被重写的方法。
class Role {
    fileprivate func doPower() -> Int {
        return 0
    }
}
extension Role {
    public func power() -> Int {
    /// 公共访问但不能被改写  这是一个模版实现 可以在里面设置
        let value = doPower()
        return value + 10_000
    }
}

class Player: Role {
    fileprivate override func doPower() -> Int {
        return 99
    }
}
let player = Player()
player.doPower() //99
player.power()   //10099



/****************************** Strategy ******************************/
// 基于函数的Strategy模式
typealias PowerFn = (Role) -> Int
class Role {
    var powerFn: PowerFn
    init(powerFn: @escaping PowerFn = { _ in 0 }) {
        self.powerFn = powerFn
    }
}
extension Role {
    func power() -> Int {
        return powerFn(self)
        //执行闭包
    }
}
class Player: Role {}
enum Level {
    case simple, normal, hard
    func rolePower(role: Role) -> Int {
        switch self {
        case .simple: return 300
        case .normal: return 200
        case .hard:   return 100
        }
    }
}

let p1 = Player(powerFn: { _ in 100 }) //初始化设定
let p2 = Player(powerFn: { _ in 200 })
p2.powerFn = {_ in 300} //动态修
p2.power() //300

let p3 = Player()
let a = Level.rolePower(Level.simple)
p3.powerFn = a
p3.power() //300


///let n = Level.hard. Int rolePower(role: <#T##Role#>) 通过对象调用返回类型:Int
///let n2 = Level.  (role: Role) -> Int  rolePower(self:<#T##Level#>) 通过枚举类调用 返回类型: (role: Role) -> Int
class Demo {
    static func demo() -> Void { print("a")}
    func demo2() -> Void { print("b") }
}
/// 通过类型 调用类方法    Demo.demo()      执行方法                 返回类型: Void
/// 通过类型 调用对象方法  Demo.demo2(<#T##Demo#>)  不执行方法 需要一个对象    返回类型 ()->Void  需要一个Demo对象:demo2(self:Demo)

Demo.demo()
let d = Demo()
d.demo2()                  //直接调用对象方法
let preset = Demo.demo2(d) //间接调用对象方法 先要执行demo2(self:Demo)方法
preset() //b









/********************    Overriding Property Getters and Setters   *********************/
class Car: Vehicle {
    var gear = 1
    override var description: String {
        return super.description + " in gear \(gear)"
    }
}
let car = Car()
car.currentSpeed = 25.0
car.gear = 3
print("Car: \(car.description)")


/********************    Overriding Overriding Property Observers    *********************/
class AutomaticCar: Car {
    final var preventing: String
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}
let automatic = AutomaticCar()
automatic.currentSpeed = 35.0
print("AutomaticCar: \(automatic.description)")







/**************** 多态 *************/
class Person {
    var name: String
    init(name: String) {
        self.name = name
    }
}
class Employee: Person {
    var staffNumber: Int
    init(name: String, staffNumber: Int) {
        self.staffNumber = staffNumber
        super.init(name: name)
    }
}
func printName(of person: Person) {
    //父类指针指向子类 读取子类从父类继承过来的数据  多个继承自相同的父类 就可以呈现多态
    print(person.name)
}

let mars = Person(name: "Mars")
let jeff = Employee(name: "Jeff", staffNumber: 23)

printName(of: mars) // Mars
printName(of: jeff) // Jeff


func printNumber(of employee: Employee) {
    //子类指向父类
    print(employee.staffNumber)
}

printNumber(of: jeff) // 23
//printNumber(of: mars) // compile time error 子类独有的父类不一定有
/**通常来说，子类总是含有一些父类没有的成员变量，或者方法函数。
 而子类肯定含有父类所有的成员变量和方法函数。所以用父类指针指向子类时，没有问题，因为父类有的，子类都有，不会出现非法访问问题。
 但是如果用子类指针指向父类的话，一旦访问子类特有的方法函数或者成员变量，就会出现非法，因为被子类指针指向的由父
 */


/// 语义不清
class Rectangle {
    var w: Double
    var h: Double
    
    init(w: Double, h: Double) {
        self.w = w
        self.h = h
    }
}

class Square: Rectangle {
    init(edge: Double) {
        super.init(w: edge, h: edge)
    }
}
/// 对矩形的宽度扩大1.1倍
func scaleWidth(of rect: Rectangle) {
    let oldHeight = rect.h
    rect.w *= 1.1 //增加宽度适用于矩形
    assert(oldHeight == rect.h)
}

var s11 = Square(edge: 11) //但是正方形就不对了并不适用于子类
scaleWidth(of: s11)

///



