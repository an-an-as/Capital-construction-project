import Foundation
///将字典转换成URL编码的字符
func query(_ parameters: [String: AnyObject]) -> String {
    var components: [(String, String)] = []
    for key in parameters.keys.sorted(by: <) {
        let value = parameters[key]!
        components += queryComponents(key, value)
    }
    return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
}
///递归value中的数组字典
func queryComponents(_ key: String, _ value: AnyObject) -> [(String, String)] {
    var components: [(String, String)] = []
    if let dictionary = value as? [String: AnyObject] {
        for (nestedKey, value) in dictionary {
            components += queryComponents("\(key)[\(nestedKey)]", value)
        }
    } else if let array = value as? [AnyObject] {
        for value in array {
            components += queryComponents("\(key)[]", value)
        }
    } else {
        components.append((escape(key), escape("\(value)")))
    }
    return components
}
///转义编码
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
enum RequestMethod: String {
    case get = "GET"
    case post = "SET"
}

func sessionDataTaskRequest(_ method: RequestMethod, parameters:[String: AnyObject]){
    var hostString = "http://jsonplaceholder.typicode.com/posts"
    let escapeQueryString = hostString + "?" + query(parameters)
    var url = URL(string: hostString)!
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    switch method {
    case .get:  url.appendPathComponent(escapeQueryString)
    case .post: request.httpBody = escapeQueryString.data(using: String.Encoding.utf8)
    }
    let session = URLSession.shared
    //URLSession没有直接同步请求的方法。想使用NSURLSession进行同步请求，即数据获取后才继续执行后面代码
    let semaphore = DispatchSemaphore(value: 0)
    let sessionTask = session.dataTask(with: request) { data, response, error in
        guard error == nil && data != nil else { return }
        let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
        semaphore.signal()
        print(json)
    }
    sessionTask.resume()
    let dispatchTimeoutResult = semaphore.wait(timeout: DispatchTime.distantFuture)
    print(dispatchTimeoutResult)
}
let dict = ["userId": 1]
sessionDataTaskRequest(.get, parameters: dict as! [String : AnyObject])
