/// 单词转摩尔斯密码
extension Array where Element == String {
    var uniqueMorseRepresentations: [String] {
        let morseCode = [".-","-...","-.-.","-..",".","..-.","--.","....","..",".---","-.-",".-..","--","-.",
                         "---",".--.","--.-",".-.","...","-","..-","...-",".--","-..-","-.--","--.."]
        var morse = [String](repeating: "", count: 97)
        morse.append(contentsOf: morseCode)
        var wordsSet = Set<String>()
        forEach {
            var morseResult = ""
            for char in $0.unicodeScalars {
                morseResult += morse[Int(char.value)]
            }
            wordsSet.insert(morseResult)
        }
        return Array(wordsSet)
    }
}
"a".unicodeScalars.forEach {
    print($0.value)  // 97
}
enum DayOfTheWeek: Int {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
}
var classDays: Set<DayOfTheWeek> = [.monday, .wednesday, .friday]
print(classDays.update(with: .monday))
print(classDays.update(with: .saturday))
print(classDays)
// Prints "Optional(.monday)"
let result = ["gin", "zen", "gig", "msg"].uniqueMorseRepresentations
print(result)
