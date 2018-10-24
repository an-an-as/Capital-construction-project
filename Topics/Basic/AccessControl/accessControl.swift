/****************************Access Levels****************************/
///基本原则：不可以在某个实体中定义访问级别更低（更严格）的实体。
///函数的访问级别不能高于它的参数类型和返回类型的访问级别。因为这样就会出现函数可以在任何地方被访问，但是它的参数类型和返回类型却不可以的情况。

//open public
///开放访问和公开访问可以访问同一模块源文件中的任何实体，在模块外也可以通过导入该模块来访问源文件里的所有实体
///通常情况下，框架中的某个接口可以被任何人使用时，你可以将其设置为开放或者公开访问。
///区别:(是否需要在其他模块中继承重写)
///public或者其他更严访问级别的类，只能在它们定义的模块内部被继承;公开访问public或者其他更严访问级别的类成员，只能在它们定义的模块内部的子类中重写。
///open访问的类，可以在它们定义的模块中被继承，也可以在引用它们的模块中被继承。开放访问open的类成员，可以在它们定义的模块中子类中重写，也可以在引用它们的模块中的子类重写
///open把一个类标记为开放，显式地表明意味着其他模块中的代码使用此类作为父类，然后你已经设计好了你的类的代码了。

//internal
///如果你不为代码中的实体显式指定访问级别，那么它们默认为 internal 级别
///内部访问可以访问同一模块源文件中的任何实体，但是不能从模块外访问该模块源文件中的实体。
///通常情况下，某个接口只在应用程序或框架内部使用时，你可以将其设置为内部访问。

//fileprivate
///文件私有访问限制实体只能被所定义的文件内部访问。
///当需要把这些细节被整个文件使用的时候，使用文件私有访问隐藏了一些特定功能的实现细节。

//Private
///私有访问限制实体只能在所定义的作用域内使用。
///需要把这些细节被整个作用域使用的时候，使用文件私有访问隐藏了一些特定功能的实现细节。

public class SomePublicClass {}
internal class SomeInternalClass {}
fileprivate class SomeFilePrivateClass {}
private class SomePrivateClass {}

public var somePublicVariable = 0
internal let someInternalConstant = 0
fileprivate func someFilePrivateFunction() {}
private func somePrivateFunction() {}


/********************** Custom Types **********************************/
public class SomePublicClass {                   // 显式公开类
    public var somePublicProperty = 0            // 显式公开类成员
    var someInternalProperty = 0                 // 隐式内部类成员
    fileprivate func someFilePrivateMethod() {}  // 显式文件私有类成员
    private func somePrivateMethod() {}          // 显式私有类成员
}
class SomeInternalClass {                        // 隐式内部类
    var someInternalProperty = 0                 // 隐式内部类成员
    fileprivate func someFilePrivateMethod() {}  // 显式文件私有类成员
    private func somePrivateMethod() {}          // 显式私有类成员
}
fileprivate class SomeFilePrivateClass {         // 显式文件私有类
    func someFilePrivateMethod() {}              // 隐式文件私有类成员
    private func somePrivateMethod() {}          // 显式私有类成员
}
private class SomePrivateClass {                 // 显式私有类
    func somePrivateMethod() {}                  // 隐式私有类成员
}

/******************** Tuple Types *******************/
///元组的访问级别将由元组中访问级别最严格的类型来决定。
///元组不同于类、结构体、枚举、函数那样有单独的定义。元组的访问级别是在它被使用时自动推断出的，而无法明确指定。


/****************** Function Types    ******************/
///函数的访问级别根据访问级别最严格的参数类型或返回类型的访问级别来决定。
///如果这种访问级别不符合函数定义所在环境的默认访问级别，那么就需要明确地指定该函数的访问级别。
private func someFunction() -> (SomeInternalClass, SomePrivateClass) {}
/// 将该函数指定为 public 或 internal，或者使用默认的访问级别 internal 都是错误的
/// 因为如果把该函数当做 public 或 internal 级别来使用的话，可能会无法访问 private 级别的返回值
/// ⚠️Function must be declared private or fileprivate because its parameter uses a private type


