 // 如果在电子邮件地址的本地名称部分中的某些字符之间添加句点（'.'， 则发往那里的邮件将会转发到本地名称中没有点的同一地址
 // "alice.z@leetcode.com” 和 “alicez@leetcode.com” 会转发到同一电子邮件地址
 // 如果在本地名称中添加加号（'+'），则会忽略第一个加号后面的所有内容
 // 例如 m.y + name@email.com 将转发到 my@email.com。
 import Foundation
 extension Array where Element == String {
    var uniqueEmails: [Element] {
        var emailSet = Set<String>()
        forEach {
            let address = $0.split(separator: "@")
            let result = address[0].split(separator: "+").first!.filter { $0 != "." }
            emailSet.insert(result + address.last!)
        }
        return Array(emailSet)
    }
}
var emails = [String]()
emails.append("12345@qq.com")
emails.append("12+345@qq.com")
emails.append("12.345@qq.com")
print(emails.uniqueEmails)
