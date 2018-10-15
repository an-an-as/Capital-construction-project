#### The Problem That Generics Solve
1. 使自定义函数和类型能够满足任意类型
2. 表达算法或者数据结构所要求的核心接口
3. 用一种清晰和抽象的方式来表达代码的意图避免代码的复用 

---

#### 自由函数重载
**重载方法:** 
1. 拥有同样名字但是参数或返回类型不同的多个方法互相称为方法的重载
2. 重载并不意味着泛型,可以将多种类型使用在同一个接口上
```swift
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
let temporaryA = a
a = b
b = temporaryA
}
func swapTwoStrings(_ a: inout String, _ b: inout String) {
let temporaryA = a
a = b
b = temporaryA
}
func swapTwoDoubles(_ a: inout Double, _ b: inout Double) {
let temporaryA = a
a = b
b = temporaryA
}
```

非通用的函数会优先于通用函数被使用:

```swift
func log<View: UIView>(_ view: View) {
print("It's a \(type(of: view)), frame: \(view.frame)")
}
func log(_ view: UILabel) {
let text = view.text ?? "(empty)"
print("It's a label, text: \(text)")
}
```
传入UILabel将会调用专门针对label的重载:
```swift
let label = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 32))
label.text = "Password"
log(label) /// It's a label, text: Password
```
传入其他的视图将会调用到泛型函数:
```swift
let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
log(button) /// It's a UIButton, frame: (0.0, 0.0, 100.0, 50.0)
```
重载的使用是在编译期间静态决定的(编译器会依据变量的静态类型来决定要调用哪一个重载,而不是在运行时根据值的动态类型来决定)
泛型通过目击表动态的派发到正确的实现
```swift
let views = [label, button] /// Type of views is [UIView]
for view in views {
log(view)
}
/// It's a UILabel, frame: (20.0, 20.0, 200.0, 32.0)
/// It's a UIButton, frame: (0.0, 0.0, 100.0, 50.0)
/// view的静态类型是 UIView UILabel 
/// 本来应该使用更具体的重载，但是因为重载并不会考虑运行时的动态类型，所以两者都使用了 UIView 的泛型重载
```

---

#### 运算符重载
```swift
precedencegroup ExponentiationPrecedence { 
associativity: left
higherThan: MultiplicationPrecedence // 幂运算比乘法运算优先级更高
} // (depricate from Swift 4.0)
infix operator **: ExponentiationPrecedence
func **(lhs: Double, rhs: Double) -> Double {
return pow(lhs, rhs)
}
func **(lhs: Float, rhs: Float) -> Float {
return powf(lhs, rhs)
}
2.0 ** 3.0 // 8.0
```
对于运算符的重载,类型检查器会去使用非泛型的版本:
```swift
func **<I: BinaryInteger>(lhs: I, rhs: I) -> I {
/// 转换为 Int64，使用 Double 的重载计算结果
let result = Double(Int64(lhs)) ** Double(Int64(rhs))
return I(result)
}
2 ** 3 // error: Ambiguous use of operator '**'
let intResult: Int = 2 ** 3 // 8
```
+ 编译器忽略了整数的泛型重载，因此它无法确定是去调用 Double 的重载还是 Float 的重载
+ 因为两者对于整数字面量输入来说，是相同优先级的可选项(Swift 编译器会将整数字面量在需要时自动向上转换为 Double 或者 Float),所以编译器报错说存在歧义。
+ 要让编译器选择正确的重载，需要将参数显式地声明为整数类型，或者明确提供返回值的类型

这种编译器行为只对运算符生效(BinaryInteger泛型重载的 raise函数可以不加干预地正确工作)
```swift
func raise(_ base: Double, to exponent: Double) -> Double {
return pow(base, exponent)
}
raise(2, to: 3) // 8.0
```

+ 导致这种差异的原因是性能上的考量：Swift 团队选择了一种相对简单但是有时候会无法正确处理重载模型的类型检查器，来保证绝大多数使用情景的前提下，降低类型检查器的复杂度

