/**
 *概念:字符串是有序的Character（字符）类型值的集合。通过String类型来表示。Character是人类在阅读文字时所理解的单个字符,与编码点无关
 *特点:
  1. 支持访问字符的多种 Unicode 表示形式
  2. 与 Foundation NSString 无缝桥接,在String中调用这些NSString的方法，将不用进行转换
  3. 不支持随机访问,只遵循了 BidirectionalCollection,跳到字符串中某个随机的字符不是一个 O(1) 操作,必须查看这个字符前面的所有字符，才能最终确定对象字符的存储位置*/

//String Literals
///作用: 用于为常量和变量提供初始值
let someString = "Some string literal value"


//Multiline String Literals
let quotation = """
The White Rabbit put on his spectacles.  "Where shall I begin,
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on
till you come to the end; then stop."
"""

let singleLineString = "These are the same."
let multilineString = """
These are the same.
"""

///don’t want the line breaks to be part of the string’s value, write a backslash (\) at the end of those lines
let softWrappedQuotation = """
The White Rabbit put on his spectacles.  "Where shall I begin, \
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on \
till you come to the end; then stop."
"""

///To make a multiline string literal that begins or ends with a line feed, write a blank line as the first or last line
let lineBreaks = """

This string starts with a line break.
It also ends with a line break.

"""

//Special Characters in String Literals
///\0 (null character), \\ (backslash), \t (horizontal tab), \n (line feed), \r (carriage return), \" (double quotation mark) and \' (single quotation mark)
let wiseWords = "\"Imagination is more important than knowledge\" - Einstein"
/// "Imagination is more important than knowledge" - Einstein
let dollarSign = "\u{24}"        /// $,  Unicode scalar U+0024
let blackHeart = "\u{2665}"      /// ♥,  Unicode scalar U+2665
let sparklingHeart = "\u{1F496}" /// 💖, Unicode scalar U+1F496

let threeDoubleQuotationMarks = """
Escaping the first quotation mark \"""
Escaping all three quotation marks \"\"\"
"""


//Initializing an Empty String
var emptyString = ""               /// empty string literal
var anotherEmptyString = String()  /// initializer syntax
if emptyString.isEmpty { print("Nothing to see here") } /// 通过检查其Bool类型的isEmpty属性来判断该字符串是否为空




//String Mutability
var variableString = "Horse"        ///将一个特定字符串分配给一个变量来对其进行修改
variableString += " and carriage"   ///variableString is now "Horse and carriage"
let constantString = "Highlander"   ///分配给一个常量来保证其不会被修改
constantString += " and another Highlander" /// this reports a compile-time error - a constant string cannot be modified


//Strings Are Value Types


//Working with Characters
for character in "Dog!🐶" {
    print(character)
}
/// D
/// o
/// g
/// !
/// 🐶
let exclamationMark: Character = "!"    ///建立一个独立的字符常量或变量
let catCharacters: [Character] = ["C", "a", "t", "!", "🐱"] ///字符串可以通过传递一个值类型为Character的数组作为自变量来初始化
let catString = String(catCharacters)
print(catString)/// Prints "Cat!🐱"
//CharacterSet
/// 一个表示一系列 Unicode 标量的数据结构体。它完全和 Character 类型不兼容
///CharacterSet 没有实现 Sequence 或者 Collection
let favoriteEmoji = CharacterSet("👩‍🚒👨‍🎤".unicodeScalars)
favoriteEmoji.contains("🚒") /// true 在集合内 因为 女消防员中有救护车的组合



/// 字符串分割为单词
extension String { /// alphanumerics 字母数字
    /// character 工厂初始化方法
    func words(with charset: CharacterSet = .alphanumerics) -> [Substring] {
        return self.unicodeScalars.split {
            !charset.contains($0)/// 在每一个非字母数字上分割
            }.map(Substring.init)
    }
}

let code = "struct Array<Element>: Collection { }"
code.words() // ["struct", "Array", "Element", "Collection"]”





//Concatenating Strings and Characters
///注意: 不能将一个字符串或者字符添加到一个已经存在的字符变量上，因为字符变量只能包含一个字符
let string1 = "hello"
let string2 = " there"
var welcome = string1 + string2 /// welcome now equals "hello there"

var instruction = "look over"
instruction += string2 /// instruction now equals "look over there"


let exclamationMark: Character = "!"
welcome.append(exclamationMark)/// welcome now equals "hello there!"

let badStart = """
one
two
"""
let end = """
three
"""
print(badStart + end)
/// Prints two lines:
/// one
/// twothree

let goodStart = """
one
two

"""
print(goodStart + end)
/// Prints three lines:
/// one
/// two
/// three




//String Interpolation
///概念: 字符串插值是一种构建新字符串的方式，可以在其中包含常量、变量、字面量和表达式
///注意: 插值字符串中写在括号中的表达式不能包含非转义反斜杠 (\)，并且不能包含回车或换行符
let multiplier = 3
let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"/// message is "3 times 2.5 is 7.5"




/********************************************************* Unicode ***************************************************/

