/********************    Setting Initial Values for Stored Properties   *********************/
/*Initializers*/
struct Fahrenheit {
    var temperature: Double
    init() {
        // Default Property Values
        temperature = 32.0
    }
}
var f = Fahrenheit()
print("The default temperature is \(f.temperature)° Fahrenheit")


/******************   Customizing Initialization    ******************/
///在Swift里，这种初始化class属性的init方法，叫designated init，它们必须定义在class内部，而不能定义在extension里，否则会导致编译错误
struct Celsius {
    var temperatureInCelsius: Double
    // Initialization Parameters
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
}
let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
let freezingPointOfWater = Celsius(fromKelvin: 273.15)


/* Parameter Names and Argument Labels */
//Swift provides an automatic argument label for every parameter in an initializer if you don’t provide one
struct Color {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red   = red
        self.green = green
        self.blue  = blue
    }
    init(white: Double) {
        red   = white
        green = white
        blue  = white
    }
}
let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
let halfGray = Color(white: 0.5)



/* Initializer Parameters Without Argument Labels */
struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
    init(_ celsius: Double){
        temperatureInCelsius = celsius
    }
}
let bodyTemperature = Celsius(37.0)

/* Optional Property Types  */
class SurveyQuestion {
    var text: String
    //  It is automatically assigned a default value of nil, meaning “no string yet”, when a new instance of SurveyQuestion is initialized.
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}
let cheeseQuestion = SurveyQuestion(text: "Do you like cheese?")
cheeseQuestion.ask()
cheeseQuestion.response = "Yes, I do like cheese."

/* Assigning Constant Properties During Initialization */
class SurveyQuestion {
    // Once a constant property is assigned a value, it can’t be further modified.
    let text: String
    var response: String?
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}
let beetsQuestion = SurveyQuestion(text: "How about beets?")
beetsQuestion.ask()
beetsQuestion.response = "I also like beets. (But not with cheese.)"



/***********************************     Default Initializers       **********************************/
// Swift provides a default initializer for any structure or class that provides default values for all of its properties and does not provide at least one initializer itself.
class ShoppingListItem {
    var name: String?
    var quantity = 1
    var purchased = false
}
var item = ShoppingListItem()


/* Memberwise Initializers for Structure Types */
struct Size {
    // the structure receives a memberwise initializer even if it has stored properties that do not have default values
    var width = 0.0, height = 0.0
}
let twoByTwo = Size(width: 2.0, height: 2.0)




/***********************************     Initializer Delegation for Value Types     ***********************************/
struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    init() {}
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        // Initializer delegation
        // Initializers can call other initializers to perform part of an instance’s initialization
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

let basicRect = Rect()
let originRect = Rect(origin: Point(x: 2.0, y: 2.0),size: Size(width: 5.0, height: 5.0))
let centerRect = Rect(center: Point(x: 4.0, y: 4.0),size: Size(width: 3.0, height: 3.0))



/********************************   Class Inheritance and Initialization    ***********************************/
/* Designated Initializers and Convenience Initializers  */
init(parameters) {
    statements
}
convenience init(parameters) {
    statements
}
///必须最终调用designated init完成对象的初始化；如果我们直接在convenience init中设置self.x会导致编译错误

/* Two-Phase Initialization:
 *
 * In the first phase, each stored property is assigned an initial value by the class that introduced it.
 * Once the initial state for every stored property has been determined, the second phase begins,
 * and each class is given the opportunity to customize its stored properties further before the new instance is considered ready for use.
 *
 * Two-phase initialization prevents property values from being accessed before they are initialized,
 * and prevents property values from being set to a different value by another initializer unexpectedly.
 
 * Swift为了保证在一个继承关系中，派生类和基类的属性都可以正确初始化而约定的初始化机制
 * 阶段一：从派生类到基类，自下而上让类的每一个属性都有初始值
 * 阶段二：所有属性都有初始值之后，从基类到派生类，自上而下对类的每个属性进行进一步加工
 */


/*  Safety check 1
 *  A designated initializer must ensure that all of the properties introduced by its class are initialized before it delegates up to a superclass initializer.
 *  As mentioned above, the memory for an object is only considered fully initialized once the initial state of all of its stored properties is known.
 *  In order for this rule to be satisfied, a designated initializer must make sure that all of its own properties are initialized before it hands off up the chain.
 */


/*  Safety check 2
 *  A designated initializer must delegate up to a superclass initializer before assigning a value to an inherited property.
 *  If it doesn’t, the new value the designated initializer assigns will be overwritten by the superclass as part of its own initialization.
 */

/*  Safety check 3
 * A convenience initializer must delegate to another initializer before assigning a value to any property (including properties defined by the same class).
 * If it doesn’t, the new value the convenience initializer assigns will be overwritten by its own class’s designated initializer.
 */


/*  Safety check 4
 *  An initializer cannot call any instance methods, read the values of any instance properties,
 *  or refer to selfas a value until after the first phase of initialization is complete.
 *  The class instance is not fully valid until the first phase ends.
 *  Properties can only be accessed, and methods can only be called, once the class instance is known to be valid at the end of the first phase.
 *
 */
class Point2D {
    var x: Double
    var y: Double
    init ( x:Double = 0 , y:Double = 0) {
        self.x = x
        self.y = y
    }
    convenience init(tuple:(Double,Double)) {
        self.init(x:tuple.0,y:tuple.1)
    }
    
