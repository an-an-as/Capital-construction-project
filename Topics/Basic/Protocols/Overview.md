
概念: 
协议定义了一个蓝图，规定了用来实现某一特定任务或者功能的方法、属性，以及其他需要的东西。

区别: 
1. Swift的协议和 Objective-C 的协议不同。Swift 协议可以被用作代理，也可以让你对接口进行抽象 (比如 IteratorProtocol 和 Sequence)。
2. 和 Objective-C 协议的最大不同在于可以让结构体和枚举类型满足协议。
3. 除此之外，Swift 协议还可以有关联类型。我们还可以通过协议扩展的方式为协议添加方法实现。

特点: 
1. 协议允许我们进行动态派发，也就是说，在运行时程序会根据消息接收者的类型去选择正确的方法实现
2. 普通的协议可以被当作类型约束使用,也可以当作独立的类型使用。
3. 带有关联类型或者 Self 约束的协议不能将其当作独立的类型来使用，所以像是 let x: Equatable 这样的写法是不被允许的；它们只能用作类型约束，比如 func f<T: Equatable>(x: T)
4. 在面向对象编程中，子类是在多个类之间共享代码的有效方式。一个子类将从它的父类继承所有的方法，然后选择重写其中的某些方法。不过在 Swift 中，Sequence 中的代码共享是通过协议和协议扩展来实现的。通过这么做，Sequence 协议和它的扩展在结构体和枚举这样的值类型中依然可用，而这些值类型是不支持子类继承的。不再依赖于子类让类型系统更加灵活 “相比多继承(C++)，实现多个协议并没有那些复杂的问题。在 Swift 中，编译器会在方法冲突的时候警告我们。
5. 通过协议扩展可以在不共享基类的前提下共享代码的方法。协议定义了一组最小可行的方法集合，以供类型进行实现。而类型通过扩展的方式在这些最小方法上实现更多更复杂的特性。
6. 通过协议来描述的最小功能可以很好地进行整合。你可以一点一点地为某个类型添加由不同协议所带来的不同功能(追溯建模 (retroactive modeling)
7. 通过共同的父类来添加共享特性就没那么灵活了；在开发过程进行到一半的时候再决定为很多不同的类添加一个共同基类往往是很困难的。你想这么做的话，可能需要大量的重构。
8. 而且如果你不是这些子类的拥有者的话，你直接就无法这么处理！子类必须知道哪些方法是它们能够重写而不会破坏父类行为的。
9. 比如，当一个方法被重写时，子类可能会需要在合适的时机调用父类的方法，这个时机可能是方法开头，也可能是中间某个地方，又或者是在方法最后。
10. 通常这个调用时机是不可预估和指定的。另外，如果重写了错误的方法，子类还可能破坏父类的行为，却不会收到任何来自编译器的警告。

#### Protocol Syntax
```swift
protocol SomeProtocol {
/// 这里是协议的定义部分
}
struct SomeStructure: FirstProtocol, AnotherProtocol {
/// 这里是结构体的定义部分
}
class SomeClass: SomeSuperClass, FirstProtocol, AnotherProtocol {
/// 这里是类的定义部分
}
```

#### Property Requirements 
+ 要求遵循该协议的类型提供 指定名称和类型的 实例属性或类型属性
+ 协议不指定属性是存储型属性还是计算型属性，它只指定属性的名称和类型
+ 协议需指明属性是可读的还是可读可写的
```swift 
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
}
protocol AnotherProtocol {
    static var someTypeProperty: Int { get set }
    ///类型属性
}
protocol FullyNamed {
    var fullName: String { get }
    ///实例属性
}
struct Person: FullyNamed {
    var fullName: String
}
let john = Person(fullName: "John Appleseed")
/// john.fullName 为 "John Appleseed"
class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String {
    return (prefix != nil ? prefix! + " " : "") + name
    }
}
var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
/// ncc1701.fullName 是 "USS Enterprise"

//eg
protocol SomeProtocol {
    var num1: Int { get }
    var computed: Int { get set }
}
struct Demo:SomeProtocol {
    var num1: Int = 0
    ///此时为存储属性可以set 若为计算属性只能get
    var computed: Int {
        get {
            return  1_000
        }
        set {
            num1 = newValue
        }
    }
}
var demo = Demo(num1: 200)
demo.num1 = 100
demo.computed = 2
print(demo.num1)    /// 2
print(demo.computed)/// 1000
```

#### Method Requirements 
+  Variadic parameters are allowed, subject to the same rules as for normal methods.
+  Default values, however, can’t be specified for method parameters within a protocol’s definition.
+  协议可以要求遵循协议的类型实现某些指定的实例方法或类方法。这些方法作为协议的一部分，像普通方法一样放在协议的定义中，但是不需要大括号和方法体。
+  可以在协议中定义具有可变参数的方法，和普通方法的定义方式相同。但是，不支持为协议中的方法的参数提供默认值。
```swift
protocol SomeProtocol {
    static func someTypeMethod()
    ///类方法
}
protocol RandomNumberGenerator {
    func random() -> Double
    ///实例方法
}
class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
    lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
    ///truncatingRemainder: 浮点数取余
    return lastRandom / m
    }
}
let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
/// 打印 “Here's a random number: 0.37464991998171”
print("And another one: \(generator.random())")
/// 打印 “And another one: 0.729023776863283”
```

#### Mutating Method Requirements
+ 有时需要在方法中改变方法所属的实例。例如，在值类型（即结构体和枚举）的实例方法中，
+ 将 mutating 关键字作为方法的前缀，写在 func 关键字之前，表示可以在该方法中修改它所属的实例以及实例的任意属性的值
```swift
protocol Togglable {
    mutating func toggle()
}
enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
        self = .on
        case .on:
        self = .off
        }
    }
}
var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()
/// lightSwitch 现在的值为 .On
```

#### Initializer Requirements
+ 协议可以要求遵循协议的类型实现指定的构造器
+ 可以像书写普通的构造器那样，在协议的定义里写下构造器的声明，但不需要写花括号和构造器的实体

```swift
    protocol SomeProtocol {
        init(someParameter: Int)
    }
```

#### Class Implementations of Protocol Initializer Requirements
你可以在遵循该协议的类中实现构造器，并指定其为类的指定构造器或者便利构造器。在这两种情况下，你都必须给构造器实现标上"required"修饰符
```swift
class SomeClass: SomeProtocol {
    required init(someParameter: Int) {
    /// requied要求所有子类也必需实现该构造器 结构体中可不加
    /// 能为构造器规定提供一个显式的实现或继承实现。
    /// 如果一个子类重写了父类的指定构造器，并且该构造器遵循了某个协议的规定，那么该构造器的实现需要被同时标示required和override修饰符
    }
}
```
overrides a designated initializer from a superclass, and also implements a matching initializer requirement from a protoco
```
protocol tcpprotocol {
    init(no1: Int)
}
class mainClass {
    var no1: Int
    init(no1: Int) {
        self.no1 = no1
    }
}
class subClass: mainClass, tcpprotocol {
    var no2: Int
    init(no1: Int, no2 : Int) {
        self.no2 = no
        super.init(no1:no1)
    }
    /// 因为遵循协议，需要加上"required"; 因为继承自父类，需要加上"override"
    required override convenience init(no1: Int)  {
        self.init(no1:no1, no2:0)
    }
}
let res = mainClass(no1: 20)
let show = subClass(no1: 30, no2: 50)
```
Failable Initializer Requirements 
+ 遵循协议的类型可以通过可失败构造器（init?）或非可失败构造器（init）来满足协议中定义的可失败构造器要求。
+ 协议中定义的非可失败构造器要求可以通过非可失败构造器（init）或隐式解包可失败构造器（init!）来满足。


#### Protocols as Types 
作为函数、方法或构造器中的参数类型或返回值类型
作为常量、变量或属性的类型
作为数组、字典或其他容器中的元素类型

```
protocol RandomNum {
    func random() -> Int
}
class RandomGenerator: RandomNum {
    func random() -> Int {
        return Int(arc4random() % 10 )
    }
}
class PrtRandomNum {
    let randomGenerator: RandomNum
    init(randomGenerator:RandomGenerator) {
        ///通过构造器倒入实现协议的类<可实现多态>, ios
        self.randomGenerator = randomGenerator
    }
    func ptrRandomNum() {
        print(randomGenerator.random())
    }
}
let num = PrtRandomNum(randomGenerator: RandomGenerator())
num.ptrRandomNum()
/// PrtRandomNum 协议作为常量类型 需要一个遵循该协议的class(多态) 并且该class内实现了协议功能 从而在PrtRandomNum中调用
```

#### Collections of Protocol Types
```
protocol TextRepresentable {
    var textualDescription: String { get }
}
struct Hamster {
    var name: String
        var textualDescription: String {
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {}
let simonTheHamster = Hamster(name: "Simon")
let things: [TextRepresentable] = [simonTheHamster]
for thing in things {
    print(thing.textualDescription)
}
```

#### Delegation

通过class实现的delegate
如果我们要使用FinishAlertView，通常的做法就是在一个view controller里：
1. 初始化FinishAlertView对象；
2. 把自己注册成FinishAlertView对象的delegate；
3. 实现FinishAlertViewDelegate；

用weak修饰代理属
通常在一个视图里面定一个属性<weak> id修饰，该属性遵循协议，可以通过该属性调用协议里面的方法，但是该方法的功能要在控制器里实现
于是在控制器里遵循该协议，定义一个视图类型的属性、此时强引用视图，初始化该视图，把控制器赋值给视图对象，此时视图持有对控制器的引用，之前视图强引用 此时为了避免循环引用、这里用weak
FinishAlertView                                       EpisodeViewController
        |                                                                      |
delegate(FinishAlertViewDelegate?)      var episodeAlert: FinishAlertView!

```
protocol FinishAlertViewDelegate: class {
    func buttonPressed(at index: Int)
}
class FinishAlertView {
    var buttons: [String] = [ "Cancel", "The next" ]
    weak var delegate: FinishAlertViewDelegate?
    func goToTheNext() {
        delegate?.buttonPressed(at: 1)
    }
}
class EpisodeViewController: FinishAlertViewDelegate {
    var episodeAlert: FinishAlertView!
    init() {
        /// 1. Init
        self.episodeAlert = FinishAlertView()
        /// 2. Register itself
        self.episodeAlert.delegate = self
    }
    /// 3. Implement interface
    func buttonPressed(at index: Int) {
        print("Go to the next episode...")
    }
}

```
> 结构体不能用做代理
结构体用做代理的弊端: 
如果在视图里用属性定义代理delegate 遵循代理 由于遵循该协议的是结构体 不存在引用 不能用weak 这样在引用类型中会造成循环引用；
在 控制器里 定义视图类型属性 初始化 控制器对视图 Strong 引用 ;  定义结构体类型属性 初始化  控制器 持有结构体；
调用视图的delegate 将结构体赋值给 delegate 由于是结构体 执行copy-on-write 此时代理持有的是新结构体 那么调用delegate的方法 执行的是在新结构体里的实现

```
protocol FinishAlertViewDelegate {
    mutating func buttonPressed(at Index: Int)
}
class FinishAlertView {
    var buttons: [String] = [ "Cancel", "The next" ]
    var delegate: FinishAlertViewDelegate?
    ///这时，不能使用weak修饰delegate属性了，因为实现FinishAlertViewDelegate的，不一定是一个引用类型，还有可能是值类型。
    func goToTheNext() {
        delegate?.buttonPressed(at: 1)
    }
}

class EpisodeViewController {
    var episodeAlert: FinishAlertView!
    var counter: PressCounter!
    init() {
        self.episodeAlert = FinishAlertView()
        self.counter = PressCounter()             /// 初始化的时候：这里是一个值类型
        self.episodeAlert.delegate = self.counter /// 赋值的时候：赋值操作值类型拷贝
    }
}
struct PressCounter: FinishAlertViewDelegate {
    var count = 0
    mutating func buttonPressed(at Index: Int) {
        self.count += 1
    }
}
let evc = EpisodeViewController()
evc.episodeAlert.goToTheNext()
evc.episodeAlert.goToTheNext()
evc.episodeAlert.goToTheNext()
evc.episodeAlert.goToTheNext()
evc.episodeAlert.goToTheNext()
evc.episodeAlert.goToTheNext()
print(evc.counter.count) /// Still 0
print((evc.episodeAlert.delegate as! PressCounter).count) /// 6
```
+ delegate没有类型 让它的属性成为结构体 那么新的结构体里的count属性就有值了
+ PressCounter是一个值类型，当我们执行self.episodeAlert.delegate = self.counter时，delegate实际上是self.counter的拷贝，它们引用的并不是同一个对象，因此调用goToTheNext()的时候，
+ 增加的只是self.episodeAlert.delegate，而不是self.counter。
+ 去掉delegate protocol的class约束，并不是一个好主意，这不仅让class类型在实现protocol的时候引入了strong reference；而对于struct类型来说根本就不配做个delegate。


#### call back in struct
```
class FinishAlertView {
    var buttons: [String] = [ "Cancel", "The next" ]
    var buttonPressed: ((Int) -> Void)? // 必须初始化 此时默认为nil
    func goToTheNext() {
        buttonPressed?(1)
    }
}
struct PressCounter {
    var count = 0
    mutating func buttonPressed(at Index: Int) {
        self.count += 1
    }
}
let fav = FinishAlertView()
var counter = PressCounter()

/// fav.buttonPressed = counter.buttonPressed 执行拷贝还是捕获 如果是class就可执行
fav.buttonPressed = { counter.buttonPressed(at: $0) } //不进行赋值操作即不产生拷贝 而是捕获
/// fav.buttonPressed = { _ in print("OK, go to the next episode") } 直接关联 没用到参数 _ in ...
/// 通过闭包表达式将其关联起来
fav.goToTheNext()//其实使用的是一个闭包表达式
fav.goToTheNext()
fav.goToTheNext()
fav.goToTheNext()
fav.goToTheNext()
fav.goToTheNext()
print(counter.count) // 6
```
#### call back in class
+  使用callback替代protocol，是一个有利也有弊的方案。Callback带来了更大的灵活性和更简洁的代码，却也在使用引用类型时，埋下了引用循环的隐患。
+  当然，技术细节上的差异只是你在选择实现方案的一部分考量，另一部分，则来自于代码呈现的语义。
+  通常，如果你有若干功能非常相关的回调函数应该把它们归拢到一起，通过一个protocol来约束他们。
+  这样，实现这些回调函数的类型，也就变成一个遵从了protocol的类型（毕竟你无法让一个对象的delegate同时等于多个对象），这一定是比散落在各处的callback要好多了。

```
class FinishAlertView {
    var buttons: [String] = [ "Cancel", "The next" ]
    var buttonPressed: ((Int) -> Void)? // 必须初始化 此时默认为nil

    func goToTheNext() {
        buttonPressed?(1)
    }
}
class PressCounter {
    var count = 0
    func buttonPressed(at Index: Int) {
        self.count += 1
    }
}

let fav = FinishAlertView()
var counter = PressCounter()

// fav.buttonPressed = counter.buttonPressed // 容易形成循环引用
fav.buttonPressed = { [weak counter] index in
    counter?.buttonPressed(at: index)
}
fav.goToTheNext()
fav.goToTheNext()
fav.goToTheNext()
counter.count
```
#### Adding Protocol Conformance with an Extension
+ 即便无法修改源代码，依然可以通过扩展令已有类型遵循并符合协议。扩展可以为已有类型添加属性、方法、下标以及构造器，因此可以符合协议中的相应要求。
+ 通过扩展令已有类型遵循并符合协议时，该类型的所有实例也会随之获得协议中定义的各项功能。
```
protocol TextRepresentable {
    var textualDescription: String { get }
}
extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}
```
#### Conditionally Conforming to a Protocol
```
protocol TextRepresentable {
    var textualDescription: String { get }
}
extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
    let itemsAsText = self.map { $0.textualDescription }
    return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}
let myDice = [d6, d12]
print(myDice.textualDescription)
/// Prints "[A 6-sided dice, A 12-sided dice]"
```

#### Declaring Protocol Adoption with an Extension
当一个类型已经符合了某个协议中的所有要求，却还没有声明遵循该协议时，可以通过空扩展体的扩展来遵循该协议
```
protocol TextRepresentable {
    var textualDescription: String { get }
}
struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {}
let simonTheHamster = Hamster(name: "Simon")
let somethingTextRepresentable: TextRepresentable = simonTheHamster
print(somethingTextRepresentable.textualDescription)
```
Types don’t automatically adopt a protocol just by satisfying its requirements. They must always explicitly declare their adoption of the protocol.



####  Protocol Inheritance
协议能够继承一个或多个其他协议，可以在继承的协议的基础上增加新的要求。协议的继承语法与类的继承相似，多个被继承的协议间用逗号分隔
```
protocol InheritingProtocol: SomeProtocol, AnotherProtocol {}
```

任何遵循 PrettyTextRepresentable 协议的类型在满足该协议的要求时，也必须满足 TextRepresentable 协议的要求
```
protocol TextRepresentable {
    var textualDescription: String { get }
}
protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}
extension SnakesAndLadders: PrettyTextRepresentable {
    var prettyTextualDescription: String {}
    var textualDescription: String {}
}
```

#### Class-Only Protocols
你可以在协议的继承列表中，通过添加 class 关键字来限制协议只能被类类型遵循，而结构体或枚举不能遵循该协议(代理模式 继承)
```
protocol SomeClassOnlyProtocol: class, SomeInheritedProtocol { }

```

#### Protocol Composition 
有时候需要同时遵循多个协议，你可以将多个协议采用 SomeProtocol & AnotherProtocol 这样的格式进行组合，称为 协议合成（protocol composition）
```
protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person: Named, Aged {
    var name: String
    var age: Int
}
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
}
let birthdayPerson = Person(name: "Malcolm", age: 21)
wishHappyBirthday(to: birthdayPerson)
/// 打印 “Happy birthday Malcolm - you're 21!”
```


#### Checking for Protocol Conformance
+  你可以使用类型转换中描述的 is 和 as 操作符来检查协议一致性，即是否符合某协议，并且可以转换到指定的协议类型
+  is  用来检查实例是否符合某个协议，若符合则返回 true，否则返回 false。
+  as? 返回一个可选值，当实例符合某个协议时，返回类型为协议类型的可选值，否则返回 nil。
+  as! 将实例强制向下转换到某个协议类型，如果强转失败，会引发运行时错误
```
protocol HasArea {
    var area: Double { get }
}
class Circle: HasArea {
    let pi = 3.1415927
    var radius: Double
    var area: Double {
        return pi * radius * radius
    }
    init(radius: Double) {
        self.radius = radius
    }
}
class Country: HasArea {
    var area: Double
    init(area: Double) {
        self.area = area
    }
}
class Animal {
    var legs: Int
    init(legs: Int) {
        self.legs = legs
    }
}
let objects: [AnyObject] = [ Circle(radius: 2.0), Country(area: 243_610), Animal(legs: 4) ]
for object in objects {
if let objectWithArea = object as? HasArea {
        print("Area is \(objectWithArea.area)")
    } else {
        print("Something that doesn't have an area")
    }
}
/// Area is 12.5663708
/// Area is 243610.0
/// Something that doesn't have an area
```

#### Optional Protocol Requirements
+ only by classes that inherit from Objective-C
+ 协议可以定义可选要求，遵循协议的类型可以选择是否实现这些要求。在协议中使用 optional 关键字作为前缀来定义可选要求
+ 可选要求用在你需要和 Objective-C 打交道的代码中。协议和可选要求都必须带上@objc属性。
+ 标记 @objc 特性的协议只能被继承自 Objective-C 类的类或者 @objc 类遵循，其他类以及结构体和枚举均不能遵循这种协议
+ 使用可选要求时（例如，可选的方法或者属性），它们的类型会自动变成可选的。比如，一个类型为 (Int) -> String 的方法会变成 ((Int) -> String)?。需要注意的是整个函数类型是可选的，而不是函数的返回值。
+ 协议中的可选要求可通过可选链式调用来使用，因为遵循协议的类型可能没有实现这些可选要求
```
@objc protocol CounterDataSource {
optional func incrementForCount(count: Int) -> Int
optional var fixedIncrement: Int { get }
}
class Counter {
var count = 0
var dataSource: CounterDataSource?
func increment() {
if let amount = dataSource?.incrementForCount?(count) {
///dataSource 后边加上了 ?，以此表明只在 dataSource 非空时才去调用 increment(forCount:) 方法
///dataSource 存在，也无法保证其是否实现了 increment(forCount:) 方法，因为这个方法是可选的。
///因此，increment(forCount:) 方法同样使用可选链式调用进行调用，只有在该方法被实现的情况下才能调用它，所以在 increment(forCount:) 方法后边也加上了 ?
count += amount
} else if let amount = dataSource?.fixedIncrement {
count += amount
}
}
}
class ThreeSource: NSObject, CounterDataSource {
let fixedIncrement = 3
}
var counter = Counter()
counter.dataSource = ThreeSource()
for _ in 1...4 {
counter.increment()
print(counter.count)
}
/// 3
/// 6
/// 9
/// 12

@objc class TowardsZeroSource: NSObject, CounterDataSource {
func increment(forCount count: Int) -> Int {
if count == 0 {
return 0
} else if count < 0 {
return 1
} else {
return -1
}
}
}
counter.count = -4
counter.dataSource = TowardsZeroSource()
for _ in 1...5 {
counter.increment()
print(counter.count)
}
/// -3
/// -2
/// -1
/// 0
/// 0
```

#### Protocol Extensions
+ 协议可以通过扩展来为遵循协议的类型提供属性、方法以及下标的实现。
+ 通过这种方式，你可以基于协议本身来实现这些功能，而无需在每个遵循协议的类型中都重复同样的实现，也无需使用全局函数。
+ 通过协议扩展，所有遵循协议的类型，都能自动获得这个扩展所增加的方法实现，无需任何额外修改
```
protocol RandomNumberGenerator {
func random() -> Double
}
extension RandomNumberGenerator {
func randomBool() -> Bool {
return random() > 0.5
}
}
class LinearCongruentialGenerator: RandomNumberGenerator {
var lastRandom = 42.0
let m = 139968.0
let a = 3877.0
let c = 29573.0
func random() -> Double {
lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
return lastRandom / m
}
}

let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
/// 打印 “Here's a random number: 0.37464991998171”
print("And here's a random Boolean: \(generator.randomBool())")
/// 打印 “And here's a random Boolean: true”
```


#### Providing Default Implementations
可以通过协议扩展来为协议要求的属性、方法以及下标提供默认的实现。如果遵循协议的类型为这些要求提供了自己的实现，那么这些自定义实现将会替代扩展中的默认实现被使用。
通过协议扩展为协议要求提供的默认实现和可选的协议要求不同。虽然在这两种情况下，遵循协议的类型都无需自己实现这些要求，但是通过扩展提供的默认实现可以直接调用，而无需使用可选链式调用。
```
protocol PrettyTextRepresentable: TextRepresentable {
var prettyTextualDescription: String { get }
}
extension PrettyTextRepresentable  {
var prettyTextualDescription: String {
return textualDescription
}
}
```


#### Adding Constraints to Protocol Extensions
+ 在扩展协议的时候，可以指定一些限制条件，只有遵循协议的类型满足这些限制条件时，才能获得协议扩展提供的默认实现。
+ 这些限制条件写在协议名之后，使用 where 子句来描述
+ 如果多个协议扩展都为同一个协议要求提供了默认实现，而遵循协议的类型又同时满足这些协议扩展的限制条件，那么将会使用限制条件最多的那个协议扩展提供的默认实现。

```
protocol TextRepresentable {
var textualDescription: String { get }
}
struct Hamster: TextRepresentable {
var name: String
var textualDescription: String {
return "A hamster named \(name)"
}
}
extension Array where Element: TextRepresentable {
var textualDescription: String {
let itemsAsText = self.map { $0.textualDescription }
return "[" + itemsAsText.joined(separator: ", ") + "]"
}
}
let murrayTheHamster = Hamster(name: "Murray")
let morganTheHamster = Hamster(name: "Morgan")
let mauriceTheHamster = Hamster(name: "Maurice")
let hamsters = [murrayTheHamster, morganTheHamster, mauriceTheHamster]
print(hamsters.textualDescription)
/// 打印 “[A hamster named Murray, A hamster named Morgan, A hamster named Maurice]”
```

#### explicit interface
+  面向对象的方式约定的接口是明确的,它必须是一个完整的Car类型
+  所谓完整，就是严格按照Car的规格包含所有的init，deinit以及Car的所有方法和属性
+  由于Car是一个class，当我们传递Car的不同派生类时，各种方法的调用会在运行时被动态派发，这就是我们熟悉的运行时多态

```
func drive(_ car: Car) {
if !car.selfCheck() {
car.startEngine()
car.shiftUp()
car.go()
}
}
class Car {
func selfCheck() -> Bool {
return true
}
func startEngine() {}
func shiftUp() {}
func go() {}

func lightUp() {}
func horn() {}
func lock() {}
}
```
#### implicit interface
+ 和面向对象中的运行时多态不同，泛型编程中调用方法的选择是在编译期完成的。编译器会根据参数的类型在正确的类中选择要调用的方法。这种行为，叫做编译期多态。
+ protocol oriented programming
+ 没有继承关系，无法通过witness table的机制实现方法的动态派发，
+ 编译器是如何为这两个类型的对象选择方法的呢
+ 对于每一个实现了protocol的类型，编译器都会创建一个叫做protocol witness table的对象，其中存放了这个类型实现的每一个protocol方法的地址。  Existential Container
+ “较小对象”的处理方式
+ 在解决了识别不同类型实现的protocol方法之后，为了通过protocol类型实现多态的效果，我们还需要解决另外一个问题。当我们定义一个[Drawable]时：

+  我们应该为shapes的存储分配多少内存空间呢？按照我们之前对struct的理解，在64位平台上，Point是两个Int，应该是16字节；Line是4个Int，应该是32字节。
+ 但Array中的每个元素应该是大小相等的，这样我们才能用固定的偏移值访问Array中不同的元素。由于point和line都是值类型，我们又无法像类对象一样，在数组中存放这两个对象的引用。该怎么办呢？
+ 为此，我们只能人为创建一个中间层，让这个中间层把每一个实现了protocol的类型的对象封装起来，并且，让封装之后的对象都有相同的大小。
+ 这样，把封装后的对象放到Array里，一切就都顺理成章了。而这个所谓的中间层，就是existential container。

```
let shapes: [Drawable] = [point, line]
protocol Drivable {
///定义最小功能集API
func selfCheck() -> Bool
func startEngine()
func shiftUp()
func go()
}
class Roadster: Drivable {
///retroactive modeling
func selfCheck() -> Bool {
return false
}
func startEngine() {print("!!!!!!")}
func shiftUp() {}
func go() {}
}
class SUV: Drivable {
func selfCheck() -> Bool {
return false
}
func startEngine() {print("~~~~")}
func shiftUp() {}
func go() {}
}
func drive2<T:Drivable>(_ car: T) {
if !car.selfCheck() {
car.startEngine()
car.shiftUp()
car.go()
}
}
drive2(Roadster())
drive2(SUV())


```
> 
+  通过协议进行代码共享相比与通过继承的共享，有这几个优势:
+ 不需要被强制使用某个父类
+ 让已经存在的类型满足协议。子类就没那么灵活了，无法以追溯的方式去变更它的父类
+ 协议既可以用于类，也可以用于结构体，而父类就无法和结构体一起使用了
+ 当处理协议时，无需担心方法重写或者在正确的时间调用 super 这样的问题

```
//在协议扩展中重写方法
protocol Drawing {
mutating func addEllipse(rect: CGRect, fill: UIColor)
mutating func addRectangle(rect: CGRect, fill: UIColor)
}
extension CGContext: Drawing {
func addEllipse(rect: CGRect, fill: UIColor) {
setFillColor(fill.cgColor)
fillEllipse(in: rect)
}
func addRectangle(rect: CGRect, fill fillColor: UIColor) {
setFillColor(fillColor.cgColor)
fill(rect)
}
}
struct SVG {
var rootNode = XMLNode(tag: "svg")
mutating func append(node: XMLNode) {
rootNode.children.append(node)
}
}
extension SVG: Drawing {
mutating func addEllipse(rect: CGRect, fill: UIColor) {
var attributes: [String:String] = rect.svgAttributes
attributes["fill"] = String(hexColor: fill)
append(node: XMLNode(tag: "ellipse", attributes: attributes))
}
mutating func addRectangle(rect: CGRect, fill: UIColor) {
var attributes: [String:String] = rect.svgAttributes
attributes["fill"] = String(hexColor: fill)
append(node: XMLNode(tag: "rect", attributes: attributes))
}
}
var context: Drawing = SVG()
let rect1 = CGRect(x: 0, y: 0, width: 100, height: 100)
let rect2 = CGRect(x: 0, y: 0, width: 50, height: 50)
context.addRectangle(rect: rect1, fill: .yellow)
context.addEllipse(rect: rect2, fill: .blue)

extension Drawing {
///扩展协议添加方法
mutating func addCircle(center: CGPoint, radius: CGFloat, fill: UIColor) {
let diameter = radius * 2
let origin = CGPoint(x: center.x - radius, y: center.y - radius)
let size = CGSize(width: diameter, height: diameter)
let rect = CGRect(origin: origin, size: size)
addEllipse(rect: rect, fill: fill)
}
}
/// 在扩展中添加一个协议方法有两种方法。首先，你可以只在扩展中进行添加，就像上面 addCircle 所做的那样。
/// 或者，还可以在协议定义本身中添加这个方法的声明，让它成为协议要求的方法。协议要求的方法是动态派发的，而仅定义在扩展中的方法是静态派发的。
extension SVG { ///SVG 遵循Drawing
/// 在协议扩展中重写方法
mutating func addCircle(center: CGPoint, radius: CGFloat, fill: UIColor) {
var attributes: [String:String] = [
"cx": "\(center.x)",
"cy": "\(center.y)",
"r": "\(radius)",
]
attributes["fill"] = String(hexColor: fill)
append(node: XMLNode(tag: "circle", attributes: attributes))
}
}
/// 编译器将选择 addCircle 的最具体的版本，也就是定义在 SVG 扩展上的版本
var sample = SVG()
sample.addCircle(center: .zero, radius: 20, fill: .red)

```
此时使用了协议扩展中的 addCircle 方法，而没有用 SVG 扩展中的。
 我们将 otherSample 定义为 Drawing 类型的变量时，编译器会自动将 SVG 值封装到一个代表协议的类型中，这个封装被称作存在容器 (existential container)
```
var otherSample: Drawing = SVG()
otherSample.addCircle(center: .zero, radius: 20, fill: .red)
print(otherSample)
/// 对存在容器调用 addCircle 时，方法是静态派发的，也就是说，它总是会使用 Drawing 的扩展。如果它是动态派发，那么它肯定需要将方法的接收者 SVG 类型考虑在内
/// 将 addCircle 变为动态派发，可以将它添加到协议定义里：
protocol Drawing {
mutating func addEllipse(rect: CGRect, fill: UIColor)
mutating func addRectangle(rect: CGRect, fill: UIColor)
mutating func addCircle(center: CGPoint, radius: CGFloat, fill: UIColor)
}
```
可以像之前那样提供一个默认的实现。而且和之前一样，具体的类型还是可以自由地重写 addCircle。因为现在它是协议定义的一部分了，它将被动态派发。
在运行时，根据方法接收者的动态类型的不同，存在容器将会在自定义实现存在时对其进行调用。如果自定义实现不存在，那么它将使用协议扩展中的默认实现。addCircle 方法变为了协议的一个自定义入口
有个Protoco协议  extension Protocols添加方法    A:Protocol    extension A 修改方法     let a = A() a调用修改过的方法    let a:Protocols = A() a 调用原来的方法
在修改的时候调用修改过后的 不修改调用默认  Protocol中添加方法  extension Protocol提供默认方法


#### 协议的两种类型
```
public protocol IteratorProtocol {
associatedtype Element ///关联类型
public mutating func next() -> Element?
}
protocol Collection: _Indexable, Sequence { /// 集合协议继承了 _Indexable 和 Sequence，因为协议的继承不存在子类继承中的那些问题，可以将多个协议组合起来
associatedtype IndexDistance: SignedInteger = Int                 /// 关联类型默认类型 约束SignedInteger需要满足该协议
associatedtype Iterator: IteratorProtocol = IndexingIterator<Self>/// 使用self作用范型参数
}

```
+  在实现自己的满足 Collection 协议的类型时，有两种选择。我们可以使用默认的关联类型，或者我们也可以用我们自己的关联类型进行赋值
+  如果我们决定使用默认的关联类型的话，我们就可以直接获得很多有用的功能

