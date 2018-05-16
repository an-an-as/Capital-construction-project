/*ARC*/
class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

var reference1: Person?
var reference2: Person?
var reference3: Person?

reference1 = Person(name: "John Appleseed")
reference2 = reference1
reference3 = reference1

reference1 = nil
reference2 = nil
reference3 = nil


/**  Strong Reference Cycles Between Class Instances   **/
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    var tenant: Person?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john: Person?
var unit4A: Apartment?

john = Person(name: "John Appleseed")
unit4A = Apartment(unit: "4A")


john!.apartment = unit4A
unit4A!.tenant = john

john = nil
unit4A = nil



/**********  Resolving Strong Reference Cycles Between Class Instances   **********/
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: Person?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john: Person?
var unit4A: Apartment?

john = Person(name: "John Appleseed")
unit4A = Apartment(unit: "4A")

john!.apartment = unit4A
unit4A!.tenant = john

john = nil
unit4A = nil




/**  Unowned References   **/
class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer  // nonoptional
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}

var john: Customer?
john = Customer(name: "John Appleseed")
john!.card = CreditCard(number: 1234_5678_9012_3456, customer: john!)
john = nil






/** Unowned References and Implicitly Unwrapped Optional Properties    **/
class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}
var country = Country(name: "Canada", capitalName: "Ottawa")
print("\(country.name)'s capital city is called \(country.capitalCity.name)")



/**  Strong Reference Cycles for Closures   **/
class HTMLElement {
    let name: String
    let text: String?
    
    lazy var asHTML: Void -> String = {
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}


let heading = HTMLElement(name: "h1")
let defaultText = "some default text"
// replace the default value of the asHTML property with a custom closure
heading.asHTML = {
    return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
}
print(heading.asHTML())

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())

paragraph = nil




/******************************** Resolving Strong Reference Cycles for Closures ********************************/
class HTMLElement {
    let name: String
    let text: String?
    
    lazy var asHTML: Void -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
    
}



var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())

paragraph = nil




/************************ closue capture ***********************/
var i = 10
var captureI = { print(i) }
i = 11
captureI() // 11

class Demo {
    var value = ""
}

var c = Demo()
var captureC = { print(c.value) }
/// c = Demo()  在这里创建引用语意 c.value 在同一内存上赋新值 updated captureC() 捕获该值updated
c.value = "updated"
/// c = Demo()  在这里创建引用语意 c.value 在同一内存上赋值 创建后最新的值是默认值“” captureC() 捕获该值“”
captureC()
/** 无论是值类型i还是引用类型c，closure捕获到的都是它们的引用，这也是为数不多的值类型变量有引用语义的地方；
 Closure内表达式的值，是在closure被调用的时候才评估的，而不是在closure定义的时候评估的； */





/************************  capture list ***********************/
var i = 10
var captureI = { [i] in print(i) }
///captureI的定义中使用了[i]，这叫做closure的capture list，它的作用就是让closure按值语义捕获变量
i = 11

captureI() // 10
class C  {
    var value = ""
}

var c = C()
var captureC = { [c] in print(c.value) }
//c = C() 在这里创建值语意 c.value重新分配内存 在新的内存中赋值  而原来的内存captureC()捕获的的默认值是“”
c.value = "updated"
//c = C() 在这里创建值语意 c.value重新分配内存 新的内存中默认值为“”  而原来的内存中已经赋值 captureC()捕获的值此时是updated
captureC()



//通过外部closure捕获对象造成循环:
class Role {
    var name: String
    lazy var action: () -> Void = {}
    init(_ name: String = "Foo") {
        self.name = name
        print("\(self) init")
    }
    deinit {
        print("\(self) deinit")
    }
}
extension Role: CustomStringConvertible {
    var description: String {
        return "<Role: \(name)>"
    }
}
if true {
    let boss = Role("boss")
    let fn = {
        print("\(boss) takes this action.")
    }
    boss.action = fn
}
/**
 由于class和closure都是引用类型，因此boss和fn都是指向各自对象的strong reference
 fn里，我们捕获了boss，因此，closure对象就有了一个指向boss变量的strong reference
 boss.action = fn让action也成了closure对象的strong reference。此时，Role的引用计数是1，closure对象的引用计数是2
 当程序离开if作用域之后，这时，只有closure对象的引用计数变成了1。
 于是，closure继续引用了boss，boss继续引用了它的对象，而这个对象，继续引用着closure。最终创建了一个引用循环
 但是，这并不是招致引用循环的唯一方式，在类内部实现closure属性的时候，只要它访问了self，就一定会发生引用循环
 */

//解决
class Role {
    var name: String
    lazy var action: () -> Void = {}
    init(_ name: String = "Foo") {
        self.name = name
        print("\(self) init")
    }
    deinit {
        print("\(self) deinit")
    }
}

extension Role: CustomStringConvertible {
    var description: String {
        return "<Role: \(name)>"
    }
}

if true {
    let boss = Role("boss")
    let fn = {
        [unowned boss] in
        print("\(boss) takes this action.")
    }
    boss.action = fn
    fn()
}

/**
 通过capture list，让fn不要捕获boss变量，而是捕获boss变量引用的对象,由于boss变量引用的对象仍就是一个引用类型，离开if循环之后，这样依旧会存
 这时使用unowned处理closure和类对象同生共死的引用循环 ,离开作用域之后，boss引用的对象就不再有strong reference了，它会被回收。
 进而closure对象也就没有了strong reference，它也就被回收掉了。*/