//Unicode Scalars
///概念: Unicode 标量是对应字符或者修饰符的唯一的21位数字,Swift 的String类型是基于 Unicode 标量建立的 ,标量在 Swift 字符串字面量中以 "\u{xxxx}" 来表示
///范围: Unicode 标量不包括 Unicode 代理项(surrogate pair) 码位，其码位范围是U+D800到U+DFFF (Unicode 码位(code poing) 的范围是U+0000到U+D7FF)
///注意: 不是所有的21位 Unicode 标量都代表一个字符，因为有一些标量是留作未来分配的。已经代表一个典型字符的标量都有自己的名字 (FRONT-FACING BABY CHICK) ("🐥")

extension Unicode.Scalar {
    /// 标量的 Unicode 名字，比如 "LATIN CAPITAL LETTER A".
    /// Unicode 标量转换为它们对应的官方 Unicode 名字
    var unicodeName: String {
        /// 强制解包是安全的，因为这个变形不可能失败
        let name = String(self).applyingTransform(.toUnicodeName, reverse: false)!
        /// 变形后的字符串以 "\\N{...}" 作为名字开头，将它们去掉
        let prefixPattern = "\\N{"
        let suffixPattern = "}"
        /// 判断是否有前缀
        let prefixLength = name.hasPrefix(prefixPattern) ? prefixPattern.count : 0
        let suffixLength = name.hasSuffix(suffixPattern) ? suffixPattern.count : 0
        return String(name.dropFirst(prefixLength).dropLast(suffixLength))
    }
}
let skinTone = "👧🏽" /// 👧 + 🏽
skinTone.count /// 1”
let result = skinTone.unicodeScalars.map { $0.unicodeName }
print(result) /// ["GIRL", "EMOJI MODIFIER FITZPATRICK TYPE-4"]




//Extended Grapheme Clusters(可扩展字符群集)
///Every instance of Swift’s Character type represents a single extended grapheme cluster.
///An extended grapheme cluster is a sequence of one or more Unicode scalars that (when combined) produce a single human-readable character.
///概念: Swift 的Character类型代表一个可扩展的字形群,一个可扩展的字形群是一个或多个可生成人类可读的字符 Unicode 标量的有序排列
///说明: 字母é可以用单一的 Unicode 标量é  一个标准的字母e加上一个急促重音的标量(U+0301)，这样一对标量就表示了同样的字母é
///     在这两种情况中，字母é代表了一个单一的 Swift 的Character值，同时代表了一个可扩展的字形群

let eAcute: Character = "\u{E9}"                         /// é                第一种情况，这个字形群包含一个单一标量
let combinedEAcute: Character = "\u{65}\u{301}"          /// e followed by  ́  第二种情况，它是包含两个标量的字形群
/// eAcute is é, combinedEAcute is é


let precomposed: Character = "\u{D55C}"                  /// 한
let decomposed: Character = "\u{1112}\u{1161}\u{11AB}"   /// ᄒ, ᅡ, ᆫ
/// precomposed is 한, decomposed is 한 可扩展的字符群集是一个灵活的方法，用许多复杂的脚本字符表示单一的Character值

let enclosedEAcute: Character = "\u{E9}\u{20DD}"
/// enclosedEAcute is é⃝ 可拓展的字符群集可以使包围记号的标量包围其他 Unicode 标量，作为一个单一的Character值

let regionalIndicatorForUS: Character = "\u{1F1FA}\u{1F1F8}" ///U S
/// regionalIndicatorForUS is 🇺🇸 地域性指示符号的 Unicode 标量可以组合成一个单一的Character值


//Counting Characters
///注意: 可扩展的字符群集可以组成一个或者多个 Unicode 标量。这意味着不同的字符以及相同字符的不同表示方式可能需要不同数量的内存空间来存储
///     所以 Swift 中的字符在一个字符串中并不一定占用相同的内存空间数量。因此在没有获取字符串的可扩展的字符群的范围时候，就不能计算出字符串的字符数量
///     处理一个长字符串，需要注意characters属性必须遍历全部的 Unicode 标量，来确定字符串的字符数量
///     characters属性返回的字符数量并不总是与包含相同字符的NSString的length属性相同。NSString的length属性是利用 UTF-16 表示的十六位代码单元数字，而不是 Unicode 可扩展的字符群集
let unusualMenagerie = "Koala 🐨, Snail 🐌, Penguin 🐧, Dromedary 🐪"
print("unusualMenagerie has \(unusualMenagerie.count) characters")
/// Prints "unusualMenagerie has 40 characters"


var word = "cafe"     /// 在 Swift 中，使用可拓展的字符群集作为Character值来连接或改变字符串时，并不一定会更改字符串的字符数量
print("the number of characters in \(word) is \(word.count)") /// Prints "the number of characters in cafe is 4"
word += "\u{301}"    ///  COMBINING ACUTE ACCENT, U+0301
print("the number of characters in \(word) is \(word.count)") /// Prints "the number of characters in café is 4"


/// NSString 基于编码单元进行比较 不考虑 字符组合起来的 标准等价
let nssingle = single as NSString
nssingle.length
let nsdouble = double as NSString
nsdouble.length
nssingle == nsdouble //false


/// 面对颜文字的复杂流行多变 提供一个优先级的标准等价很重要
/// 默认行为十分重要，Swift 认为默认情况下行为正确具有更高的优先级。如果你想要下降到一个更低层级的抽象中，String 也提供了直接操作 Unicode 标量和编码单元的字符串视图。
let enmoji = "😊"
enmoji.count
enmoji.utf16.count
enmoji.unicodeScalars.count

