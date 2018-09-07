/** * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 ## 概念
 哈希算法将任意长度的二进制值映射为固定长度的较小二进制值，这个小的二进制值称为哈希值
 
 ## 过程
 + 通过散列函数(除留取余线性探测...)将字典的关键字映射到散列(数组)表中的特定位置(下标)
 + 遍历buckets[index]的enumerate 如果元祖内已经有值(相同的key对象产生了相同的哈希值) 判断新的key和原有的key是否相同
 + 如果key相同覆盖原来的值返回旧值,如果key不同就在相同的index下append元祖(非线性探测count+=1)
 + 新值为nil 找出该key的index 遍历出数组下标和元祖元素 如果元祖元素的key和设置为nil的key相同则删除(count-=1)
 
  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
public struct HashTable<Key: Hashable, Value> {
    private typealias Box = (boxTab: Key, data: Value)
    private typealias Drawer = [Box]
    private var storage: [Drawer]
    private(set) var count: Int
}
extension HashTable {
    var isEmpty: Bool {
        return count == 0
    }
    init(capacity: Int) {
        storage = [Drawer](repeating: [], count: capacity)
        count = 0
    }
    public subscript(boxTab: Key) -> Value? {
        get {
            let drawerIndex = self.index(of: boxTab)
            for box in storage[drawerIndex] where box.boxTab == boxTab {
                return box.data
            }
            return nil
        }
        set {
            if let newData = newValue {
                _ = updateValue(boxTab: boxTab, newData: newData)
            } else {
                _ = remove(boxTab)
            }
        }
    }
}
extension HashTable {
    mutating func updateValue (boxTab: Key, newData: Value) -> Value? {
        let drawerNum = index(of: boxTab)
        for (boxNum, items) in storage[drawerNum].enumerated() where items.boxTab == boxTab {
            let oldValue = items.data
            storage[drawerNum][boxNum].data = newData
            return oldValue
        }
        storage[drawerNum].append((boxTab: boxTab, data: newData))
        count += 1
        return nil
    }
}
extension HashTable {
    mutating func remove(_ boxTab: Key) -> Value? {
        let drawerIndex = index(of: boxTab)
        for (boxIndex, content) in storage[drawerIndex].enumerated() where content.boxTab == boxTab {
            let value = content.data
            storage[drawerIndex].remove(at: boxIndex)
            count -= 1
            return value
        }
        return nil
    }
}
extension HashTable {
    private func index(of drawer: Key) -> Int {
        return Swift.abs(drawer.hashValue) % storage.count
    }
}
extension HashTable: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.init(capacity: elements.count)
        elements.forEach {
            _ = updateValue(boxTab: $0.0, newData: $0.1)
        }
    }
}
extension HashTable: CustomDebugStringConvertible {
    public var debugDescription: String {
        var str = ""
        for (drawerIndex, boxs) in storage.enumerated() {
            let items = boxs.map { "\($0.boxTab): \($0.data)"}
            str += "DraerNum:\(drawerIndex) " + items.joined(separator: ", ") + "\n"
        }
        return str
    }
}
var list: HashTable = ["足球": 10, "篮球": 20, "排球": 30]
list["rugby"] = 50
list["篮球"] = nil
print(list.debugDescription)

/// Test
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif
// Playing with hash values
"firstName".hashValue
abs("firstName".hashValue) % 5 ///0

"lastName".hashValue
abs("lastName".hashValue) % 5  ///1

"hobbies".hashValue
abs("hobbies".hashValue) % 5   ///0

// Playing with the hash table
var hashTable = HashTable<String, String>(capacity: 5)

hashTable["firstName"] = "Steve"
hashTable["lastName"] = "Jobs"
hashTable["hobbies"] = "Programming Swift"

print(hashTable)
print(hashTable.debugDescription)

let x = hashTable["firstName"]
hashTable["firstName"] = "Tim"

let y = hashTable["firstName"]
hashTable["firstName"] = nil

let z = hashTable["firstName"]

print(hashTable)
print(hashTable.debugDescription)


//***************************   传统处理    ***************************
///非范型 在数组内没有元祖处理碰撞需要线性探测 没有Hashable 需要自定义散列函数
class HashTable {
    private var hashTable:Dictionary<Int, Int> = [:]
    private var list: Array<Int> = []
    var count: Int {
        return list.count
    }
    init(list: Array<Int>) {
        self.list = list
        createHashTable()
    }
    /// 查找value的对应的位置
    func search(value: Int) -> Int {
        var key = hashFunction(value: value)
        while hashTable[key] != value{
            key = conflictMethod(value: key)
        }
        return key
    }
    /// 输出散列表中的元素
    func displayHashTable() {
        for key in hashTable.keys {
            print("key:\(key)--value:\(hashTable[key]!)")
        }
    }
    /// 创建散列表
    private func createHashTable() {
        for item in self.list {
            add(value: item)
        }
    }
    /// 将数据添加到散列表中
    private func add(value: Int) {
        print("往hash表中插入\(value):")
        let key = createHashKey(value: value)
        hashTable[key] = value
        print("\(value)插入完毕，key为\(key)\n")
    }
    /// 生成hashKey
    private func createHashKey(value: Int) -> Int {
        var key = hashFunction(value: value)
        if hashTable[key] != nil {
            key = conflictHandling(value: key)
        }
        return key
    }
    /// 处理冲突
    private func conflictHandling(value: Int) -> Int {
        var key = value
        var cursor = hashTable[key]
        while cursor != nil {
            print("key:\(key)与value:\(cursor!)的key冲突，进行冲突处理key+=1")
            key = conflictMethod(value: key)
            cursor = hashTable[key]
        }
        return key
    }
    func hashFunction(value: Int) -> Int {
        return value % count
    }
    func conflictMethod(value: Int) -> Int {
        return (value + 1) % count
    }
}
class HashTableWithMod: HashTable {
    /// 散列函数： 除留取余法
    override func hashFunction(value: Int) -> Int {
        return value % self.count
    }
    /// 处理冲突的函数：线性探测
    override func conflictMethod(value: Int) -> Int {
        return (value + 1) % self.count
    }
}
/// 直接定址法+随机数探测法
class HashTableDirectDddressing: HashTable {
    override func hashFunction(value: Int) -> Int {
        return value / self.count
    }
    override func conflictMethod(value: Int) -> Int {
        let randomDisplacement = Int(arc4random_uniform(50))
        return (value + randomDisplacement) % self.count
    }
}
let list: Array<Int> = [62, 88, 58, 47, 62, 35, 73, 51, 99, 37, 93]
func hashTableTest(hashTable: HashTable) {
    hashTable.displayHashTable()
    let key = hashTable.search(value: 35)
    print("35的key为：\(key)")
}
print("哈希函数：除留取余法，处理冲突：线性探测法")
hashTableTest(hashTable: HashTableWithMod(list: list))
//hashTableTest(hashTable: HashTableDirectDddressing(list: list))

