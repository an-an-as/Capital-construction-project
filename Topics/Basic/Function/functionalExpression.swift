///函子 (Functor)、适用函子 (Applicative Functor) 和单子 (Monad)
extension Array {
    func map<R>(transform: (Element) -> R) -> [R]
}
extension Optional {
    func map<R>(transform: (Wrapped) -> R) -> R?
}
extension Parser {
    func map<T>(_ transform: @escaping (Result) -> T) -> Parser<T>
}
///Int? 这样的可选值也可以被显式地写作 Optional<Int>
///Array<T> 替换 [T]。如果我们按照这样的书写方式定义数组和可选值的 map 方法，相似之处就变得明显了起来：
extension Array {
    func map<R>(transform: (Element) -> R) -> Array<R>
}
extension Optional {
    func map<R>(transform: (Wrapped) -> R) -> Optional<R>
}
extension Parser {
    func map<T>(_ transform: @escaping (Result) -> T) -> Parser<T>
}
/// Optional 与 Array 都是需要一个泛型作为参数来构建具体类型的类型构造体 (Type Constructor)
/// 对于一个实例来说，Array<T> 与 Optional<Int> 是合法的类型，而 Array 本身却并不是
/// 每个 map 方法都需要两个参数：一个即将被映射的数据结构，和一个类型为 (T) -> U 的函数 transform
/// 对于数组或可选值参数中所有类型为 T 的值，map 方法会使用 transform 将它们转换为 U。这种支持 map 运算的类型构造体 —— 比如可选值或数组 —— 有时候也被称作函子 (Functor)
