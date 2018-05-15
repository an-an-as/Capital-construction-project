/************************************ Types of Dispatch **************************************/

// 直接派发(Direct Dispatch)
/// 直接派发是最快的 静态调用.缺乏动态性所以没办法支持继承
/// 值类型永远使用direct dispatch：
/// 对于一个值类型来说，无论方法定义在类型自身还是extension里，调用方法永远都使用direct dispatch。也就是说，只取决于调用方法的字面类型
/// 在protocol和class的extension中定义的方法使用direct dispatch：
struct MyStruct {
    func myMethod1() {}
}
let myStruct = MyStruct()
myStruct.myMethod1()





// 函数表派发(Table dispatch )
/// 在面向对象的编程体系里，对于多态的支持，大多是通过一种叫做“虚函数表”的方式实现的。函数表使用了一个数组来存储类声明的每一个函数的指针.在Swift里，这个表叫做witness table
/// 每一个类都会维护一个函数表, 里面记录着类所有的函数, 如果父类函数被 override 的话, 表里面只会保存被 override 之后的函数. 一个子类新添加的函数, 都会被插入到这个数组的最后.
/// 运行时会根据这一个表去决定实际要被调用的函数.
/// 就是把要调用方法的地址放在一个数据结构里。汇编代码里写的，是这个表格的位置以及保存函数地址的偏移，而调用方法的具体地址是在运行时获得的
/// 在protocol和class的定义中声明的方法使用table dispatch：这种方式和传统面向对象编程语言中的虚函数是最像的
/// 通过witness table可以实现字面上一个基类类型的对象，实际上调用派生类方法的效果，也就是我们经常说到的多态
class ParentClass {
    func method1() {}
    func method2() {}
}
class ChildClass: ParentClass {
    override func method2() {}
    func method3() {}
}
let obj = ChildClass()
obj.method2()
/** 编译器会创建两个函数表, 一个是 ParentClass 的, 另一个是 ChildClass的:
 
     offset       0XA00  ParentClass:      0XB00     ChildClass
          1       0X121  method1           0X121     method1
          2       0X122  method2           0X222     method2
          3                                0X223     method3
 
 当一个函数被调用时, 会经历下面的几个过程:
 1.读取对象 0xB00 的函数表.
 2.读取函数指针的索引. 在这里, method2 的索引是1(偏移量), 也就是 0xB00 + 1.
 3.跳到 0x222 (函数指针指向 0x222)
 查表是一种简单, 易实现, 而且性能可预知的方式. 然而, 这种派发方式比起直接派发还是慢一点.
 从字节码角度来看, 多了两次读和一次跳转, 由此带来了性能的损耗. 另一个慢的原因在于编译器可能会由于函数内执行的任务导致无法优化. (如果函数带有副作用的话)
 这种基于数组的实现, 缺陷在于函数表无法拓展. 子类会在虚数函数表的最后插入新的函数, 没有位置可以让 extension 安全地插入函数
 */




// 消息机制派发(Message Dispatch)
/**
 消息机制是调用函数最动态的方式. 也是 Cocoa 的基石, 这样的机制催生了 KVO, UIAppearence 和 CoreData 等功能.
 这种运作方式的关键在于开发者可以在运行时改变函数的行为. 不止可以通过 swizzling 来改变, 甚至可以用 isa-swizzling 修改对象的继承关系, 可以在面向对象的基础上实现自定义派发.*/
class ParentClass {
    dynamic func method1() {}
    dynamic func method2() {}
}
class ChildClass: ParentClass {
    override func method2() {}
    dynamic func method3() {}
}

/**
                                   ChildClass
        ParentClass    <-----      super
        super                0X222 method2
0X121   method1              0X223 method3
0X122   method2
 
 当一个消息被派发, 运行时会顺着类的继承关系向上查找应该被调用的函数. 效率低, 然而, 只要缓存建立了起来, 这个查找过程就会通过缓存来把性能提高到和函数表派发一样快. 但这只是消息机制的原理
 */






/**************************  选择派发机制的因素   ************************/

