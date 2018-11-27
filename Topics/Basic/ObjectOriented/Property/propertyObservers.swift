/// 特点
/// 每次设置属性值时都会调用属性观察器, 即使新值与属性的当前值相同也是如此。

/// ⚠️注意
/// 可以将属性观察器添加到定义的任何存储属性, 但延迟存储的属性除外。
/// 可以通过重写子类中的属性, 将属性观察器添加到任何继承的属性 (无论是存储的还是计算的)。
/// 不需要为未重写的计算属性定义属性观察器, 因为您可以在计算属性的 setter 中观察和响应对其值的更改。
/// 在调用超类初始化器之前, 类设置自己的属性时不会调用它们。

/// ⚠️Note
/// If you pass a property that has observers to a function as an in-out parameter, the willSet and didSet observers are always called.
/// This is because of the copy-in copy-out memory model for in-out parameters: The value is always written back to the property at the end of the function.

/// 介绍
/// 如果实现willSet观察器, 则它将作为常量参数传递新的属性值。
/// 可以在willSet实现中指定此参数的名称。如果未在实现中写入参数名称和括号, 则该参数将使用newValue的默认参数名称.

/// 如果实现didSet观察者, 它传递了一个包含旧属性值的常量参数。您可以命名参数或使用oldValue默认参数名称。
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}

let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// About to set totalSteps to 200
// Added 200 steps
stepCounter.totalSteps = 360
// About to set totalSteps to 360
// Added 160 steps
