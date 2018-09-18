/**
 + 单词查找树是哈希树的变种,一种专门用于解决类似检索问题的自定义数据结构
 + 字典树 (Trie)，也被称作数字搜索树 (digital search trees)，是一种特定类型的有序树，通常被用于搜索由一连串字符组成的字符串。
 + 不同于将一组字符串储存在一棵二叉搜索树中，字典树把构成这些字符串的字符逐个分解开来，储存在了一个更高效的数据结构中
 + BinarySearchTree 类型的每个节点处都存在两棵子树。对于字典树来说，则是每一个字符都 (潜在地) 对应着一棵子树，不过也因此，其每个节点的子树个数都是不确定的
 + 应用于统计，排序和保存大量的字符串（但不仅限于字符串），经常被搜索引擎系统用于文本词频统计
 + 优点：利用字符串的公共前缀来减少查询时间，最大限度地减少无谓的字符串比较，查询效率比哈希树高
 + 根节点不包含字符，除根节点外每一个节点都只包含一个字符
 + 从根节点到某一节点，路径上经过的字符连接起来，为该节点对应的字符串； 每个节点的所有子节点包含的字符都不相同
 
 ````
      *
     / \
    C   D
    |   |
    A   O
   / \  |
  R   T G
  |
  T
 
 ````
 */
import Foundation
struct Trie<Element:Hashable> {                                /// 在给定一组搜索的历史记录和一个现在待搜索字符串的前缀时，计算出一个与之相匹配的补全列表
    let isElement:Bool                                         /// 标记截止于当前节点的字符串是否在树中
    let children:[Element: Trie<Element>]
}
extension Trie {
    init() {
        isElement = false
        children = [:]
    }
}

