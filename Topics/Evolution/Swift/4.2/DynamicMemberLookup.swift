/**
 动态成员查找
 
 SE-0195引入了用于类型声明的@dynamicMemberLookup属性。
 
 @dynamicMemberLookup是一个可应用于类、结构、枚举或协议声明的新属性。
 @dynamic​Member​Lookup可以用任何属性样式的访问器 (使用点表示法) 调用-如果给定名称的属性不存在, 编译器不会发出错误。
 
 
 该特性的目标是促进Swift和动态语言(如Python)之间的互操作性。
 来自谷歌的TensorFlow团队开发了这个方案，他们实现了一个Python桥接，使得从Swift调用Python代码成为可能。
 佩德罗·何塞·佩雷拉·维埃托将其打包在一个名为PythonKit的SwiftPM包中。
 
 SE-0195不需要启用这种互操作性，但它使生成的Swift语法更好。
 值得注意的是，SE-0195只处理属性样式的成员查找(即没有参数的简单getter和setter)。
 一个补充的“动态可调用”的提议(SE-0216)为一个动态方法调用语法已经被接受，但没有成为Swift 4.2的标准。这将是Swift下一个版本的一部分。
 
 尽管Python一直是参与该提议的人的主要关注点，但是与其他动态语言(如Ruby或JavaScript)的互操作层也将能够利用它。
 
 它也不局限于这个用例。
 当前具有基于字符串的订阅样式API的任何类型都可以转换为动态成员查找样式。
 SE-0195展示了一个JSON类型的示例，在这个示例中，您可以使用点表示法深入到嵌套字典中。
 
 下面是Doug Gregor提供的另一个示例:一种环境类型，它允许您以属性方式访问流程的环境变量。注意mutations突变也会起作用。
 
 这是一个很大的功能，如果使用不当，它有可能从根本上改变Swift的使用方式。
 通过在看似“安全”的构造后面隐藏基于字符串的基本“不安全”访问，您可能会给代码的读者错误的印象，认为编译器已经检查过了。
 
 在您在自己的代码中采用此方法之前，请扪心自问一下环境。用户确实比环境(“用户”)更容易阅读，值得注意它的缺点。在大多数情况下，我认为答案应该是“不”。
 */

@dynamicMemberLookup
struct Uppercaser {
    subscript(dynamicMember input: String) -> String {
        return input.uppercased()
    }
}
print(Uppercaser().12345)   // 12345
print(Uppercaser().hello)   // "HELLO"
print(Uppercaser().käsesoße)// "KÄSESOSSE"

enum JSON {
    case number(Double)
    case string(String)
    case array([JSON])
    case dictionary([String: JSON])
}
extension JSON {
    var numberValue: Double? {
        guard case .number(let n) = self else { return nil }
        return n
    }
    var stringValue: String? {
        guard case .string(let s) = self else { return nil }
        return s
    }
    subscript(index: Int) -> JSON? {
        guard case .array(let arr) = self, arr.indices.contains(index) else { return nil }
        return arr[index]
    }
    subscript(key: String) -> JSON? {
        guard case .dictionary(let dict) = self else { return nil }
        return dict[key]
    }
}
// [
//   {
//       "name": {
//               "first": "…",
//               "last": "…"
//               }
//   },
//   {
//     …
//   }
// ]
//json[0]?["name"]?["first"]?.stringValue