#### 使用范型约束进行重载
```swift
extension Sequence where Element: Equatable {
/// 当且仅当 `self` 中的所有元素都包含在 `other` 中，返回 true
func isSubset(of other: [Element]) -> Bool { ///O(n)
for element in self {
guard other.contains(element) else { ///contains O(m)  整个函数的复杂度O(nm)
return false
}
}
return true
}
}
let oneToThree = [1,2,3]
let fiveToOne = [5,4,3,2,1]
oneToThree.isSubset(of: fiveToOne) /// true
```
通过收紧序列元素类型的限制来写出性能更好的版本。元素满足 Hashable，将 other 数组转换为一个 Set，查找操作在常数时间内:
```swift
extension Sequence where Element: Hashable {
/// 如果 `self` 中的所有元素都包含在 `other` 中，则返回 true
/// 现在 contains 的检查只会花费 O(1) 的时间 (假设哈希值是平均分布的话)，整个 for 循环的复杂度就可以降低到 O(n) 了
func isSubset(of other: [Element]) -> Bool {
let otherSet = Set(other)
for element in self {
guard otherSet.contains(element) else {
return false
}
}
return true
}
}
```
+ 类型检查器会使用它所能找到的最精确的重载。这里 isSubset 的两个版本都是泛型函数，所以非泛型函数先于泛型函数的规则并不适用
+ 不过因为 Hashable 是对 Equatable 的扩展，所以要求 Hashable 的版本更加精确
+ 有了这些约束,可以像例子中的 isSubset 这样写出更加高效的算法，所以编译器假设更加具体的函数会是更好的选择

isSubset 还可以更加通用，到现在为止，它只接受一个数组并对其检查。但是 Array 是一个具体的类型。实际上 isSubset 并不需要这么具体，在两个版本中只有两个函数调用，那就是两者中都有的 contains 以及 Hashable 版本中的 Set.init。这两种情况下，这些函数只要求输入类型满足 Sequence 协议：
```swift

extension Sequence where Element: Equatable {
/// 根据序列是否包含给定元素返回一个布尔值。
func contains(_ element: Element) -> Bool
}
struct Set<Element: Hashable>:SetAlgebra, Hashable, Collection, ExpressibleByArrayLiteral {
/// 通过一个有限序列创建新的集合。
init<Source: Sequence>(_ sequence: Source) where Source.Element == Element
}
///self 和 other 这两个序列类型并不需要是同样的类型。我们只需要其中的元素类型相同就能进行操作。
extension Sequence where Element: Hashable {
/// 如果 `self` 中的所有元素都包含在 `other` 中，则返回 true
func isSubset<S: Sequence>(of other: S) -> Bool where S.Element == Element {
let otherSet = Set(other)
for element in self {
guard otherSet.contains(element) else {
return false
}
}
return true
}
}
[5,4,3].isSubset(of: 1...10) /// true
```
让 isSubset 对不是 Equatable 的类型也适用(可以要求调用者提供一个函数来表明元素相等的意义)
```swift
extension Sequence {
/// 标准库中使用闭包对行为进行参数化 根据序列是否包含满足给定断言的元素，返回一个布尔值。
/// 对每个元素进行检查，并且在检查结果为 true 的时候，它也返回 true
func contains(where predicate: (Element) throws -> Bool) rethrows -> Bool
}

let isEven = { $0 % 2 == 0 }
(0..<5).contains(where: isEven)    /// true
[1, 3, 99].contains(where: isEven) /// false


extension Sequence {
func isSubset<S: Sequence>(of other: S,by areEquivalent: (Element, S.Element) -> Bool)-> Bool {
for element in self {
guard other.contains(where: { areEquivalent(element, $0) }) else {
return false
}
}
return true
}
}

/// 现在，我们可以将 isSubset 用在数组的数组上了(Array不支持Equatable)
/// 不幸的是，如果我们导入了 Foundation，另一个对类型检查器的性能优化将会导致编译器不再确定到底应该使用哪个 ==，从而使编译发生错误。我们需要在代码的某个地方加上类型标注

[[1,2]].isSubset(of: [[1,2] as [Int], [3,4]]) { $0 == $1 } /// true
let ints = [1,2]
let strings = ["1","2","3"]
ints.isSubset(of: strings) { String($0) == $1 } /// true
```

---
#### Generic Functions 
```swift
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
let temporaryA = a
a = b
b = temporaryA
}
var someInt = 3
var anotherInt = 107
swapTwoValues(&someInt, &anotherInt)
/// someInt 现在 107, and anotherInt 现在 3
var someString = "hello"
var anotherString = "world"
swapTwoValues(&someString, &anotherString)
/// someString 现在 "world", and anotherString 现在 "hello"
```