extension Trie {
    var elements: [[Element]] {                                ///  trie.children
        var result: [[Element]] = isElement ? [[]] : []        ///  [A: trie]                                                              ^ [] + [AB],[AC]]
        for (key, value) in children {                         ///        | children                                 flatten               ^ [] + [[B],[C]].map
            result += value.elements.map { [key] + $0 }        ///  [B: trie, C: trie ] ---->  [A, [B:trie, C:trie]]  --------------->     ^ rhs: [] +[[B]].map -> [[B][C]]
        }                                                      ///        |       |                                   左分支递归至最后map     ^ lhs: [] + [].map -> [B]+$0 -> [[B]]
        return result                                          ///  [ empty ] [ empty ]                               回溯执行                 []
    }                                                          ///
}                                                              ///                                                    c     [[cat] + [car]]
extension Array {                                              /// var arr = [1, 2, 3, 4, 5]                          |     [] + [[at],[ar]].map
    var slice: ArraySlice<Element> {                           /// arr.slice.decomposed                               a     [] + [[at]] + [[ar]]
        return ArraySlice(self)                                /// Optional((1, ArraySlice([2, 3, 4, 5])))            |\    [] + [[t]].map + [[r]].map
    }                                                          ///                                                    t r   [].map -> [] +[[t] + $0] -> result = [[t]]
}
extension ArraySlice {
    var decomposed: (Element, ArraySlice<Element>)? {               /// array.dropfirst      O(n)
        return isEmpty ? nil : (self[startIndex], self.dropFirst()) /// arraySlice.dropfirst O(1)
    }                                                               /// func sum(_ integers: ArraySlice<Int>) -> Int
}                                                                   /// guard let (head, tail) = integers.decomposed else { return 0 }
extension Trie {                                                    /// return head + sum(tail)
    func lookup(key: ArraySlice<Element>) -> Bool {                 /// sum([1,2,3,4,5].slice)
        guard let (head, tail) = key.decomposed else { return isElement }
        guard let subtrie = children[head] else { return false }            /// 遍历一棵字典树 来逐一确定对应的键是否储存在树中
        return subtrie.lookup(key: tail)                                    /// 查询到空数组返回判断字符是否在树中的布尔值
    }                                                                       /// ArraySlice中所有键值分离出第一个取值 如果不存在对应的子树 false
}                                                                           /// 查询键组中第一个对应的子树, 如果存在子树递归调用函数查询剩余的键是否在子树中
extension Trie {                                                            /// 如果全部包含最后 isElement 为true
    func lookup(key: ArraySlice<Element>) -> Trie<Element>? {
        guard let (head, tail) = key.decomposed else { return self }
        guard let remainder = children[head] else { return nil }
        return remainder.lookup(key: tail)                                  /// return self 给定一个前缀键组，使其返回一个含有所有匹配元素的子树
    }                                                                       /// lookup.elementss ?? [] 字典树中给定前缀相匹配的所有字符串
}                                                                           /// 如果结果是字典树，就将其中的元素提取出来。如果不存在与给定前缀匹配的子树，就返回一个空数组
extension Trie {
    func complete(key: ArraySlice<Element>) -> [[Element]] {
        return lookup(key: key)?.elements ?? []
    }
}
extension Trie {                                                        /// 如果传入的键组不为空，且能够被分解为 head 与 tail，我们就用 tail 递归地创建一棵字典树
    init(_ key: ArraySlice<Element>) {                                  /// 然后创建一个新的字典 children，以 head 为键存储这个刚才递归创建的字典树
        if let (head, tail) = key.decomposed {                          /// 最后，用这个字典创建一棵新的字典树
            let children = [head: Trie(tail)]                           /// 因为输入的 key 非空，这意味着当前键组尚未被全部存入，所以 isElement 应该是 false
            self = Trie(isElement: false, children: children)           /// 如果传入的键组为空，可以创建一棵没有子节点的空字典树，用于储存一个空字符串，并将 isElement 赋值为 true
        } else {                                                        /// [A, B, C]   children = [A: Trie(BC)]    self = Trie(children)  ^  [A: [B: [C:Trie]]]
            self = Trie(isElement: true, children: [:])                 ///             children = [B: Trie(C)]     self = Trie(children)  ^  [B: [C:Trie]]
        }                                                               ///             children = [C: Trie[]]      self = Trie(children)  ^  [C: Trie()]
    }                                                                   ///                            Trie([:])                           ^
}                                                                       /// [head: 递归Trie(创建children 创建当前的Trie [head: Trie] 递归最后Tire(children[:]))]
extension Trie {
    func inserting(_ key: ArraySlice<Element>) -> Trie<Element> {       /// 如果键组为空将 isElement 设置为 true，然后不再修改剩余的字典树
        guard let (head, tail) = key.decomposed else {                  /// 如果键组不为空，且键组的 head 已经存在于当前节点的 children 字典中
            return Trie(isElement: true, children: children)            /// 需要递归地调用该函数，将键组的 tail 插入到对应的子字典树中
        }                                                               /// 如果键组不为空，且第一个键 head 并不是该字典树中 children 字典的某条记录，
                                                                        /// 就创建一棵新的字典树来储存键组中剩下的键。然后，以 head 键对应新的字典树，储存在当前节点中，完成插入操作
        var newChildren = self.children                                 /// [A,B,C]     A     head:A   child[A: Trie.insert
        if let nextTrie = children[head] {                              ///             | \                                                     return Trie(children)
            newChildren[head] = nextTrie.inserting(tail)                ///             E  B  head:B   currentChild[E: Trie, B: Trie(remainC)]  return Trie(currentChildren)
        } else {                                                        ///             |  |
            newChildren[head] = Trie(tail)                              ///             W  C
        }                                                               /// newChildren[head] = nextTrie.inserting(tail) 如果传入的值分离后相同则递归 最后guard如果返回child 则全部相同
        return Trie(isElement: isElement, children: newChildren)        /// newChildren[head] = Trie(tail) 在原child字典内添加新的 键值对 添加结束后 return 该层新的Trie 回溯return全部
    }
}
extension Trie {
    static func build(words: [String]) -> Trie<Character> {             ///  ["cat", "car", "cart", "dog"]
        let emptyTrie = Trie<Character>()                               ///  reduce initial: trie
        return words.reduce(emptyTrie) { trie, word in                  ///  insert [c, a ,t]
            trie.inserting(Array(word.characters).slice)
        }
    }
}
extension String {
    func complete(_ knownWords: Trie<Character>) -> [String] {          /// chars = [c,a]                                c
        let chars = Array(self).slice                                   /// lookUP  chars.decomposed                     |
        let completed = knownWords.complete(key: chars)                 /// child[c] != nil subTrie.loopUP               a
        return completed.map { chars in                                 /// child[a] != nil subTrie.lookUP               |\
            self + String(chars)                                        /// decomposed = nil return self -> subtrie      r t
        }                                                               /// [r:[t:[]], t:[]].element                     |
    }                                                                   /// for (key, trie) in ^                         t
}                                                                       /// trie.element.map { [key + $0] }
let contents = ["cat", "car", "cart", "dog"]                            /// [r] + [[r,t]] + [t]
let trieOfWords = Trie<Character>.build(words: contents)                /// [ [r], [r,t], [t] ].map
"ca".complete(trieOfWords)                                              /// ca + String(sequence: [r])
//["car", "cart", "cat"]                                                /// [car]

