///概念: 正则表达式是对字符串操作的一种逻辑公式，用事先定义好的一些特定字符、及这些特定字符的组合，组成一个"规则字符串"，这个"规则字符串"用来表达对字符串的一种过滤逻辑
///作用: 数据验证 替换文本 从字符串中提取子字符串
//元字符
/**
 \              将下一个字符标记为一个特殊字符  'n' 匹配字符 "n"  '\n' 匹配一个换行符   序列 '\\' 匹配 "\" 而 "\(" 则匹配 "("
 ^              匹配输入字符串的开始位置   如果设置了 RegExp 对象的 Multiline 属性，^ 也匹配 '\n' 或 '\r' 之后的位置
 $              匹配输入字符串的结束位置   如果设置了 RegExp 对象的 Multiline 属性，^ 也匹配 '\n' 或 '\r' 之后的位置
 *              匹配前面的子表达式零次或多次。zo* 能匹配z  以及zoo    可以不匹配到   等价于{0,}。
 +              匹配前面的子表达式一次或多次。zo+ 能匹配zo 以及zoo    但不能匹配z   至少要匹配到o一次   等价于 {1,}。
 ?              匹配前面的子表达式零次或一次。例如，"do(es)?" 可以匹配 do 或 does   ? 等价于 {0,1}
                当该字符紧跟在任何一个其他限制符 (*, +, ?, {n}, {n,}, {n,m}) 后面时，匹配模式是非贪婪的
                非贪婪模式尽可能少的匹配所搜索的字符串
                默认的贪婪模式则尽可能多的匹配所搜索的字符串。例如，对于字符串 "oooo"，'o+?' 将匹配单个 "o"，而 'o+' 将匹配所有 'o'。
 {n}            指定匹配次数  o{2}  表示o要匹配两次才返回  Bob不能 food能
 {n,}           至少匹配n 次  o{2,} 不能匹配 Bob 中的o  能匹配 foooood   中的所有 o  o{1,}    等价于o+     o{0,} 则等价于o*
 {n,m}          最少匹配 n 次且最多匹配 m 次    o{1,3}  将匹配 fooooood 中的前三个 o  o{0,1}   等价于o?     请注意在逗号和两个数之间不能有空格  其中n <= m
 .              匹配除换行符（\n、\r）之外的任何单个字符。要匹配包括 '\n' 在内的任何字符，请使用像"(.|\n)"的模式
 (pattern)      匹配 pattern 并获取这一匹配。
 (?:pattern)    匹配 pattern 但不获取匹配结果
 (?=pattern)    正向肯定预查（look ahead positive assert），在任何匹配pattern的字符串开始处匹配查找字符串。这是一个非获取匹配，也就是说，该匹配不需要获取供以后使用
                例如，"Windows(?=95|98|NT|2000)"能匹配"Windows2000"中的"Windows"，但不能匹配"Windows3.1"中的"Windows"。
                预查不消耗字符，也就是说，在一个匹配发生后，在最后一次匹配之后立即开始下一次匹配的搜索，而不是从包含预查的字符之后开始。
 (?!pattern)    正向否定预查(negative assert)，在任何不匹配pattern的字符串开始处匹配查找字符串。
                例如"Windows(?!95|98|NT|2000)"能匹配"Windows3.1"中的"Windows"，但不能匹配"Windows2000"中的"Windows"
 (?<=pattern)   反向(look behind)肯定预查，与正向肯定预查类似，只是方向相反。
                例如，"(?<=95|98|NT|2000)Windows"能匹配"2000Windows"中的"Windows"，但不能匹配"3.1Windows"中的"Windows"。
 (?<!pattern)   反向否定预查，与正向否定预查类似，只是方向相反。
                例如"(?<!95|98|NT|2000)Windows"能匹配"3.1Windows"中的"Windows"，但不能匹配"2000Windows"中的"Windows"。
 x|y            匹配 x 或 y。例如，'z|food' 能匹配 "z" 或 "food"。'(z|f)ood' 则匹配 "zood" 或 "food"
 [xyz]          字符集合。匹配所包含的任意一个字符。例如， '[abc]' 可以匹配 "plain" 中的 'a'
 [^xyz]         负值字符集合。匹配未包含的任意字符。例如， '[^abc]' 可以匹配 "plain" 中的'p'、'l'、'i'、'n'。
 [a-z]          字符范围。匹配指定范围内的任意字符。例如，'[a-z]' 可以匹配 'a' 到 'z' 范围内的任意小写字母字符
 [^a-z]         负值字符范围。匹配任何不在指定范围内的任意字符。例如，'[^a-z]' 可以匹配任何不在 'a' 到 'z' 范围内的任意字符。
 \b             匹配一个单词边界，也就是指单词和空格间的位置。例如， 'er\b' 可以匹配"never" 中的 'er'，但不能匹配 "verb" 中的 'er'。
 \B             匹配非单词边界。'er\B' 能匹配 "verb" 中的 'er'，但不能匹配 "never" 中的 'er'。
 \cx            匹配由 x 指明的控制字符。例如， \cM 匹配一个 Control-M 或回车符。x 的值必须为 A-Z 或 a-z 之一。否则，将 c 视为一个原义的 'c' 字符。
 \d             匹配一个数字字符。等价于 [0-9]
 \D             匹配一个非数字字符。等价于 [^0-9]。
 \f             匹配一个换页符。等价于 \x0c 和 \cL
 \n             匹配一个换行符。等价于 \x0a 和 \cJ
 \r             匹配一个回车符。等价于 \x0d 和 \cM。
 \s             匹配任何空白字符，包括空格、制表符、换页符等等。等价于 [ \f\n\r\t\v]。
 \S             匹配任何非空白字符。等价于 [^ \f\n\r\t\v]。
 \t             匹配一个制表符。等价于 \x09 和 \cI。
 \v             匹配一个垂直制表符。等价于 \x0b 和 \cK。
 \w             匹配字母、数字、下划线。等价于'[A-Za-z0-9_]'。
 \W             匹配非字母、数字、下划线。等价于 '[^A-Za-z0-9_]'。
 \xn            匹配 n，其中 n 为十六进制转义值。十六进制转义值必须为确定的两个数字长。例如，'\x41' 匹配 "A"。'\x041' 则等价于 '\x04' & "1"。正则表达式中可以使用 ASCII 编码。
 \num           匹配 num，其中 num 是一个正整数。对所获取的匹配的引用。例如，'(.)\1' 匹配两个连续的相同字符。
 \n             标识一个八进制转义值或一个向后引用。如果 \n 之前至少 n 个获取的子表达式，则 n 为向后引用。否则，如果 n 为八进制数字 (0-7)，则 n 为一个八进制转义值。
 \nm            标识一个八进制转义值或一个向后引用。
                如果 \nm 之前至少有 nm 个获得子表达式，则 nm 为向后引用。如果 \nm 之前至少有 n 个获取，则 n 为一个后跟文字 m 的向后引用。
                如果前面的条件都不满足，若 n 和 m 均为八进制数字 (0-7)，则 \nm 将匹配八进制转义值 nm。
 \nml           如果 n 为八进制数字 (0-3)，且 m 和 l 均为八进制数字 (0-7)，则匹配八进制转义值 nml。
 \un            匹配 n，其中 n 是一个用四个十六进制数字表示的 Unicode 字符。例如， \u00A9 匹配版权符号 (?)
 
 
 *?          重复任意次，但尽可能少重复
 *+          重复1次或更多次，但尽可能少重复
 ??          重复0次或1次，但尽可能少重复
 {n,m}?      重复n到m次，但尽可能少重复
 {n,}?       重复n次以上，但尽可能少重复
 
 
 
 ^once         表示该模式只匹配那些以once开头的字符串
 ^bucket$      字符^和$同时使用时，表示精确匹配（字符串与模式一样）
 ^[a-z][0-9]$  匹配一个由一个小写字母和一位数字组成的字符串 比如"z2"
 ^[^0-9][0-9]$ 第一个字符不能是数字
 [^a-z]        除了小写字母以外的所有字符
 [^\\\/\^]     除了(\)(/)(^)之外的所有字符
 [^\"\']       除了双引号(")和单引号(')之外的所有字符
 
 ^[a-zA-Z_]$         所有的字母和下划线
 ^[[:alpha:]]{3}$    所有的3个字母的单词
 ^a$                 字母a
 ^a{4}$              aaaa
 ^a{2,4}$            aa,aaa或aaaa
 ^a{1,3}$            a,aa或aaa
 ^a{2,}$             包含多于两个a的字符串
 ^a{2,}              如：aardvark和aaab，但apple不行
 a{2,}               如：baad和aaa，但Nantucket不行
 \t{2}               两个制表符
 .{2}                所有的两个字符
 
 ^[a-zA-Z0-9_]{1,}$             // 所有包含一个以上的字母、数字或下划线的字符串
 ^[1-9][0-9]{0,}$               // 所有的正整数
 ^\-{0,1}[0-9]{1,}$             // 所有的整数
 ^[-]?[0-9]+\.?[0-9]+$          // 所有的浮点数
 ^\-?[0-9]{1,}\.?[0-9]{1,}$
 
 ^[a-zA-Z0-9_]+$      // 所有包含一个以上的字母、数字或下划线的字符串
 ^[1-9][0-9]*$        // 所有的正整数
 ^\-?[0-9]+$          // 所有的整数
 ^\-?[0-9]+\.?[0-9]*$ // 所有的浮点数
 
 
 /\b([a-z]+) \1\b/gi                        一个单词连续出现的位置。
 /(\w+):\/\/([^/:]+)(:\d*)?([^# ]*)/        将一个URL解析为协议、域、端口及相对路径。
 /^(?:Chapter|Section) [1-9][0-9]{0,1}$/    定位章节的位置。
 /[-a-z]/                                   a至z共26个字母再加一个-号。
 /ter\b/                                    可匹配chapter，而不能匹配terminal。
 /\Bapt/                                    可匹配chapter，而不能匹配aptitude。
 /Windows(?=95 |98 |NT )/                   可匹配Windows95或Windows98或WindowsNT，当找到一个匹配后，从Windows后面开始进行下一次的检索匹配。
 /^\s*$/                                    匹配空行。
 /\d{2}-\d{5}/                              验证由两位数字、一个连字符再加 5 位数字组成的 ID 号。
 /<\s*(\S+)(\s[^>]*)?>[\s\S]*<\s*\/\1\s*>/  匹配 HTML 标记 **/