let flags = "🇪🇹🇵🇪"
flags.count
flags.unicodeScalars.count

/// 标量值格式化为编码点常用的十六进制格式
/// 观察unicode组成的标量 使用字符串的 unicodeScalars 视图
flags.unicodeScalars.map{
    "U+\(String($0.value, radix: 16, uppercase: true))"
}



let family1 = "👨‍👩‍👧‍👦"
let family2 = "👨\u{200D}👩\u{200D}👧\u{200D}👦"
family1 == family2 // true
family1.count









/**Accessing and Modifying a String***/
/// 注意: 不同的字符可能会占用不同数量的内存空间，所以要知道Character的确定位置，就必须从String开头遍历每一个 Unicode 标量直到结尾。因此，Swift 的字符串不能用整数(integer)做索引
/// 整数的下标无法在常数时间内完成 String.Index 是 String 和它的视图所使用的索引类型，它本质上是一个存储了从字符串开头的字节偏移量的不透明值。
/// 如果你想计算第 n 个字符所对应的索引，你依然从字符串的开头或结尾开始，并花费 O(n) 的时间。但是一旦你拥有了有效的索引，就可以通过索引下标以 O(1) 的时间对字符串进行访问了
let greeting = "Guten Tag!"
greeting[greeting.startIndex]/// G 下标语法
greeting[greeting.index(before: greeting.endIndex)] /// !
greeting[greeting.index(after: greeting.startIndex)]/// u  如果String是空串，startIndex和endIndex是相等的。
let index = greeting.index(greeting.startIndex, offsetBy: 7)
greeting[index]/// a

greeting[greeting.endIndex] /// Error   使用endIndex属性可以获取最后一个Character的后一个位置的索引 endIndex属性不能作为一个字符串的有效下标
greeting.index(after: greeting.endIndex) /// Error

for index in greeting.indices { ///使用 characters 属性的 indices 属性会创建一个包含全部索引的范围(Range)，用来在一个字符串中访问单个字符
    /// indeces 以升序的顺序对集合进行下标的索引迭代 获取索引的集合
    print("\(greeting[index]) ", terminator: "")
}/// Prints "G u t e n   T a g ! "