#### Generic Types
nongeneric version
```swift
struct IntStack {
var items = [Int]()
mutating func push(_ item: Int) {
items.append(item)
}
mutating func pop() -> Int {
return items.removeLast()
}
}
```
generic version
```swift
struct Stack<Element> {
var items = [Element]()
mutating func push(_ item: Element) {
items.append(item)
}
mutating func pop() -> Element {
return items.removeLast()
}
}
var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
stackOfStrings.push("cuatro")
let fromTheTop = stackOfStrings.pop()

```

#### Extending a Generic Type
+ 扩展一个泛型类型的时候，并不需要在扩展的定义中提供类型参数列表。
+ 原始类型定义中声明的类型参数列表在扩展中可以直接使用，并且这些来自原始类型中的参数名称会被用作原始定义中类型参数的引用
```swift
extension Stack {
var topItem: Element? {
return items.isEmpty ? nil : items[items.count - 1]
}
}
if let topItem = stackOfStrings.topItem {
print("The top item on the stack is \(topItem).")
}
```

#### Type Constraints
+ 类型约束可以指定一个类型参数必须继承自指定类，或者符合一个特定的协议或协议组合

nongeneric version
``` swift

func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
for (index, value) in array.enumerated() {
if value == valueToFind {
return index
}
}
return nil
}
let strings = ["cat", "dog", "llama", "parakeet", "terrapin"]
if let foundIndex = findIndex(ofString: "llama", in: strings) {
print("The index of llama is \(foundIndex)")
}/// 打印 “The index of llama is 2”
```
generic version
```swift
func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
for (index, value) in array.enumerated() {
if value == valueToFind {
return index
}
}
return nil
}
let doubleIndex = findIndex(of: 9.3, in: [3.14159, 0.1, 0.25])
/// doubleIndex 类型为 Int?，其值为 nil，因为 9.3 不在数组中
let stringIndex = findIndex(of: "Andrea", in: ["Mike", "Malcolm", "Andrea"])
/// stringIndex 类型为 Int?，其值为 2
```

---
#### Associated Types 
关联类型为协议中的某个类型提供了一个占位名（或者说别名），其代表的实际类型在协议被采纳时才会被指定
```swift
protocol Container {
associatedtype ItemType
mutating func append(_ item: ItemType)
var count: Int { get }
subscript(i: Int) -> ItemType { get }
}
```

nogeneric version
```swift

struct IntStack: Container {
/// IntStack 的原始实现部分
var items = [Int]()
mutating func push(_ item: Int) {
items.append(item)
}
mutating func pop() -> Int {
return items.removeLast()
}
/// Container 协议的实现部分
/// if delete 'typealias ItemType = Int' everything still works  because it’s clear what type should be used for Item
typealias ItemType = Int
mutating func append(_ item: Int) {
self.push(item)
}
var count: Int {
return items.count
}
subscript(i: Int) -> Int {
return items[i]
}
}

```
generic version
```swift
struct Stack<Element>: Container {
/// Stack<Element> 的原始实现部分
var items = [Element]()
mutating func push(_ item: Element) {
items.append(item)
}
mutating func pop() -> Element {
return items.removeLast()
}
/// Container 协议的实现部分
/// 此时协议的关联类型为Stack的泛型
mutating func append(_ item: Element) {
self.push(item)
}
var count: Int {
return items.count
}
subscript(i: Int) -> Element {
return items[i]
}
}

```

#### Generic Where Clauses 
```swift

func allItemsMatch<C1: Container, C2: Container> (_ someContainer: C1, _ anotherContainer: C2) -> Bool
where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
/// 检查两个容器含有相同数量的元素
if someContainer.count != anotherContainer.count {
return false
}
/// 检查每一对元素是否相等
for i in 0..<someContainer.count {
if someContainer[i] != anotherContainer[i] {
return false
}
}
/// 所有元素都匹配，返回 true
return true
}
var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("dos")
stackOfStrings.push("tres")
var arrayOfStrings = ["uno", "dos", "tres"]
if allItemsMatch(stackOfStrings, arrayOfStrings) {
print("All items match.")
} else {
print("Not all items match.")
}/// 打印 “All items match.
```

#### Other
##### Type Parameters 
一个类型参数被指定后就可以用它来定义一个函数的参数类型，或者作为函数的返回类型，还可以用作函数主体中的注释类型。在这些情况下，类型参数会在函数调用时 被实际类型 所替换。

##### Naming Type Parameters
使用大写字母开头的驼峰命名法 