private func check(str: String) {
    /// 使用正则表达式一定要加try语句
    do {
        /// - 1、创建规则
        let pattern = "[1-9][0-9]{4,14}"
        /// - 2、创建正则表达式对象
        let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        /// - 3、开始匹配
        let res = regex.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range:NSMakeRange(0, str.unicodeScalars.count))
        /// 输出结果
        for checkingRes in res {
            print((str as NSString).substring(with: checkingRes.range))
        }
    }
    catch {
        print(error)
    }
}
check(str: "-123--1234--12345---")

/**
 匹配字符串中的URLS
 - parameter str: 要匹配的字符串
 */
private func getUrl(str:String) {
    /// 创建一个正则表达式对象
    do {
        let dataDetector = try NSDataDetector(types: NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue))
        /// 匹配字符串，返回结果集
        let res = dataDetector.matches(in: str, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, str.unicodeScalars.count))
        /// 取出结果
        for checkingRes in res {
            print((str as NSString).substring(with: checkingRes.range))
        }
    }
    catch {
        print(error)
    }
}
getUrl(str: "baidu: https://www.baidu.com")/// http//:www.baidu.com
getUrl(str: "百度www.baidu.com")            /// www.baidu.com

struct MyRegex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input,options: [],range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        }
        else {
            return false
        }
    }
}
infix operator =~
func =~ (lhs: String, rhs: String) -> Bool {
    return MyRegex(rhs).match(input: lhs)
}
if "admin@hangge.com" =~ "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"{
    print("邮箱地址格式正确")
}else{
    print("邮箱地址格式有误")
}

