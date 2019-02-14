// 仅仅反转字母 其余原地保留
func reverseOnlyLetters(_ S: String) -> String {
    var characters = Array(S)
    var cursorL = 0
    var cursorR = characters.endIndex.advanced(by: -1)
    while cursorL < cursorR {
        if !((characters[cursorL] >= "A" && characters[cursorL] <= "Z") || (characters[cursorL] >= "a" && characters[cursorL] <= "z")) {
            cursorL += 1
        } else if !((characters[cursorR] >= "A" && characters[cursorR] <= "Z") || (characters[cursorR] >= "a" && characters[cursorR] <= "z")) {
            cursorR -= 1
        } else {
            (characters[cursorL], characters[cursorR]) = (characters[cursorR], characters[cursorL])
            cursorL += 1
            cursorR -= 1
        }
    }
    return String(characters)
}
let str = "ab-cd"
let result = reverseOnlyLetters(str)
print(result)
