/// 类型属性 特点
/// 属于类型本身的属性, 而不是该类型的任何一个实例
/// There will only ever be one copy of these properties, no matter how many instances of that type you create.

/// 实例属性
/// 实例属性是属于特定类型的实例的属性。每次创建该类型的新实例时, 它都有自己的一组属性值, 与任何其他实例分开。

/// 作用
/// type 属性可用于定义对特定类型的所有实例通用的值,
/// 例如所有实例都可以使用的常量属性 (如 c 中的静态常量), 或存储全局到所有实例的值的变量属性该类型的实例 (如 c 中的静态变量)。

/// ⚠️ 注意
/// 与存储的实例属性不同, 必须始终为存储的类型属性提供默认值。这是因为类型本身没有可以在初始化时为存储类型属性赋值的初始值设定项。
/// 存储类型属性在其第一次访问时延迟初始化。它们保证只初始化一次, 即使由多个线程同时访问也是如此, 并且不需要使用延迟修饰符对lazy进行标记。
/// 类型属性使用点语法进行查询和设置, 就像实例属性一样。但是, 在该类型上查询和设置类型属性, 而不是在该类型的实例上进行查询和设置。

struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}
class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}

print(SomeStructure.storedTypeProperty)
SomeStructure.storedTypeProperty = "Another value."
print(SomeStructure.storedTypeProperty)
print(SomeEnumeration.computedTypeProperty)
print(SomeClass.computedTypeProperty)



 struct AudioChannel {
    static let thresholdLevel = 10
    static var maxInputLevelForAllChannels = 0
    var currentLevel: Int = 0 {
        didSet {
            if currentLevel > AudioChannel.thresholdLevel {
                currentLevel = AudioChannel.thresholdLevel
            }
            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                AudioChannel.maxInputLevelForAllChannels = currentLevel
            }
        }
    }
 }
 
 var leftChannel = AudioChannel()
 var rightChannel = AudioChannel()
 leftChannel.currentLevel = 7
 print(leftChannel.currentLevel) // 7
 print(AudioChannel.maxInputLevelForAllChannels)// 7
 rightChannel.currentLevel = 11
 print(rightChannel.currentLevel)// 10
 print(AudioChannel.maxInputLevelForAllChannels)// 10
