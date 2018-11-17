/********值类型和引用类型的优劣****/
let numbers: NSMutableArray = [1, 2, 3, 4, 5]
/// let约定的是numbers不可以再引用其它的类对象，而并不约定类对象的属性是否可以修改。
for _ in numbers { numbers.removeLastObject() } // Will CRASH when iterating!
/// 在Swift里，通过for遍历数组是通过while和Iterator模拟出来的
let numbers: NSMutableArray = [1, 2, 3, 4, 5]
var numberIter = numbers.makeIterator()
while let number = numberIter.next() { numbers.removeLastObject() }
/// 当我们从numbers中删除元素的同时，也会破坏掉numberIter内部用于遍历数组的状态,删掉一个元素之后，再调用numberIter.next()，就发生运行时错误了。

let nubmers = [1, 2, 3, 4, 5]
for _ in numbers { numbers.removeLast() } // Compile time ERROR!
/// numbers是一个常量。而当你把numbers改成一个变量之后，这个循环会在执行5次之后，正常结束
/// Swift中Array的Iterator在内部保存了一个Array的副本，这个副本和numbers是分开独立的，而for循环迭代的实际上是这个副本。因此、尽管在循环里不断的在numbers末尾删除元素，也不会造成运行时错误。

class Queue {
    var position = 0
    var array: [Int] = []
    init(_ array: [Int]) { self.array = array }
    func next() -> Int? {
        guard position < array.count else { return nil }
        position += 1
        return array[position - 1]
    }
}
func traverseQueue(_ queue: Queue) {
    while let item = queue.next() {
        print(item)
    }
}
//当我们在主线程中执行下面的代码时，不会有任何问题：控制台上会依次打印出数字1到5。
let q = Queue([1, 2, 3, 4, 5])
traverseQueue(q)

//但是，在多线程环境里，这段代码却有很大概率无法正常工作：
for _ in 0..<1000 {
    let q = Queue([1, 2, 3, 4, 5])
    DispatchQueue.global().async {
        traverseQueue(q) // May crash here
    }
    traverseQueue(q)     // Or here
}
/**其中for循环执行的次数越多，发生异常的概率就越大，而当循环次数较小的时候，通常又不会发生问题。所以，这类问题大概是我们编程中最难发现和调试的一类。而问题的原因，仍旧是修改了共享对象的属性
 由于Queue是一个引用类型，当q分别传递给主线程和全局队列时，传递的都是同一个Queue对象的引用，在next()的判断里，当guard position < array.count判断后，如果发生线程切换，
 在另外的线程里把position + 1，再回到之前的线程里读取Queue.array的时候，就会发生异常了。*/



/*********************************************   Copy on write  ************************************************/
//case1
struct MyArray {
    var data: NSMutableArray
    init(data: NSMutableArray) {
        self.data = data.mutableCopy() as! NSMutableArray
        /// 深拷贝 在此基础上修改并不需要mutable
    }
}
extension MyArray {
    func append(element: Any) {
        data.insert(element, at: self.data.count)
    }
}
let m = MyArray(data: [1, 2, 3]) /// 赋值给data 但是data是引用类型
let n = m
m.append(element:11)
m.data === n.data // true

//case2
struct MyArray {
    var data: NSMutableArray
    init(_ data: NSMutableArray){
        self.data = data.mutableCopy() as! NSMutableArray
    }
}
extension MyArray {
    var dataCOW:NSMutableArray {
        mutating get {
            data = data.mutableCopy() as! NSMutableArray
            print("copy")
            return data
        }
    }
    
    mutating func append(element:Any){
        dataCOW.insert(element, at: self.data.count)
    }
    /// 调用方法修改的时候 应该再次创建出新的副本 存在dataCOW
    
}
var m = MyArray([1,2,3,4])
let n = m
m.append(element: 5)
m.data === n.data



//case3
class Demo1 { }
var nativeClassObj1 = Demo1()
isKnownUniquelyReferenced(&nativeClassObj1) // true

var nativeClassObj2 = nativeClassObj1
isKnownUniquelyReferenced(&nativeClassObj1) // false

//对于Objective-C中的类对象，总是返回false
var arrayObj: NSArray = [1, 2, 3]
isKnownUniquelyReferenced(&arrayObj) // false



import Foundation
final class Box<T> {
    var unbox: T
    init(_ unbox: T) {
        self.unbox = unbox
    }
}
struct MyArray {
    var data: Box<NSMutableArray>
    init(data: NSMutableArray) {
        self.data = Box(data.mutableCopy() as! NSMutableArray)
    }
}
extension MyArray {
    var dataCOW:NSMutableArray {
        mutating get {
            if !isKnownUniquelyReferenced(&data) {
                data = Box( data.unbox.mutableCopy() as! NSMutableArray )
                print("copied")
            }
            return data.unbox
        }
    }
    mutating func append(element:Any){
        dataCOW.insert(element, at: self.data.unbox.count)
    }
}
let myArray = MyArray(data: [1,2,3,4,5])  // 引用拷贝
var myArray2 = myArray  //2个引用
myArray2.append(element: 10)
myArray.data === myArray2.data
