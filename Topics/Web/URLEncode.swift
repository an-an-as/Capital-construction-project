/**
 Query
 key = [itme1, item2, item3,……]
 -> key[] = item1& key[itme2]& key[item3] ……
 
 key = ["subKey1":"item1", "subKey2":"item2"]
 -> key[subKey1] = item1 & key[subKey2] = item2
 */
import Foundation
func query(_ parameters: [String: AnyObject]) -> String {
    var components: [(String, String)] = []
    for key in parameters.keys.sorted(by: <) {
        let value = parameters[key]!
        components += queryComponents(key, value)
    }
    return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
}
func queryComponents(_ key: String, _ value: AnyObject) -> [(String, String)] {
    var components: [(String, String)] = []
    if let dictionary = value as? [String: AnyObject] {
        for (nestedKey, value) in dictionary {
            components += queryComponents("\(key)[\(nestedKey)]", value)
        }
    }
    else if let array = value as? [AnyObject] {
        for value in array {
            components += queryComponents("\(key)[]", value)
        }
    }
    else {
        components.append((escape(key), escape("\(value)")))
    }
    return components
}
func escape(_ string: String) -> String {
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
func showLog(_ info: AnyObject) {
    let log = "\(info)"
    print(log)
    let semaphore: DispatchSemaphore = DispatchSemaphore(value: 1)
    DispatchQueue.main.async {
        semaphore.wait()
        let logs = ""
        let newlogs = String((logs + "\n"+log)).replacingOccurrences(of: "\\n", with: "\n")
        print(newlogs)
        semaphore.signal()
    }
}
let parameters = ["post": "value01",
                  "arr": ["item1", "item2"],
                  "dic":["key1":"value1", "key2":"value2"]] as [String : Any]
showLog(query(parameters as [String : AnyObject]) as AnyObject)
