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
    private typealias Element = (key: Key, value: Value)
    private typealias Bucket = [Element]
    private var buckets: [Bucket]
    private(set) var count = 0
    init(capacity: Int) {
        buckets = [Bucket](repeating: [], count: capacity)
    }
}
extension HashTable {
    public var isEmpty: Bool {
        return count == 0
    }
}
extension HashTable {
    public subscript(key: Key) -> Value? {
        get {
            return getValue(by: key)
        }
        set {
            if let newValue = newValue {
                updateValue(key: key, newValue: newValue)
            } else {
                remove(key)
            }
        }
    }
}
extension HashTable {
    public func getValue(by key: Key) -> Value? {
        let index = self.index(of: key)
        for element in buckets[index]  where element.key == key {
            return element.value
        }
        return nil
    }
}
extension HashTable {
    @discardableResult
    public mutating func updateValue(key: Key, newValue: Value) -> Value? {
        let index = self.index(of: key)
        for (cursor, element) in buckets[index].enumerated() where element.key == key {
            let oldValue = element.value
            buckets[index][cursor].value = newValue
            return oldValue
        }
        buckets[index].append((key: key, value: newValue))
        count += 1
        return nil
    }
    @discardableResult
    public mutating func remove(_ key: Key) -> Value? {
        let index = self.index(of: key)
        for (cursor, element) in buckets[index].enumerated() where element.key == key {
            buckets[index].remove(at: cursor)
            count -= 1
        }
        return nil
    }
    public mutating func removeAll() {
        buckets = [Bucket](repeating: [], count: 0)
    }
}
extension HashTable {
    private func index(of key: Key) -> Int {
        return Swift.abs(key.hashValue) % buckets.count
    }
}
extension HashTable: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self.init(capacity: elements.count)
        self.count = elements.count
        elements.forEach {
            updateValue(key: $0.0, newValue: $0.1)
        }
    }
}
extension HashTable: CustomStringConvertible {
    public var description: String {
        return buckets.flatMap { bucket in
            bucket.map { "\($0.key): \($0.value)" }
            }.joined(separator: "\t")
    }
}
extension HashTable: CustomDebugStringConvertible {
    public var debugDescription: String {
        var str = ""
        for (index, element) in buckets.enumerated() {
            let bucketContent = element.map { "\($0.key): \($0.value)" }.joined(separator: "\t")
            str += "\(index)\t" + bucketContent + "\n"
        }
        return str
    }
}

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