//声明的位置 (Location Matters)
/// 在 Swift 里, 一个函数有两个可以声明的位置: 类型声明的作用域, 和 extension. 根据声明类型的不同, 也会有不同的派发方式.
class MyClass {
    func mainMethod() {}
}
extension MyClass {
    func extensionMethod() {}
}

/** mainMethod 会使用函数表派发, 而 extensionMethod 则会使用直接派发
 
            Initial Declaration         Extension
 ValueType  Static                      Static
 
 Class      Table                       Static
 
 Protocol   Table                       Static
 
 NSObject   Table                       Message
 Subclass

 */



//引用类型 (Reference Type Matters)
protocol MyProtocol {}
struct MyStruct: MyProtocol {}

extension MyStruct {
    func extensionMethod() {
        print("结构体")
    }
}
extension MyProtocol {
    func extensionMethod() {
        print("协议")
    }
}

let myStruct = MyStruct()
let proto: MyProtocol = myStruct

myStruct.extensionMethod() //结构体
proto.extensionMethod()    //协议 引用的类型决定了派发的方式 如果在协议申明 func extensionMethod() 就是多态函数表调用Table Dispatch 结果‘结构体’


/// 指定派发方式 (Specifying Dispatch Behavior)
/**
 final
 final 允许类里面的函数使用直接派发. 这个修饰符会让函数失去动态性. 任何函数都可以使用这个修饰符, 就算是 extension 里本来就是直接派发的函数.
 这也会让 Objective-C 的运行时获取不到这个函数, 不会生成相应的 selector.
 
 dynamic
 dynamic 可以让类里面的函数使用消息机制派发. 使用 dynamic, 必须导入 Foundation 框架, 里面包括了 NSObject 和 Objective-C 的运行时.
 dynamic 可以让声明在 extension 里面的函数能够被 override. dynamic 可以用在所有 NSObject 的子类和 Swift 的原声类.
 
 
 
 
 @objc & @nonobjc
 @objc 和 @nonobjc 显式地声明了一个函数是否能被 Objective-C 的运行时捕获到.
 使用 @objc 的典型例子就是给 selector 一个命名空间 @objc(abc_methodName),
 让这个函数可以被 Objective-C 的运行时调用. @nonobjc 会改变派发的方式, 可以用来禁止消息机制派发这个函数, 不让这个函数注册到 Objective-C 的运行时里.
 
 
 Swift 也支持 @inline, 告诉编译器可以使用直接派发. 有趣的是, dynamic @inline(__always) func dynamicOrDirect() {} 也可以通过编译! 但这也只是告诉了编译器而已,
 实际上这个函数还是会使用消息机制派发. 这样的写法看起来像是一个未定义的行为, 应该避免这么做.
 

 */


/// NSObject以及其派生类使用的派发规则：
/// 为了让方法使用message dispatch，你必须import Foundation，它包含了Objective-C运行时的核心组件
import Foundation
class Base: NSObject {
    @objc dynamic func method5() {
        
        print("Base.method5")
    }
}

class Subclass: Base {}
extension Subclass {
    override func method5() {
        print("Subclass.method5")
    }
}
let base: Base = Subclass()
base.method5() // Base.method5

/// @objc  当你的方法需要被Objective-C运行时识别时，可以用它来修饰方法。
/// 但@objc的作用仅仅是让一个Swift方法可以被Objective-C运行时识别和访问，但并不会改变这个方法的派发方式。
/// 例如，当我们让一个Swift类从NSObject派生时，编译器就会默认给所有的方法加上@objc属性。
/// 另外，当我们要在Swift中使用#selector选择一个方法的时候，编译器也会提示我们要使用@objc修饰这个方法

///  dynamic 让 message dispatch 强制执行
/// 当这个方法变成message dispatch之后，无论它定义在类型的定义中，还是在类型的extension中，就都是可以重写的了
/// 除了dynamic和@objc之外，另一对功能类似的modifier是final和@nonobjc。
/// final用于把方法的派发方式修改成direct dispatch。
/// @nonobjc则仅仅让一个方法对Objective-C运行时不可见，但不会修改方法的派发方式。