/******************  Enumeration Types   ******************/
///枚举成员的访问级别和该枚举类型相同，你不能为枚举成员单独指定不同的访问级别。
///枚举定义中的任何原始值或关联值的类型的访问级别至少不能低于枚举类型的访问级别。
///例如，你不能在一个 internal 访问级别的枚举中定义 private 级别的原始值类型。
public enum CompassPoint {
    case morth
    case south
    case east
    case west
}


/******************  Nested Types   ******************/
///如果在 private 级别的类型中定义嵌套类型，那么该嵌套类型就自动拥有 private 访问级别。
///如果在 public 或者 internal 级别的类型中定义嵌套类型，那么该嵌套类型自动拥有 internal 访问级别。
///如果想让嵌套类型拥有 public 访问级别，那么需要明确指定该嵌套类型的访问级别。


/****************** Subclassing  ******************/
///子类的访问级别不得高于父类的访问级别。例如，父类的访问级别是 internal，子类的访问级别就不能是 public。(通过继承可访问父类成员, 如果父类private则访问不到)
///可以通过重写为继承来的类成员提供更高的访问级别。在子类中，用子类成员去访问访问级别更低的父类成员，只要这一操作在相应访问级别的限制范围内
public class A {
    fileprivate func someMethod() {}
}
internal class B: A {
    override internal func someMethod() {}
}
///（在同一源文件中访问父类 file-private 级别的成员，在同一模块内访问父类 internal 级别的成员）
public class A {
    fileprivate func someMethod() {}
}
internal class B: A {
    override internal func someMethod() {
        super.someMethod()
    }
}


/************************   Constants, Variables, Properties, and Subscripts    *****************/
///常量、变量、属性不能拥有比它们的类型更高的访问级别。
///例如，你不能定义一个 public 级别的属性，但是它的类型却是 private 级别的。同样，下标也不能拥有比索引类型或返回类型更高的访问级别。
///如果常量、变量、属性、下标的类型是 private 级别的，那么它们必须明确指定访问级别为 private：
private var privateInstance = SomePrivateClass()


/********** Getters and Setters **********/
///常量、变量、属性、下标的 Getters 和 Setters 的访问级别和它们所属类型的访问级别相同。
///Setter 的访问级别可以低于对应的 Getter 的访问级别，这样就可以控制变量、属性或下标的读写权限。
///在 var 或 subscript 关键字之前，你可以通过 fileprivate(set)，private(set) 或 internal(set) 为它们的写入权限指定更低的访问级别。
struct TrackedString {
    private(set) var numberOfEdits = 0
    ///umberOfEdits 属性只能在定义该结构体的源文件中赋值
    ///numberOfEdits属性的 Getter 依然是默认的访问级别 internal
    ///但是 Setter 的访问级别是 private，这表示该属性只有在当前的源文件中是可读写的，而在当前源文件所属的模块中只是一个可读的属性
    var value: String = "" {
        didSet {
            numberOfEdits += 1
        }
    }
}
var stringToEdit = TrackedString()
stringToEdit.value = "This string will be tracked."
stringToEdit.value += " This edit will increment numberOfEdits."
stringToEdit.value += " So will this one."
print("The number of edits is \(stringToEdit.numberOfEdits)")
/// 打印 “The number of edits is 3”

public struct TrackedString {
    public private(set) var numberOfEdits = 0
    ///属性的 Getter 的访问级别设置为 public，而 Setter 的访问级别设置为 private：
    public var value: String = "" {
        didSet {
            numberOfEdits += 1
        }
    }
    public init() {}
}


/********** Initializers **********/
///自定义构造器的访问级别可以低于或等于其所属类型的访问级别,
///如同函数或方法的参数，构造器参数的访问级别也不能低于构造器本身的访问级别。