var hello = "Hello!"
if let idx = hello.index(of: "!") {
    hello.insert(contentsOf: ", world", at: idx)

extension String {
    var allPrefixes2: [Substring] {  /// <O n>
        return [""] + self.indices.map { index in self[...index] /// 区间切片
        }
    }
}
hello.allPrefixes2  ///["", "H", "He", "Hel", "Hell", "Hello"]


/// String 满足 RangeReplaceableCollection 协议
/// 不满足 MutableCollection
var greeting = "Hello, world!"
if let comma = greeting.index(of: ",") {
    greeting[..<comma]  // Hello
    greeting.replaceSubrange(comma..., with: " again.")
}
greeting /// Hello again
/// 字符串中的字符可能是可变长度，改变其中一个元素的宽度将意味着要把后面元素在内存中的位置上下移动
/// 不止如此，在被插入的索引位置之后的所有索引值也会由于内存未知的改动而失效，这同样并不直观
/// 由于这些原因，就算你想要更改的元素只有一个，你也必须使用 replaceSubrange



//Inserting and Removing
var welcome = "hello"
welcome.insert("!", at: welcome.endIndex) /// welcome now equals "hello!"
welcome.insert(contentsOf: " there", at: welcome.index(before: welcome.endIndex))/// welcome now equals "hello there!"
welcome.remove(at: welcome.index(before: welcome.endIndex))/// welcome now equals "hello there"
let range = welcome.index(welcome.endIndex, offsetBy: -6)..<welcome.endIndex ///在一个字符串的指定索引删除一个子字符串
welcome.removeSubrange(range) /// welcome now equals "hello"



/****************************   Substrings  *****************************/
/// String 有一个特定的 SubSequence 类型它是一个以不同起始和结束索引的对原字符串的切片
/// Substring 和 String 的接口几乎完全一样。这是通过一个叫做 StringProtocol 的通用协议来达到的，String 和 Substring 都遵守这个协议
/// 子字符串应短暂存储 避免在操作过程中发生昂贵的复制 因为子字符串会一值持有整个字符串
/// 当这个操作结束，你想将结果保存起来，或是传递给下一个子系统，这时你应该通过初始化方法从 Substring 创建一个新的 String
/// 如果有一个巨大的字符串，它的一个只表示单个字符的子字符串将会在内存中持有整个字符串
/// 即使当原字符串的生命周期本应该结束时，只要子字符串还存在，这部分内存就无法释放
    
let greeting = "Hello, world!"
let index = greeting.index(of: ",") ?? greeting.endIndex
let beginning = greeting[..<index]  /// beginning is "Hello"
let newString = String(beginning)   /// Convert the result to a String for long-term storage.
let poem = """
Over the wintry
forest, winds howl in rage
with no leaves to blow.
"""
let lines = poem.split(separator: "\n") ///不包含符合条件的元素 并以此分割成子序列数组 \n
print(lines) ///["Over the wintry", "forest, winds howl in rage", "with no leaves to blow."]
type(of: lines) ///Array<Substring>.


///根据字符数在其后空格处分割成段落
extension String {
    func wrapped(after: Int = 70) -> String {
        var i = 0 ///字符数
        let lines = self.split(omittingEmptySubsequences: false) { character in
            switch character {
            case "\n" where i >= after, " " where i >= after:
                /// 匹配到换行 和 空格 并且大于给定字符数 那么就把这个字符当作切割点 然后重新开始下一轮
                i = 0
                return true
            default:
                i += 1
                return false
            }
        }
        return lines.joined(separator: "\n") /// 将一个序列中的元素使用给定的分隔符拼接起为新的字符串，并返回  满足StringProtocol的序列可使用joined
    }
}
print ( lineBreaks.wrapped(after: 15) )
   
    
/// 可接受多个分隔符的序列
extension Collection where Element: Equatable {
    func split<S: Sequence>(separators: S) -> [SubSequence] where Element == S.Element {
        return split { separators.contains($0) }
    }
}
"Hello, world!".split(separators: ",!") /// ["Hello", "world"]”

///一个空一个的分割
var i = 0
let array = "hello".unicodeScalars.split{ _ in ///会遍历字符串中每个元素
    if i > 0 {
        i = 0
        return true ///把当前字符作为分隔符来处理
    } else {
        i += 1
        return false
    }
    }.map(String.init)
print(array)
    
    
/// 子字符串也遵循 StringProtocol
func lastWord(in input: String) -> String? {
    /// 处理输入，操作子字符串
    let words = input.split(separator: ",")
    guard let lastWord = words.last else { return nil }
    /// 转换为字符串并返回
    return String(lastWord) /// 子字符串应短暂存储 避免在操作过程中发生昂贵操作
}
lastWord(in: "one, two, three, four, five") // Optional("five")”

let commaSeparatedNumbers = "1,2,3,4,5"
let numbers = commaSeparatedNumbers.split(separator: ",").compactMap { Int($0) }
///Returns an array containing the non-nil results of calling the given transformation with each element of this sequence.
    
//split
let line = "BLANCHE:   I don't want realism. I want magic!"
print(line.split(whereSeparator: { $0 == " " }))
/// Prints "["BLANCHE:", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"

/// 确定分割数量
print(line.split(maxSplits: 1, whereSeparator: { $0 == " " }))
/// Prints "["BLANCHE:", "  I don\'t want realism. I want magic!"]"

/// 是否忽略空格 fase 即把空行也加入到数组
print(line.split(omittingEmptySubsequences: false, whereSeparator: { $0 == " " }))
/// Prints "["BLANCHE:", "", "", "I", "don\'t", "want", "realism.", "I", "want", "magic!"]"
   

    


/**Comparing Strings*/
///如果两个字符串（或者两个字符）的可扩展的字形群集是标准相等的，那就认为它们是相等的。即使可扩展的字形群集是有不同的 Unicode 标量构成的，只要它们有同样的语言意义和外观，就认为它们标准相等。
let quotation = "We're a lot alike, you and I."
let sameQuotation = "We're a lot alike, you and I."
if quotation == sameQuotation {
    print("These two strings are considered equal")
}/// Prints "These two strings are considered equal"


let eAcuteQuestion = "Voulez-vous un caf\u{E9}?" /// "Voulez-vous un café?" using LATIN SMALL LETTER E WITH ACUTE
let combinedEAcuteQuestion = "Voulez-vous un caf\u{65}\u{301}?"/// "Voulez-vous un café?" using LATIN SMALL LETTER E and COMBINING ACUTE ACCENT
if eAcuteQuestion == combinedEAcuteQuestion {
    print("These two strings are considered equal")
}/// Prints "These two strings are considered equal" 这两个字符群集都是表示字符é的有效方式，所以它们被认为是标准相等的

let latinCapitalLetterA: Character = "\u{41}"
let cyrillicCapitalLetterA: Character = "\u{0410}"
if latinCapitalLetterA != cyrillicCapitalLetterA {
    print("These two characters are not equivalent.")
}
/// Prints "These two characters are not equivalent.
///"英语中的LATIN CAPITAL LETTER A(U+0041，或者A)不等于俄语中的CYRILLIC CAPITAL LETTER A(U+0410，或者A)。两个字符看着是一样的，但却有不同的语言意义




/*Prefix and Suffix Equality*/
///hasPrefix(_:)/hasSuffix(_:)方法来检查字符串是否拥有特定前缀/后缀,两个方法均接收一个String类型的参数，并返回一个布尔值。
let romeoAndJuliet = [
    "Act 1 Scene 1: Verona, A public place",
    "Act 1 Scene 2: Capulet's mansion",
    "Act 1 Scene 3: A room in Capulet's mansion",
    "Act 1 Scene 4: A street outside Capulet's mansion",
    "Act 1 Scene 5: The Great Hall in Capulet's mansion",
    "Act 2 Scene 1: Outside Capulet's mansion",
    "Act 2 Scene 2: Capulet's orchard",
    "Act 2 Scene 3: Outside Friar Lawrence's cell",
    "Act 2 Scene 4: A street in Verona",
    "Act 2 Scene 5: Capulet's mansion",
    "Act 2 Scene 6: Friar Lawrence's cell"
]
var act1SceneCount = 0
for scene in romeoAndJuliet {
    if scene.hasPrefix("Act 1 ") {
        act1SceneCount += 1
    }
}
print("There are \(act1SceneCount) scenes in Act 1") /// Prints "There are 5 scenes in Act 1"
var mansionCount = 0
var cellCount = 0
for scene in romeoAndJuliet {
    if scene.hasSuffix("Capulet's mansion") {
        mansionCount += 1
    } else if scene.hasSuffix("Friar Lawrence's cell") {
        cellCount += 1
    }
}
print("\(mansionCount) mansion scenes; \(cellCount) cell scenes")/// Prints "6 mansion scenes; 2 cell scenes"



/**Unicode Representations of Strings**/
///当一个 Unicode 字符串被写进文本文件或者其他储存时，字符串中的 Unicode 标量会用 Unicode 定义的几种编码格式（encoding forms）编码,每一个字符串中的小块编码都被称代码单元（code units）
///

let dogString = "Dog‼🐶"
//UTF-8 Representation
///编码字符串为8位的代码单元 swift 将 UTF-16 和 UTF-8 的编码单元分别用 UInt16 和 UInt8 来表示
///一个编码点(Character)占据 1~4 个编码单元(
Unicode.UTF8.CodeUnit.self == UInt8.self

for codeUnit in dogString.utf8 {
    print("\(codeUnit) ", terminator: "")
}
/// Prints "68 111 103 |  226 128 188 | 240 159 144 182 "
/// D o g  分别用了一个8位编码单元 !! 用了三个编码单元 🐶用了 四个编码单元 4字节的UTF-8表示


let tweet = "Having ☕️ in a cafe\u{301} in 🇫🇷 and enjoying the ☀️."
let characterCount = tweet.precomposedStringWithCanonicalMapping.unicodeScalars.count // 46

/// 初始化 编码单元
let utf8Bytes = Data(tweet.utf8)
utf8Bytes.count // 62

/// 尾部包含null
let nullTerminatedUTF8 = tweet.utf8CString
nullTerminatedUTF8.count // 63
    
    
    
    
    
    
    
    

//UTF-16 Representation
/// 以UTF-16 代码单元集合  访问字符串的 Unicode表示形式
for codeUnit in dogString.utf16 {
    print("\(codeUnit) ", terminator: "")
}/// Prints "68 111 103 8252 55357 56374 "

/// String.UTF16View 视图是遵守 RandomAccessCollection 的 (虽然为此你需要引入 Foundation)。
///只有这一个视图类型曾经可以随机访问，这是因为 String 在内部的内存表示中，使用的是 UTF-16 或者 ASCII 码”


let str = "hello"
let randomAccessStr = Array(str.utf16) /// 牺牲unicode正确性
randomAccessStr[0]

let new = Unicode.Scalar(104)
print(new!)

    
    
    
    
    
    

//Unicode Scalar Representation
///一个编码点(Character)占用一个编码单元
///21位的 Unicode 标量值集合 也就是字符串的 UTF-32 编码格式的封装
///unicodeScalars属性来访问它的 Unicode 标量表示。 其为UnicodeScalarView类型的属性，UnicodeScalarView是UnicodeScalar类型的值的集合
for scalar in dogString.unicodeScalars {
    print("\(scalar.value) ", terminator: "")
}/// Prints "68 111 103 8252 128054 "

flags.unicodeScalars.map{ /// 观察unicode组成的标量 使用字符串的 unicodeScalars 视图
    "U+\(String($0.value, radix: 16, uppercase: true))"
} /// 标量值格式化为编码点常用的十六进制格式  ["U+1F1E7", "U+1F1F7", "U+1F1F3", "U+1F1FF"]





///作为查询它们的value属性的一种替代方法，每个UnicodeScalar值也可以用来构建一个新的String值
for scalar in dogString.unicodeScalars {
    print("\(scalar) ")
}
/// D
/// o
/// g
/// ‼
/// 🐶

    
    
    

let str = "hello"
str.decomposedStringWithCanonicalMapping     /// 这个字符串的内容是使用Unicode范式D标准化获取的
str.decomposedStringWithCompatibilityMapping /// 这个字符串的内容是使用Unicode范式KD标准化获取的
str.precomposedStringWithCanonicalMapping    /// C 标准
str.precomposedStringWithCompatibilityMapping ///KC 标准
/**
 如果需要一种单一的单一的表示方式，可以使用一种规范化的Unicode文本形式来减少不想要区别。
 Unicode标准定义了四种规范化形式：
 Normalization Form D (NFD)，
 Normalization Form KD (NFKD)，
 Normalization Form C (NFC)，
 Normalization Form KC (NFKC)。
 大约来说，NFD和NFKD将可能的字符进行分解，而NFC和NFKC将可能的字符进行组合。
 */


// 字符串和编码视图共享索引

/// 只要是你从上往下进行，也就是在从字符到标量，再到 UTF-16 或 UTF-8 编码单元这个方向上的话，这么做不会有什么问题 反过来不行
let family = "👨‍👩‍👧‍👦"
/// This initializer creates an index at a UTF-16 offset
let someUTF16Index = String.Index(encodedOffset: 2)
///family[someUTF16Index] // 崩溃，无效的索引”
    
  
/// 字符串和编码视图共享索引
let pokemon = "Poke\u{301}mon" // Pokémon
if let index = pokemon.index(of: "é") {
    let scalar = pokemon.unicodeScalars[index] // e
    String(scalar) // e
}

/// 在不同的视图中进行索引转换
let cafe = "Café 🍵"
if let i = cafe.unicodeScalars.index(of: "🍵"){
    let j = i.samePosition(in: cafe)!
    print(cafe[j...])
}

/// 寻找 Character 边界起始位置
let family = "👨‍👩‍👧‍👦"
extension String.Index {
    func samePositionOnCharacterBoundary(in str: String) -> String.Index {
        let range = str.rangeOfComposedCharacterSequence(at: self)
        return range.lowerBound
    }
}

let noCharacterBoundary = family.utf16.index(family.utf16.startIndex,offsetBy: 3)
let validIndex = noCharacterBoundary.samePositionOnCharacterBoundary(in: family)
// 正确
family[validIndex] // 👨‍👩‍👧‍👦”

let str = "hello"
let index = str.index(after: str.startIndex)
let newindex = index.samePositionOnCharacterBoundary(in: str)
str[newindex]



/*************** ExpressibleByStringLiteral  *************/
///通过实现 ExpressibleByStringLiteral 来让你自己的类型也可以通过字符串字面量进行初始化
///隶属于 ExpressibleByStringLiteral、ExpressibleByExtendedGraphemeClusterLiteral 和 ExpressibleByUnicodeScalarLiteral 这三个层次结构的协议
///这三个协议都定义了支持各自字面量类型的 init 方法，你必须对这三个都进行实现。不过除非你真的需要区分是从一个 Unicode 标量还是从一个字位簇来创建实例这样细粒度的逻辑，否则只需要实现字符串版本就行了
///字面量是指一段能表示特定类型的值（如数值、布尔值、字符串）的源码表达式（it is the source code representation of a fixed value）
///字面量类型就是支持通过字面量进行实例初始化的数据类型
///在Swift中，其的字面量类型有：
///所有的数值类型: Int、Double、Float以及其的相关类型（如UInt、Int16、Int32等）
///布尔值类型：Bool
///字符串类型：String
///组合类型：Array、Dictionary、Set
///空类型：Nil
let num: Int = 10
let flag: Bool = true
let str: String = "hello"
/**Swift中的字面量协议主要有以下几个：
 ExpressibleByNilLiteral        // nil字面量协议
 ExpressibleByIntegerLiteral    // 整数字面量协议
 ExpressibleByFloatLiteral      // 浮点数字面量协议
 ExpressibleByBooleanLiteral    // 布尔值字面量协议
 ExpressibleByStringLiteral     // 字符串字面量协议 (依赖ExpressibleByUnicodeScalarLiteral ExpressibleByExtendedGraphemeClusterLiteral)
 ExpressibleByArrayLiteral      // 数组字面量协议
 ExpressibleByDictionaryLiteral // 字典字面量协议*/
struct Money {
    var value: Double
    init(value: Double) {
        self.value = value
    }
}
/// 实现CustomStringConvertible协议，提供description方法
extension Money: CustomStringConvertible {
    public var description: String {
        return "\(value)"
    }
}
/// 实现ExpressibleByIntegerLiteral字面量协议
extension Money: ExpressibleByIntegerLiteral {
    typealias IntegerLiteralType = Int
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value: Double(value))
    }
}
/// 实现ExpressibleByFloatLiteral字面量协议
extension Money: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value: value)
    }
}
/// 实现ExpressibleByStringLiteral字面量协议
extension Money: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        if let doubleValue = Double(value) {
            self.init(value: doubleValue)
        } else {
            self.init(value: 0)
        }
    }
    /// 实现ExpressibleByExtendedGraphemeClusterLiteral字面量协议
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        if let doubleValue = Double(value) {
            self.init(value: doubleValue)
        } else {
            self.init(value: 0)
        }
    }
    /// 实现ExpressibleByUnicodeScalarLiteral字面量协议
    public init(unicodeScalarLiteral value: StringLiteralType) {
        if let doubleValue = Double(value) {
            self.init(value: doubleValue)
        } else {
            self.init(value: 0)
        }
    }
}
/// 实现ExpressibleByBooleanLiteral字面量协议
extension Money: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: BooleanLiteralType) {
        let doubleValue: Double = value ? 1.0 : 0.0
        self.init(value: doubleValue)
    }
}
/// 通过整数字面量初始化
let intMoney: Money = 10
/// 通过浮点数字面量初始化
let floatMoney: Money = 10.1
/// 通过字符串字面量初始化
let strMoney: Money = "10.2"
/// 通过布尔值初始化
let boolMoney: Money = true