    convenience init? (tuple:(String,String)) {
        guard let x = Double(tuple.0), let y = Double(tuple.1) else { return nil }
        self.init(x:x,y:y)
    }
}
class Point3D: Point2D {
    var z: Double
    // 如果在派生类中没有定义init那么会继承父类的初始化方法和便利构造器
    init(x: Double = 0, y: Double = 0, z: Double = 0) {
        // Phase 1
        self.z = z
        super.init(x: x, y: y) //自下而上让类的每个属性都有初始值
        
        // Phase 2
        self.initXYZ(x: x, y: y, z: z)
    }
    // 自定义派生类中的属性 重载构造器
    // 手工实现所有Point2D的designated init方法 让3D 具备初始化基类属性功能 同时具备便利构造器
    override init(x: Double, y: Double) {
        self.z = 0
        super.init(x: x, y: y)
    }
    
    func initXYZ(x: Double, y: Double, z: Double) {
        self.x = round(x)
        self.y = round(y)
        self.z = round(z)
    }
}

let new = Point3D(x: 20, y: 30)
let new2 = Point3D(tuple: (1 ,1)) //重载 ji lei
new.x




/* Initializer Inheritance and Overriding */
class Vehicle {
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}
let vehicle = Vehicle()
print("Vehicle: \(vehicle.description)")


class Bicycle: Vehicle {
    override init() {
        super.init()
        numberOfWheels = 2
    }
}
let bicycle = Bicycle()
print("Bicycle: \(bicycle.description)")




/* Automatic Initializer Inheritance */
/* If your subclass doesn’t define any designated initializers, it automatically inherits all of its superclass designated initializers.
 * If your subclass provides an implementation of all of its superclass designated initializers
 *
 * 默认情况下，派生类不从基类继承任何init方法。基类的init方法只在有限条件下被派生类自动继承。
 * 如果派生类没有定义任何designated initializer，那么它将自动继承继承所有基类的designated initializer
 * 如果一个派生类定义了所有基类的designated init，那么它也将自动继承基类所有的convenience init
 *
 * 只要派生类拥有基类所有的designated init方法，他就会自动获得所有基类的convenience init方法(重载)
 *
 * 如果需要在派生类中，重载基类的convenience init方法，是不需要override关键字的
 */
class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}

class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}

class ShoppingListItem: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}

var breakfastList = [
    ShoppingListItem(),
    ShoppingListItem(name: "Bacon"),
    ShoppingListItem(name: "Eggs", quantity: 6),
]

breakfastList[0].name = "Orange juice"
breakfastList[0].purchased = true
for item in breakfastList {
    print(item.description)
}
// 1 x orange juice ✔
// 1 x bacon ✘
// 6 x eggs  ✘

/*************************    Failable Initializers     ****************************/
struct Animal {
    let species: String
    init?(species: String) {
        if species.isEmpty { return nil }
        self.species = species
    }
}

let someCreature = Animal(species: "Giraffe")
if let giraffe = someCreature {
    print("An animal was initialized with a species of \(giraffe.species)")
}

let anonymousCreature = Animal(species: "")
if anonymousCreature == nil {
    print("The anonymous creature could not be initialized")
}

/* Failable Initializers for Enumerations */
enum TemperatureUnit {
    case Kelvin, Celsius, Fahrenheit
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .Kelvin
        case "C":
            self = .Celsius
        case "F":
            self = .Fahrenheit
        default:
            return nil
        }
    }
}
let fahrenheitUnit = TemperatureUnit(symbol: "F")
if fahrenheitUnit != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}

let unknownUnit = TemperatureUnit(symbol: "X")
if unknownUnit == nil {
    print("This is not a defined temperature unit, so initialization failed.")
}


/* Failable Initializers for Enumerations With RawValue */
enum TemperatureUnit: Character {
    case Kelvin = "K", Celsius = "C", Fahrenheit = "F"
}

let fahrenheitUnit = TemperatureUnit(rawValue: "F")
if fahrenheitUnit != nil {
    print("This is a defined temperature unit, so initialization succeeded.")
}

let unknownUnit = TemperatureUnit(rawValue: "X")
if unknownUnit == nil {
    print("This is not a defined temperature unit, so initialization failed.")
}

/* Transmit Failable Initializers  */
class Product {
    let name: String
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}

class CartItem: Product {
    let quantity: Int
    init?(name: String, quantity: Int) {
        if quantity < 1 { return nil }
        self.quantity = quantity
        super.init(name: name)
    }
}
if let twoSocks = CartItem(name: "sock", quantity: 2) {
    print("Item: \(twoSocks.name), quantity: \(twoSocks.quantity)")
}

if let zeroShirts = CartItem(name: "shirt", quantity: 0) {
    print("Item: \(zeroShirts.name), quantity: \(zeroShirts.quantity)")
} else {
    print("Unable to initialize zero shirts")
}

/* override  Failable Initializers  */
class Document {
    var name: String?
    init() {}
    init?(name: String) {
        self.name = name
        if name.isEmpty { return nil }
    }
}
class AutomaticallyNamedDocument: Document {
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    override init(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "[Untitled]"
        } else {
            self.name = name
        }
    }
}
class UntitledDocument: Document {
    override init() {
        super.init(name: "[Untitled]")!
    }
}

/* Required Initializers */
class SomeClass {
    required init() {
    }
}
class SomeSubclass: SomeClass {
    required init() {
    }
}

/**  Setting a Default Property Value with a Closure or Function  */
class SomeClass {
    let someProperty: SomeType = {
        return someValue
    }()
}