//只有在closure对象和它捕获的类对象“同生共死”的时候，使用unowned才是安全的
class Role {
    var name: String
    lazy var action: () -> Void = {}
    init(_ name: String = "Foo") {
        self.name = name
        print("\(self) init")
    }
    deinit {
        print("\(self) deinit")
    }
}
extension Role: CustomStringConvertible {
    var description: String {
        return "<Role: \(name)>"
    }
}
if true {
    var boss = Role("boss")
    let fn = {
        [unowned boss] in
        /// [weak boss]   print: nil takes this action.
        print("\(boss) takes this action.")
    }
    boss = Role("jack")
    boss.action = fn
    boss.action()   //error
}
/**
 fn通过capture list值类型方式捕获了name等于"boss"的对象；
 当boss等于新创建的"hidden boss"对象之后，由于fn是按照unowned方式捕获的，因此closure内的boss引用的对象实际上就不存在了；
 新创建的boss对象的action引用了fn；
 调用boss.action的时候，closure对象之前捕获的boss对象已经不存在了，于是就发生了异常；
 
 如果closure对象和类对象的生命周期不一致，使用unowned就不会带来你想要的结果。
 对于这种情况，我们至多可以做的，就是告诉closure对象：“当你捕获到的对象已经不存在的时候，就不要再访问它了。”
 为此，我们可以在capture list中使用weak关键字 */



//通过closures属性 内部的实现捕获self造成循环:
class Role {
    var name: String
    lazy var action: () -> Void = {
    ///由于在action的实现中使用了self，因此要把它定义成一个lazy property，以保证它只能在Role正常初始化完成之后才可以使用
        print("\(self) takes action.")
    }
    init(_ name: String = "Foo") {
        self.name = name
        print("\(self) init")
    }
    deinit {
        print("\(self) deinit")
    }
}
extension Role: CustomStringConvertible {
    var description: String {
        return "<Role: \(name)>"
    }
}
if true {
    let boss = Role("boss")
    boss.action()
}
//解决
class Role {
    var name: String
    lazy var action: () -> Void = { [weak self] in
        if let role = self {
            print("\(role) takes action.")
        }
    }
    init(_ name: String = "Foo") {
        self.name = name
        print("\(self) init")
    }
    deinit {
        print("\(self) deinit")
    }
}
extension Role: CustomStringConvertible {
    var description: String {
        return "<Role: \(name)>"
    }
}
if true {
    let boss = Role("boss")
    boss.action()
}
/**
 在capture list里，一旦捕获的内容变成weak之后，就意味着它有可能为nil，所以，在closure的实现里，捕获到的内容就变成了一个optional。
 但对于self来说，这样做有一个小缺陷，就是无法编写这样的代码：if let self = self
 
 Swift不允许我们用self作为value binding的变量，要么手动在closure里unwrap到它的值，要么只能使用其它名字的变量来绑定它的值。
 实际上，Swift 3允许我们使用let `self` = self这样的形式在代码中使用关键字作为变量，但不要过度使用这种方法。*/


/*** 类对象和closure之间还隔了一层API调用  ***/
///在async的closure中使用capture list 实际上并不需要，因为async方法中使用的closure并不归Role对象所有，只是closure会捕获Role对象，它们之间不会发生引用循环
class Role {
    var name: String
    lazy var action: () -> Void = { [weak self] in
        if let role = self {
            print("\(role) takes action.")
        }
    }
    init(_ name: String = "Foo") {
        self.name = name
        print("\(self) init")
    }
    deinit {
        print("\(self) deinit")
    }
    func levelUp() {
        let globalQueue = DispatchQueue.global()
        globalQueue.async {
            print("Before: \(self) level up")
            usleep(1000)
            print("After: \(self) level up")
        }
    }
}
extension Role: CustomStringConvertible {
    var description: String {
        return "<Role: \(name)>"
    }
}

var player: Role? = Role("P1")
player?.levelUp()
usleep(500) //延迟500 毫秒
print("Player set to nil")
player = nil
dispatchMain()

//如果在异步中加入self async线程恢复执行之后，由于self已经被主线程设置成nil，此时打印的结果就已经不正确了。
/*:
 Swift标准库中，有一个叫做withExtendedLifetime的函数，
 它有两个参数：第一个参数是它要“延长寿命”的对象；第二个参数是一个closure，在这个closure返回之前，第一个参数会一直“存活”在内存里
 
 由于在withExtendedLifetime的closure参数里，self对象一直存在，我们可以安全的使用force unwrapping来读取对象的值
 尽管我们在capture list中使用了weak self，但Role对象还是在async执行完之后才被ARC回收的。
 
 之前我们说过，self不能作为value binding的变量，
 因此，在withExtendedLifetime的实现里，我们只能使用self!来读取对象，
 如果有很多地方都要访问对象这就很麻烦。但如果我们一定要使用一个和self不同的名字来表示对象又会降低代码的可读性和一致性。
 
 于是，作为一个折中的办法，我们只要把给self改名这个行为，单独封装起来。像这样，给Optional添加一个extension：
 */
class Role {
    var name: String
    lazy var action: () -> Void = { [weak self] in
        if let role = self {
            print("\(role) takes action.")
        }
    }
    init(_ name: String = "Foo") {
        self.name = name
        print("\(self) init")
    }
    deinit {
        print("\(self) deinit")
    }
    func levelUp() {
        let globalQueue = DispatchQueue.global()
        globalQueue.async { [weak self] in
            self.withExtendedLifetime{
                print("Before: \($0) level up")
                usleep(1000)
                print("After: \($0) level up")
            }
        }
    }
}
extension Optional {
    func withExtendedLifetime(_ body: (Wrapped) -> Void) {
        if let value = self {
            body(value)
        }
    }
}
extension Role: CustomStringConvertible {
    var description: String {
        return "<Role: \(name)>"
    }
}

var player: Role? = Role("P1")
player?.levelUp()

usleep(500) //延迟500 毫秒

print("Player set to nil")
player = nil
dispatchMain()