struct Book {
    public var id: Int
    public var name: String
    init(id: Int, name: String = "unnamed") {
        self.id = id
        self.name = name
    }
}
/// 实现CustomStringConvertible协议，提供description方法
extension Book: CustomStringConvertible {
    public var description: String {
        return "id:\(id)\nname:《\(name)》"
    }
}
/// 实现ExpressibleByDictionaryLiteral字面量协议
extension Book: ExpressibleByDictionaryLiteral {
    typealias Key = String
    typealias Value = Any
    public init(dictionaryLiteral elements: (Key, Value)...) {
        var dictionary = [Key: Value](minimumCapacity: elements.count)
        for (k, v) in elements {
            dictionary[k] = v
        }
        let id = (dictionary["id"] as? Int) ?? 0
        let name = (dictionary["name"] as? String) ?? "unnamed"
        self.init(id: id, name: name)
    }
}
/// 实现ExpressibleByArrayLiteral字面量协议
extension Book: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = Any
    public init(arrayLiteral elements: ArrayLiteralElement...) {
        var id: Int = 0
        if let eId = elements.first as? Int {
            id = eId
        }
        var name = "unnamed"
        if let eName = elements[1] as? String {
            name = eName
        }
        self.init(id: id, name: name)
    }
}
/// 实现ExpressibleByNilLiteral字面量协议
extension Book: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init()
    }
}
/// 通过字典字面量初始化
let dictBook: Book = ["id": 100, "name": "Love is Magic"]
print("\(dictBook)\n")  ///id:100 name:《Love is Magic》

