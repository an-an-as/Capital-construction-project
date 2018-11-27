/// ⚠️注意
/// 必须始终将惰性属性声明为变量, 因为在实例初始化完成后, 可能无法检索其初始值。
/// 在初始化完成之前, 常量属性必须始终具有值, 因此不能将其声明为延迟。
/// 如果使用lazy修饰符标记的属性由多个线程同时访问, 并且该属性尚未初始化, 则不能保证该属性只初始化一次

/// 使用条件
/// 当属性的初始值需要复杂或计算开销大的设置时
/// 当属性的初始值依赖于外部因素时,通过延迟属性避免对复杂的类进行不必要的操作

/// 从文件中倒入数据
class DataImporter {
    var fileName = "data.txt"
}
/// 主要功能是把数据写入数组
class DataManager {
    lazy var importer = DataImporter()
    var data = [String]()
}
let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")
/// 当需要访问文件夹的时候才创建
print(manager.importer.fileName)