/********** Default Initializers **********/
///默认构造器的访问级别与所属类型的访问级别相同，除非类型的访问级别是 public。如果一个类型被指定为 public 级别，那么默认构造器的访问级别将为 internal。
///如果你希望一个 public 级别的类型也能在其他模块中使用这种无参数的默认构造器，你只能自己提供一个 public 访问级别的无参数构造器。


/********** Default Memberwise Initializers for Structure Types **********/
///如果结构体中任意存储型属性的访问级别为 private，那么该结构体默认的成员逐一构造器的访问级别就是 private。否则，这种构造器的访问级别依然是 internal。
///如同前面提到的默认构造器，如果你希望一个 public 级别的结构体也能在其他模块中使用其默认的成员逐一构造器，你依然只能自己提供一个 public 访问级别的成员逐一构造器。


/********** Protocols **********/
///如果你定义了一个 public 访问级别的协议，那么该协议的所有实现也会是 public 访问级别。
///这一点不同于其他类型，例如，当类型是 public 访问级别时，其成员的访问级别却只是 internal。


/********** Protocol Inheritance **********/
///如果定义了一个继承自其他协议的新协议，那么新协议拥有的访问级别最高也只能和被继承协议的访问级别相同。例如，你不能将继承自 internal 协议的新协议定义为 public 协议。
///采纳了协议的类型的访问级别取它本身和所采纳协议两者间最低的访问级别。也就是说如果一个类型是 public 级别，采纳的协议是 internal 级别，那么采纳了这个协议后，该类型作为符合协议的类型时，其访问级别也是 internal。
///如果你采纳了协议，那么实现了协议的所有要求后，你必须确保这些实现的访问级别不能低于协议的访问级别。例如，一个 public 级别的类型，采纳了 internal 级别的协议，那么协议的实现至少也得是 internal 级别。


/********** Protocol Conformance **********/
///一个类型可以采纳比自身访问级别低的协议。
///例如，你可以定义一个 public 级别的类型，它可以在其他模块中使用，同时它也可以采纳一个 internal 级别的协议，但是只能在该协议所在的模块中作为符合该协议的类型使用。


/********** Extensions **********/
/// 你可以在访问级别允许的情况下对类、结构体、枚举进行扩展。扩展成员具有和原始类型成员一致的访问级别。
/// 例如，你扩展了一个 public 或者 internal 类型，扩展中的成员具有默认的 internal 访问级别，和原始类型中的成员一致 。如果你扩展了一个 private 类型，扩展成员则拥有默认的 private 访问级别。
/// 或者，你可以明确指定扩展的访问级别（例如，private extension），从而给该扩展中的所有成员指定一个新的默认访问级别。这个新的默认访问级别仍然可以被单独指定的访问级别所覆盖


/********** Private Members in Extensions **********/
///如果你通过扩展来采纳协议，那么你就不能显式指定该扩展的访问级别了。协议拥有相应的访问级别，并会为该扩展中所有协议要求的实现提供默认的访问级别。
protocol SomeProtocol {
    func doSomething()
}
struct SomeStruct {
    private var privateVariable = 12
}
extension SomeStruct: SomeProtocol {
    func doSomething() {
        print(privateVariable)
    }
}


/********** Generics **********/
///泛型类型或泛型函数的访问级别取决于泛型类型或泛型函数本身的访问级别，还需结合类型参数的类型约束的访问级别，根据这些访问级别中的最低访问级别来确定。


/********** Type Aliases **********/
///你定义的任何类型别名都会被当作不同的类型，以便于进行访问控制。类型别名的访问级别不可高于其表示的类型的访问级别。例如，private 级别的类型别名可以作为 private，file-private，internal，public或者open类型的别名，但是 public 级别的类型别名只能作为 public 类型的别名，不能作为 internal，file-private，或 private 类型的别名。这条规则也适用于为满足协议一致性而将类型别名用于关联类型的情况。