/// 通过数组字面量初始化
let arrayBook: Book = [101, "World is word"]
print("\(arrayBook)\n") ///id:101 name:《World is word》

/// 通过nil字面量初始化
let nilBook: Book = nil
print("\(nilBook)\n")   ///id:0   name:《unnamed》

///enum目前支持的字面量协议是有限制的，其目前只支持以下几个字面量协议：
ExpressibleByIntegerLiteral
ExpressibleByFloatLiteral
ExpressibleByStringLiteral

struct StockType {
    var number: Int
}
/// 实现CustomStringConvertible协议，提供description方法
extension StockType: CustomStringConvertible {
    public var description: String {
        return "Stock Number:\(number)"
    }
}
/// 实现Equatable协议，提供==方法
extension StockType: Equatable {
    public static func ==(lhs: StockType, rhs: StockType) -> Bool {
        return lhs.number == rhs.number
    }
}
/// 实现ExpressibleByDictionaryLiteral字面量协议
extension StockType: ExpressibleByDictionaryLiteral {
    typealias Key = String
    typealias Value = Any
    public init(dictionaryLiteral elements: (Key, Value)...) {
        var dictionary = [Key: Value](minimumCapacity: elements.count)
        for (k, v) in elements {
            dictionary[k] = v
        }
        let number = (dictionary["number"] as? Int) ?? 0
        self.init(number: number)
    }
}
/// 实现ExpressibleByIntegerLiteral字面量协议
extension StockType: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(number: value)
    }
}
/**
 若StockType没有实现 ExpressibleByIntegerLiteral、ExpressibleByFloatLiteral、ExpressibleByStringLiteral中的一个，
 会报错误：error: raw type 'StockType' is not expressible by any literal*/