/****************************************** Version 2 ******************************************

 + 数组转切片 切片是否可首尾分离
 + 每个Element都有一个Trie
 + 递归创建Trie 递归到最后Element: Trie(该类型传入空[:])
 + 插入如果传入为空 isElement为true 截止到当前节点字符串已经存在Trie
 + 传入的值分解出head 和 在当前children字典内是否存在 如果存在递归 不存在则创建新的 返回当前包含新内容的children字典
 + 配置Trie reduceTrie 在原有的基础上依次插入传入的字符串的slice
 
 */

extension Array {
    var slice: ArraySlice<Element> {
        return ArraySlice(self)
    }
}
extension ArraySlice {
    var decomposed: (Element, ArraySlice)? {
        return isEmpty ? nil : (self[startIndex], self.dropFirst())
    }
}
public struct Trie <Element: Hashable> {
    private var isElement: Bool
    private var children: [Element: Trie<Element>]
}
extension Trie {
    public init(_ arraySlice: ArraySlice<Element>) {
        if let (head, remained) = arraySlice.decomposed {
            let children = [head: Trie(remained)]
            self = Trie(isElement: false, children: children)
        } else {
            self = Trie(isElement: true, children: [:])
        }
    }
}
extension Trie {
    private func insert(_ arraySlice: ArraySlice<Element>) -> Trie {
        guard let (head, remian) = arraySlice.decomposed else {
            return Trie(isElement: true, children: children)
        }
        var currnetChildren = children
        if let getCurrentTrie = currnetChildren[head] {
            currnetChildren[head] = getCurrentTrie.insert(remian)
        } else {
            currnetChildren[head] = Trie.init(remian)
        }
        return Trie.init(isElement: isElement, children: currnetChildren)
    }
    static public func configTrie(with words: [String]) -> Trie<Character> {
        return words.reduce(Trie<Character>(isElement: false, children: [:])) {
            $0.insert(Array($1).slice)
        }
    }
}
extension Trie {
    private func lookUp(with arraySlice: ArraySlice<Element>) -> Trie<Element>? {
        guard let (head, remained) = arraySlice.decomposed else { return self }
        guard let nextTrie = children[head] else { return nil }
        return nextTrie.lookUp(with: remained)
    }
    private func elementsInTrie() -> [[Element]] {
        var result: [[Element]] = isElement ? [[]] : []
        for (element, trie) in children {
            result += trie.elementsInTrie().map { [element] + $0 }
        }
        return result
    }
    public func checkOut(_ wordSlice: ArraySlice<Element>) -> [[Element]] {
        return lookUp(with: wordSlice)?.elementsInTrie() ?? []
    }
}
extension String {
    public func fuzzyQuery(in storage: Trie<Character>) -> [String] {
        let characters = Array(self).slice
        return storage.checkOut(characters).map { self + String($0) }
    }
}
let trie = Trie<Character>.configTrie(with: ["cat", "car", "cart", "dog"])
let result = "car".fuzzyQuery(in: trie)
print(result) // ["car", "cart"]
