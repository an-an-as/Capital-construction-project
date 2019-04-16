/// 对字典进行URL编码
func query(_ parameters: [String: AnyObject]) -> String {
    var components: [(String, String)] = []
    //遍历出字典中所有的keyValue
    for key in parameters.keys.sorted(by: <) {
        let value = parameters[key]!
    //递归转义
        components += queryComponents(key, value)
    }
    //转换成Query格式 key=value & key=value
    return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
}
func queryComponents(_ key: String, _ value: AnyObject) -> [(String, String)] {
    var components: [(String, String)] = []
     //value为字典的情况, 递归调用检查字典中是否有数组
    if let dictionary = value as? [String: AnyObject] {
        for (nestedKey, value) in dictionary {
            components += queryComponents("\(key)[\(nestedKey)]", value) /// 叠加每一层 key[“subkey”][“subkey”]
        }
    //value为数组的情况, 递归调用检查数组中是否有字典
    } else if let array = value as? [AnyObject] {
        for value in array {
            components += queryComponents("\(key)[]", value)
        }
    } else {
    //vlalue为字符串的情况进行转义，上面两种情况最终会递归到此情况而结束
        components.append((escape(key), escape("\(value)")))
    }
    return components
}
/// 选定字符集进行URL编码 如果我的参数值中就包含=或&这种特殊字符的时候需要通过编码消除歧义防止错误分割
/// 比如说“name1=value1”,其中value1的值是“va&lu=e1”字符串，那么实际在传输过程中就会变成这样“name1=va&lu=e1”
/// URL编码只是简单的在特殊字符的各个字节前加上%进行转义，
/// 例如，我们对上述会产生奇异的字符进行URL编码后结果：“name1=va%26lu%3D”，
/// 这样服务端会把紧跟在“%”后的字节当成普通的字节，就是不会把它当成各个参数或键值对的分隔符。
func escape(_ string: String) -> String {
    // RFC3986中指定了以下字符为保留字符：! * ' ( ) ; : @ & = + $ , / ? # [ ]。
    let generalDelimitersToEncode = ":#[]@"
    let subDelimitersToEncode = "!$&'()*+,;="
    var allowedCharacterSet = CharacterSet.urlQueryAllowed
    allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
    var escaped = ""
    if #available(iOS 8.3, *) {
        escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    } else {
        let batchSize = 50
        var index = string.startIndex
        while index != string.endIndex {
            let startIndex = index
            let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
            let range = startIndex..<endIndex
            let substring = string.substring(with: range)
            escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring
            index = endIndex
        }
    }
    return escaped
}
print(query(["字母和数字": ["a": 1, "b": 3, "数字": [1, 2, 3]] as AnyObject]))
// 字母和数字[a]=1 & 字母和数字[数字][]=1 & 字母和数字[数字][]=2 & 字母和数字[数字][]=3 & 字母和数字[b]=3
// 服务端在接收到该数据后就可以遍历该字节流，首先一个字节一个字节的读取