enum Stock: StockType {
    case apple = 1001
    case google = 1002
}
let appleStock = Stock.apple.rawValue
print("\(appleStock)")

/*** CustomStringConvertible,CustomDebugStringConvertible ****/
struct Point {
    let x: Int, y: Int
}
extension Point: CustomDebugStringConvertible {
    /// 使用 String(describing:) 对元素进行打印，
    /// 它将优先使用 CustomStringConvertible
    var debugDescription: String {
        return "--Point(x: \(x), y: \(y))"
    }
}
extension Point: CustomStringConvertible {
    /// 使用 String(reflecting:) 对元素进行打印，
    /// 它将优先使用 CustomDebugStringConvertible
    /// 当 CustomStringConvertible 不可用时，String(describing:) 将退回使用 CustomDebugStringConvertible。
    /// 所以你在调试时做了任何额外工作的话，请确保也实现了 CustomStringConvertible。如果你的 description 和 debugDescription 是一样的话，你可以随意实现一个就行。
    ///“就算使用的是 String(describing:)，Array 还是会为它的元素打印调试版本的描述。数组的描述永远不会呈现给用户
    var description: String {
        return "(\(x), \(y))"
    }
}
let p = Point(x: 21, y: 30)

print(String(reflecting: p))
///Creates a string with a detailed representation of the given value, suitable for debugging.
///Use this initializer to convert an instance of any type to its custom debugging representation.
debugPrint(p) /// 等同 String(reflecting: item) 默认打印调试信息
///如果遵循 CustomDebugStringConvertible 打印协议内容  否则将打印更多调试信息SwiftCommandLine.Point(x: 21, y: 30)
///Swift provides a default debugging textual representation for any type.
///That default representation is used by the String(reflecting:) initializer and the debugPrint(_:) function for types that don’t provide their own.
///To customize that representation, make your type conform to the CustomDebugStringConvertible protocol.
print(p)///输出的是 CustomStringConvertible
print(String(describing: p))
///如果没有实现 CustomDebugStringConvertible，String(reflecting:) 会退回使用 CustomStringConvertible。
///所以如果你的类型很简单，通常没必要实现 CustomDebugStringConvertible。不过如果你的自定义类型是一个容器，那么遵循 CustomDebugStringConvertible 以打印其所含元素的调试描述信息会更考究一些。
///按照自定义方式把实例转换为字符串
///Use this initializer to convert an instance of any type to its preferred representation as a String instance.
/// If the passed instance conforms to CustomStringConvertible,
///the String(describing:) initializer and the print(_:) function use the instance’s custom description property.