//用户名验证（允许使用小写字母、数字、下滑线、横杠，一共3~16个字符）
^[a-z0-9_-]{3,16}$

//Email验证
^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$

//手机号码验证
^1[0-9]{10}$

//URL验证
^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$

//IP地址验证
^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$

//html标签验证
^<([a-z]+)([^<]+)*(?:>(.*)<\/\1>|\s+\/>)$


//相关API
/// 匹配字符串中所有的符合规则的字符串, 返回匹配到的NSTextCheckingResult数组
public func matchesInString(string: String, options: NSRegularExpression.MatchingOptions, range: NSRange) -> [NSTextCheckingResult]

/// 按照规则匹配字符串, 返回匹配到的个数
public func numberOfMatchesInString(string: String, options: NSRegularExpression.MatchingOptions, range: NSRange) -> Int

/// 按照规则匹配字符串, 返回第一个匹配到的字符串的NSTextCheckingResult
public func firstMatchInString(string: String, options: NSRegularExpression.MatchingOptions, range: NSRange) -> NSTextCheckingResult?

/// 按照规则匹配字符串, 返回第一个匹配到的字符串的范围
public func rangeOfFirstMatchInString(string: String, options: NSRegularExpression.MatchingOptions, range: NSRange) -> NSRange


public class NSDataDetector : NSRegularExpression {
    /// all instance variables are private
    /** NSDataDetector is a specialized subclass of NSRegularExpression.  Instead of finding matches to regular expression patterns, it matches items identified by Data Detectors, such as dates, addresses, and URLs.  The checkingTypes argument should contain one or more of the types NSTextCheckingTypeDate, NSTextCheckingTypeAddress, NSTextCheckingTypeLink, NSTextCheckingTypePhoneNumber, and NSTextCheckingTypeTransitInformation.  The NSTextCheckingResult instances returned will be of the appropriate types from that list.*/
    public init(types checkingTypes: NSTextCheckingTypes) throws
    public var checkingTypes: NSTextCheckingTypes { get }
}

/// 这个是类型选择
public static var Date: NSTextCheckingType { get }       /// date/time detection
public static var Address: NSTextCheckingType { get }    /// address detection
public static var Link: NSTextCheckingType { get }       /// link detection
