/************************** Creating an Empty Array **************************/
var array1 = Array<Int>()
var array2: [Int] = []
var someInts = [Int]()
print("someInts is of type [Int] with \(someInts.count) items.")
/// Prints "someInts is of type [Int] with 0 items."
someInts.reserveCapacity(10)
someInts.append(3)
someInts = []
/// 清空 或 removeAll() someInts is now an empty array, but is still of type [Int]

//Creating an Array with a Default Value
var nums = [Int](repeating:3,count:5)
var anotherThreeDoubles = Array(repeating: 2.5, count: 3)

//Creating an Array by Adding Two Arrays Together
var anotherThreeDoubles = Array(repeating: 2.5, count: 3)
var sixDoubles = threeDoubles + anotherThreeDoubles
/// [0.0, 0.0, 0.0, 2.5, 2.5, 2.5]

//Creating an Array with an Array Literal
/// 数组的元素类型必须是统一
var shoppingList: [String] = ["Eggs", "Milk"]
var shoppingList = ["Eggs", "Milk"] ///type inference
let arr:Any = [1,2,"a","b"]

//Accessing and Modifying an Array
shoppingList.capacity
print("The shopping list contains \(shoppingList.count) items.")
if shoppingList.isEmpty {
    print("The shopping list is empty.")
} else {
    print("The shopping list is not empty.")
}
shoppingList += ["Baking Powder"]
shoppingList += ["Chocolate Spread", "Cheese", "Butter"]
shoppingList + ["Other"]

var firstItem = shoppingList[0]
shoppingList[0] = "Six eggs"
shoppingList[4...6] = ["Bananas", "Apples"]
Array(shoppingList[4...6])
///使用range operator得到的，并不是一个Array，而是一个ArraySlices视图，它不真正保存数组的内容，只保存这个视图引用的数组的范围
shoppingList.insert("Maple Syrup", at: 0)
let mapleSyrup = remove(at: 0)
let apples = shoppingList.removeLast()
///removeFirst()  removeAll()  removeAll(keepCapacity: true) 保持数组容量
shoppingList.index{ $0 == "Cheese" } ///index会返回一个Optional<Int>
shoppingList.index(of:"CheeCheese")

shoppingList.first
shoppingList.last
type(of: shoppingList.first) /// 操作更安全 Optional<Int>.Type
shoppingList.popLast()       /// 如果数组为空，会返回nil


/************************************ Iterating Over an Array ***********************************/
for item in shoppingList { print(item) }
shoppingList.forEach{ print("FOREACH：\($0)",terminator:" ") }
//列举元素和对应的下标
for (index, value) in shoppingList.enumerated() {
    print("Item \(index + 1): \(value)")
}
//迭代除了第一个元素以外的数组其余部分
for item in shoppingList.dropFirst() {
    print(item)
}
//除去最后5个元素迭代其余部分
for item in shoppingList.dropLast(5) {
    print(item)
}


/****************************** 数组的可变性Array和NSArray的区别 *********************/
var array = [0,1,2]
var newArray = array
func getBufferAddress<T>(of array: [T]) -> String {
    return array.withUnsafeBufferPointer{ buffer in
        return String(describing: buffer.baseAddress)
    }
}
getBufferAddress(of: array)
getBufferAddress(of: newArray)

newArray.append(4)
getBufferAddress(of: array)
getBufferAddress(of: newArray)

let b = NSMutableArray(array: [1,2,3])
let copyB: NSArray = b
b.insert(99, at: 0)
copyB == b ///true

var c = b.copy() as! NSArray
b.insert(100, at: 0)
c == b ///false
t

/*************************  数组变形 使用函数处理数组(参数化)  *******************************/
//map
let arr = [1,2,3,45]
let squares = arr.map { $0 * $0 }
extension Array {
    func myMap<T>(_ transform: (Element) -> T) -> [T] {
        var tmp: [T] = []
        tmp.reserveCapacity(count)
        for value in self {
            tmp.append(transform(value))
        }
        return tmp
    }
}
// filter
let nums = [1,2,3,4,5,6,7,8,9,10]
nums.filter { num in num % 2 == 0 } // [2, 4, 6, 8, 10]
nums.filter { $0 % 2 == 0 } // [2, 4, 6, 8, 10]
extension Array {
    func filter(_ isIncluded: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for x in self where isIncluded(x) {
            result.append(x)
        }
        return result
    }
}
// contains
nums.contains { $0 % 2 == 0 } /// true
///一旦找到了第一个匹配的元素，它就将提前退出。 一般在需要所有结果时选择使用 filter。