//文本输出流TextOutputStream
///在标准库中，String，Substring， Character 和 Unicode.Scalar 都满足 TextOutputStreamable
///标准库中的 print 和 dump 函数会把文本记录到标准输出中
///想要将 print 和 dump 的输出重新定向到一个字符串的时候会很有用
var s = ""
let numbers = [1,2,3,4]
let num = [0,0,1]
print(numbers, to: &s) ///to 输出目标
print(s)
/// print(<#T##items: Any...##Any#>, separator: <#T##String#>, terminator: <#T##String#>, to: &<#T##TextOutputStream#>)
print(numbers,num, separator: "-", terminator: "!!!\n")
///[1, 2, 3, 4]-[0, 0, 1]!!!

//标准库中的输出流
///public var _playgroundPrintHook: ((String) -> Void)?
var printCapture = ""
_playgroundPrintHook = { text in
    printCapture += text
}
print("This is supposed to only go to stdout")
print(printCapture)
///This is supposed to only go to stdout 不要依赖

//自定义输出流
///TextOutputStream 协议只有一个要求，就是一个接受字符串，并将它写到流中的 write 方法。比如，这个输出流将输入写到一个缓冲数组里
struct ArrayStream: TextOutputStream {
    var buffer: [String] = []
    mutating func write(_ string: String) {
        buffer.append(string)
    }
}
var stream = ArrayStream()
print("Hello", to: &stream)
print("World", to: &stream)
print(stream.buffer) /// ["", "Hello", "\n", "", "World", "\n"]

///接受流输入，并输出 UTF-8 编码的结果

extension Data: TextOutputStream {
    mutating public func write(_ string: String) {
        self.append(contentsOf: string.utf8)
    }
}
var utf8Data = Data()
var string = "café"
utf8Data.write(string) /// ()
print(utf8Data)        /// 5 bytes


///输出源可以多次调用 write
///输出流的源可以是实现了 TextOutputStreamable 协议的任意类型。这个协议需要 write(to:) 这个泛型方法，它可以接受满足 TextOutputStream 的任意类型作为输入，并将 self 写到这个输出流中。
struct SlowStreamer: TextOutputStreamable, ExpressibleByArrayLiteral {
    let contents: [String]
    init(arrayLiteral elements: String...) {
        contents = elements
    }
    func write<Target: TextOutputStream>(to target: inout Target) {
        for x in contents {
            target.write(x)
            target.write("\n")
            sleep(1)
            ///修改数组输出源多次调用write
        }
    }
}
let slow: SlowStreamer = [
    "You'll see that this gets",
    "written slowly line by line",
    "to the standard output",
    ]
print(slow)


struct StdErr: TextOutputStream {
    mutating func write(_ string: String) {
        guard !string.isEmpty else { return }
        /// 能够直接传递给 C 函数的字符串是
        /// const char* 的，参阅互用性一章获取更多信息！
        fputs(string, stderr)
    }
}
var standarderror = StdErr()
print("oops!", to: &standarderror)

///流还能够持有状态，或者对输出进行变形。除此之外，你也能够将多个流链接起来
///将所有指定的短语替换为给定的字符串
struct ReplacingStream: TextOutputStream, TextOutputStreamable {
    ///TextOutputStreamable: can write their value to instances of any type that conforms to the TextOutputStream
    let toReplace: DictionaryLiteral<String, String>
    private var output = ""
    init(replacing toReplace: DictionaryLiteral<String, String>) {
        self.toReplace = toReplace
    }
    mutating func write(_ string: String) {///print to  source
        let toWrite = toReplace.reduce(string) { partialResult, pair in
            partialResult.replacingOccurrences(of: pair.key, with: pair.value)  ///source.replace
        }
        print(toWrite, terminator: "", to: &output)
    }
    func write<Target: TextOutputStream>(to target: inout Target) {
        output.write(to: &target)
    }
}
var replacer = ReplacingStream(replacing: ["in the cloud": "on someone else's computer"])///可添加多个
let source = "People find it convenient to store their data in the cloud."
print(source, terminator: "", to: &replacer)
var output = ""
print(replacer, terminator: "", to: &output)
print(output)
/// People find it convenient to store their data on someone else's computer.”
/// Dictionary 有两个副作用：它会去掉重复的键，并且会将所有键重新排序。
/// 如果你想要使用像是 [key: value] 这样的字面量语法，而又不想引入 Dictionary 的这两个副作用的话，就可以使用 DictionaryLiteral。
/// DictionaryLiteral 是对于键值对数组 (比如 [(key, value)]) 的很好的替代，它不会引入字典的副作用，同时让调用者能够使用更加便捷的 [:] 语法

///NSString 替换方法 replacingOccurrences(of:with:)、replacingOccurrences(of:with:options:range:)和replacingCharacters(in:with:)
var name = "Hello,World"
let newName = name.replacingOccurrences(of: "World", with: "Swift")
print(newName)///Hello,Swift
name.replacingOccurrences(of: "World", with: "Objective-C", options: String.CompareOptions.caseInsensitive, range: name.startIndex..<name.endIndex)
///正则替换字符串 String.CompareOptions.regularExpression
let str = "[🍎]00000[🍇]00000[🍌]"
var tempStr = str;
var isContans = true
while isContans {
    if let range = tempStr.range(of: "\\[[^\\[^\\]]+\\]",options: NSString.CompareOptions.regularExpression,range: nil,locale: nil) {
        tempStr = tempStr.replacingCharacters(in: range, with: "🎰")
        print("替换中:\(tempStr)")
    }else{
        isContans = false;
    }
}
print("替换后:\(tempStr)")