//Reduce
let fibs = [0, 1, 1, 2, 3, 5]
fibs.reduce(0, +) /// 12
fibs.reduce("") { str, num in str + "\(num), " } /// 0, 1, 1, 2, 3, 5,
fibs.reduce("") { $0 + ",\($1)" }.dropFirst()
extension Array {
    func reduce<Result>(_ initialResult: Result,
                        _ nextPartialResult: (Result, Element) -> Result) -> Result {
        var result = initialResult
        for x in self {
            result = nextPartialResult(result, x)
        }
        return result
    }
}
extension Array {
    func map2<T>(_ transform: (Element) -> T) -> [T] {
        return reduce([]) {
            $0 + [transform($1)]
        }
    }
    func filter2(_ isIncluded: (Element) -> Bool) -> [Element] {
        return reduce([]) {
            isIncluded($1) ? $0 + [$1] : $0
        }
    }
}
extension Array {
    func filter3(_ isIncluded: (Element) -> Bool) -> [Element] {
        ///使用 inout 编译器不会每次都创建一个新的数组
        return reduce(into: []) { result, element in
            if isIncluded(element) {
                result.append(element)
            }
        }
    }
}
// flatMap
let arr1 = [1,2,3]
let arr2 = ["a","b","c"]
print ( arr1.flatMap { num in arr2.map{ str in return (num,str) } } )
/// [(1, "a"), (1, "b"), (1, "c"), (2, "a"), (2, "b"), (2, "c"), (3, "a"), (3, "b"), (3, "c")]
func myFlatMap<T>(_ transform:(Element)->[T])->[T]{
    var tempArray:[T] = []
    for items in self {
        /// map 添加元素 [[][][]] flatMap从另外一个Sequence添加内容
        tempArray.append(contentsOf: transform(items))
    }
    return tempArray
}
// forEach

// where return

// elementsEqual
var nums = [0, 1, 1, 2, 3, 5]
let flag = nums.elementsEqual([0,1,1,2,3,5], by: { $0 == $1 })
print(flag) /// true

// starts
let flag2 = nums.starts(with: [0,1], by: { $0 == $1 })
print(flag2)//true

// sort
nums.sort()
nums.sort(by: >)

// partition
var nums = [3,2,5,0,1,4]
let partition = nums.partition(by: { $0 < 3 })
let partition = nums.partition(by: { $0 == 3 }) //  nums[0..<partition] -> [4, 2, 5, 0, 1] partion: 5
nums[0..<partition] /// [3, 4, 5] 去掉 <3 的部分
nums[partition..<nums.endIndex] /// [0, 1, 2]
///重排数组,根据条件的分界点,前半部分的元素都不满足指定条,后半部分都满足指定条件

// joined
/// Descript:func joined(separator: String = default) -> String   an array of strings can be joined to a single
let cast = ["Vivien", "Marlon", "Kim", "Karl"]
let str = cast.joined(separator: "-")  ///数组内字符串元素重新组合成字符串 可添加分隔符 Vivien-Marlon-Kim-Karl
let list = str.split(separator: "-")   ///讲字符串按照其分隔符加入数组 ["Vivien", "Marlon", "Kim", "Karl"]

// drop
var arr = [1,3,4]
arr.dropFirst
arr.dropLast
let newArr = arr.drop(while: { $0 == 1 })
let newArr = arr.drop(while: { $0 < 4 }) // newArr: ArraySlice<Int>
print(newArr) // [4]
/// Once the predicate returns false it will not be called again 判断开头是否是1 true 返回剩余部分 false 返回原数组 


// custom
///从后遍历符合条件的元素
let names = ["Paula", "Elena", "Zoe"]
var lastNameEndingInA: String?
extension Sequence {
    func last(where predicate: (Element) -> Bool) -> Element? {
        for element in reversed() where predicate(element) {
            return element
        }
        return nil
    }
}
let match = names.last { $0.hasSuffix("a") }
match /// Optional("Elena")”
guard let match = someSequence.last(where: { $0.passesTest() }) else { return }

//保留合并时的每一个值
extension Array {
    func accumulate<Result>(_ initialResult: Result,
                            _ nextPartialResult: (Result, Element) -> Result) -> [Result] {
        var running = initialResult
        return map { next in
            running = nextPartialResult(running, next)
            return running
        }
    }
}
[1,2,3,4].accumulate(0, +) /// [1, 3, 6, 10]

//序列中所有元素都满足某个条件
extension Sequence {
    public func all(matching predicate: (Element) -> Bool) -> Bool {
        return !contains { !predicate($0) }
        /// contains { predicate($0) } 遍历到符合条件的 predicate -> true 立即 true
        /// contains { !predicate($0)} 遍历到符合条件的 ! predicate -> false 继续遍历最后返回false  取反全部符合
    }
}
let nums = [1,2,3,4,5,6,7,8,9,10]
let evenNums = nums.filter { $0 % 2 == 0 } /// [2, 4, 6, 8, 10]
evenNums.all { $0 % 2 == 0 } /// true

// 返回不满足条件的数组
func reject(comlection: (Element) -> Bool) -> [Element] {
    return filter { !comlection($0) }  /// 不满足条件即false 取反变true符合filter
}
