//For-In Loops
let names = ["Anna", "Alex", "Brian", "Jack"]
for name in names {
    print("Hello, \(name)!")
}
/// Hello, Anna!
/// Hello, Alex!
/// Hello, Brian!
/// Hello, Jack!
for index in 1...5 {
    print("\(index) times 5 is \(index * 5)")
}
/// 1 times 5 is 5
/// 2 times 5 is 10
/// 3 times 5 is 15
/// 4 times 5 is 20
/// 5 times 5 is 25

///不需要区间序列内每一项的值，你可以使用下划线（_）替代变量名来忽略这个值
let base = 3
let power = 10
var answer = 1
for _ in 1...power {
    answer *= base
}
print("\(base) to the power of \(power) is \(answer)")
/// Prints "3 to the power of 10 is 59049"

let numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
for (animalName, legCount) in numberOfLegs {
    print("\(animalName)s have \(legCount) legs")
}
/// ants have 6 legs
/// cats have 4 legs
/// spiders have 8 legs

//while
var index = 10
while index < 20 {
    print( "index 的值为 \(index)")
    index = index + 1
}
//repeat-while
///区别是在判断循环条件之前，先执行一次循环的代码块。然后重复循环直到条件为false
var index = 15
repeat{
    print( "index 的值为 \(index)")
    index = index + 1
}while index < 20

//if
var temperatureInFahrenheit = 30
if temperatureInFahrenheit <= 32 {
    print("It's very cold. Consider wearing a scarf.")
}/// 输出 "It's very cold. Consider wearing a scarf."
///if语句允许二选一执行，叫做else从句。也就是当条件为false时，执行 else 语句
temperatureInFahrenheit = 40
if temperatureInFahrenheit <= 32 {
    print("It's very cold. Consider wearing a scarf.")
} else {
    print("It's not that cold. Wear a t-shirt.")
}/// 输出 "It's not that cold. Wear a t-shirt."
///多个if语句链接在一起，实现更多分支
temperatureInFahrenheit = 90
if temperatureInFahrenheit <= 32 {
    print("It's very cold. Consider wearing a scarf.")
} else if temperatureInFahrenheit >= 86 {
    print("It's really warm. Don't forget to wear sunscreen.")
} else {
    print("It's not that cold. Wear a t-shirt.")
}/// 输出 "It's really warm. Don't forget to wear sunscreen."


/*************** switch ****************/
///switch语句会尝试把某个值与若干个模式（pattern）进行匹配。根据第一个匹配成功的模式，switch语句会执行对应的代码。当有可能的情况较多时，通常用switch语句替换if语句
///每一个 case 都是代码执行的一条分支。switch语句会决定哪一条分支应该被执行，这个流程被称作根据给定的值切换(switching)。
///在某些不可能涵盖所有值的情况下，你可以使用默认（default）分支来涵盖其它所有没有对应的值，这个默认分支必须在switch语句的最后面。
let someCharacter: Character = "z"
switch someCharacter {
case "a":
    print("The first letter of the alphabet")
case "z":
    print("The last letter of the alphabet")
default:
    print("Some other character")
}
/// 输出 "The last letter of the alphabet"

//No Implicit Fallthrough
///在 Swift 中，当匹配的 case 分支中的代码执行完毕后，程序会终止switch语句，而不会继续执行下一个 case 分支。这也就是说，不需要在 case 分支中显式地使用break语句
///虽然在Swift中break不是必须的，但你依然可以在 case 分支中的代码执行完毕前使用break跳出
let anotherCharacter: Character = "a"
switch anotherCharacter {
case "a": /// 无效，这个分支下面没有语句
case "A":
    print("The letter A")
default:
    print("Not the letter A")
}
/// 这段代码会报编译错误
///为了让单个case同时匹配a和A，可以将这个两个值组合成一个复合匹配，并且用逗号分开
let anotherCharacter: Character = "a"
switch anotherCharacter {
case "a", "A":
    print("The letter A")
default:
    print("Not the letter A")
}/// 输出 "The letter A

//Interval Matching 区间匹配
let approximateCount = 62
let countedThings = "moons orbiting Saturn"
var naturalCount: String
switch approximateCount {
case 0:
    naturalCount = "no"
case 1..<5:
    naturalCount = "a few"
case 5..<12:
    naturalCount = "several"
case 12..<100:
    naturalCount = "dozens of"
case 100..<1000:
    naturalCount = "hundreds of"
default:
    naturalCount = "many"
}
print("There are \(naturalCount) \(countedThings).")
/// 输出 "There are dozens of moons orbiting Saturn."

//Tuples
///使用下划线（_）来匹配所有可能的值。
let somePoint = (1, 1)
switch somePoint {
case (0, 0):
    print("\(somePoint) is at the origin")
case (_, 0):
    print("\(somePoint) is on the x-axis")
case (0, _):
    print("\(somePoint) is on the y-axis")
case (-2...2, -2...2):
    print("\(somePoint) is inside the box")
default:
    print("\(somePoint) is outside of the box")
}
/// Prints "(1, 1) is inside the box"

//Value Bindings
///case 分支允许将匹配的值绑定到一个临时的常量或变量，并且在case分支体内使用 —— 这种行为被称为值绑定（value binding），因为匹配的值在case分支体内，与临时的常量或变量绑定
let anotherPoint = (2, 0)
switch anotherPoint {
case (let x, 0):
    print("on the x-axis with an x value of \(x)")
case (0, let y):
    print("on the y-axis with a y value of \(y)")
case let (x, y):
    print("somewhere else at (\(x), \(y))")
}
/// 输出 "on the x-axis with an x value of 2"

//where
///case 分支的模式可以使用where语句来判断额外的条件
let yetAnotherPoint = (1, -1)
switch yetAnotherPoint {
case let (x, y) where x == y:
    print("(\(x), \(y)) is on the line x == y")
case let (x, y) where x == -y:
    print("(\(x), \(y)) is on the line x == -y")
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
}
/// 输出 "(1, -1) is on the line x == -y"


//Compound Cases
///当多个条件可以使用同一种方法来处理时，可以将这几种可能放在同一个case后面，并且用逗号隔开。当case后面的任意一种模式匹配的时候，这条分支就会被匹配。并且，如果匹配列表过长，还可以分行书写
let someCharacter: Character = "e"
switch someCharacter {
case "a", "e", "i", "o", "u":
    print("\(someCharacter) is a vowel")
case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
     "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
    print("\(someCharacter) is a consonant")
default:
    print("\(someCharacter) is not a vowel or a consonant")
}
/// 输出 "e is a vowel"
let stillAnotherPoint = (9, 0)
switch stillAnotherPoint {
case (let distance, 0), (0, let distance):
    print("On an axis, \(distance) from the origin")
default:
    print("Not on an axis")
}

/// 输出 "On an axis, 9 from the origin"

/**** Control Transfer Statements ****/
///Swift 有五种控制转移语句
//continue
///continue语句告诉一个循环体立刻停止本次循环，重新开始下次循环。就好像在说“本次循环我已经执行完了”，但是并不会离开整个循环体。
let puzzleInput = "great minds think alike"
var puzzleOutput = ""
let charactersToRemove: [Character] = ["a", "e", "i", "o", "u", " "]
for character in puzzleInput {
    if charactersToRemove.contains(character) {
        continue
    } else {
        puzzleOutput.append(character)
    }
}
print(puzzleOutput)
/// Prints "grtmndsthnklk"


//break
///break语句会立刻结束整个控制流的执行
///当在一个循环体中使用break时，会立刻中断该循环体的执行，然后跳转到表示循环体结束的大括号(})后的第一行代码。不会再有本次循环的代码被执行，也不会再有下次的循环产生。
///当在一个switch代码块中使用break时，会立即中断该switch代码块的执行，并且跳转到表示switch代码块结束的大括号(})后的第一行代码。
///有时为了使你的意图更明显，需要特意匹配或者忽略某个分支。那么当你想忽略某个分支时，可以在该分支内写上break语句。当那个分支被匹配到时，分支内的break语句立即结束switch代码块。
let numberSymbol: Character = "三"  // 简体中文里的数字 3
var possibleIntegerValue: Int?
switch numberSymbol {
case "1", "١", "一", "๑":
    possibleIntegerValue = 1
case "2", "٢", "二", "๒":
    possibleIntegerValue = 2
case "3", "٣", "三", "๓":
    possibleIntegerValue = 3
case "4", "٤", "四", "๔":
    possibleIntegerValue = 4
default:
    break
    ///一旦落入到default分支中后，break语句就完成了该分支的所有代码操作，代码继续向下，开始执行if let语句。
}
if let integerValue = possibleIntegerValue {
    print("The integer value of \(numberSymbol) is \(integerValue).")
} else {
    print("An integer value could not be found for \(numberSymbol).")
}
/// 输出 "The integer value of 三 is 3."

//fallthrough
///Swift 中的switch不会从上一个 case 分支落入到下一个 case 分支中。相反，只要第一个匹配到的 case 分支完成了它需要执行的语句，整个switch代码块完成了它的执行。可以避免无意识地执行多个 case 分支从而引发的错误。
///如果你确实需要 C 风格的贯穿的特性，你可以在每个需要该特性的 case 分支中使用fallthrough关键字。
///fallthrough关键字不会检查它下一个将会落入执行的 case 中的匹配条件。fallthrough简单地使代码继续连接到下一个 case 中的代码，
let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"
switch integerToDescribe {
case 2, 3, 5, 7, 11, 13, 17, 19:
    description += " a prime number, and also"
    fallthrough
default:
    description += " an integer."
}
print(description)
/// Prints "The number 5 is a prime number, and also an integer."


///Labeled Statements
///显式地指明break语句想要终止的是哪个循环体或者条件语句，会很有用。类似地，如果你有许多嵌套的循环体，显式指明continue语句想要影响哪一个循环体也会非常有用
let puzzleInput = "great minds think alike"
var puzzleOutput = ""
let charactersToRemove: [Character] = ["a", "e", "i", "o", "u", " "]
filterLoop: for character in puzzleInput {
    if charactersToRemove.contains(character) {
        continue filterLoop
    } else {
        puzzleOutput.append(character)
    }
}
print(puzzleOutput)


/*** Early Exit **/
///像if语句一样，guard的执行取决于一个表达式的布尔值。我们可以使用guard语句来要求条件必须为真时，以执行guard语句后的代码。不同于if语句，一个guard语句总是有一个else从句，如果条件不为真则执行else从句中的代码。
///如果guard语句的条件被满足，则继续执行guard语句大括号后的代码。将变量或者常量的可选绑定作为guard语句的条件，都可以保护guard语句后面的代码。
///如果条件不被满足，在else分支上的代码就会被执行。这个分支必须转移控制以退出guard语句出现的代码段。它可以用控制转移语句如return,break,continue或者throw做这件事，或者调用一个不返回的方法或函数，例如fatalError()。
///相比于可以实现同样功能的if语句，按需使用guard语句会提升我们代码的可读性。它可以使你的代码连贯的被执行而不需要将它包在else块中，它可以使你在紧邻条件判断的地方，处理违规的情况。
func greet(person: [String: String]) {
    guard let name = person["name"] else {
        return
    }
    
    print("Hello \(name)!")
    
    guard let location = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }
    
    print("I hope the weather is nice in \(location).")
}

greet(person: ["name": "John"])
/// Prints "Hello John!"
/// Prints "I hope the weather is nice near you."
greet(person: ["name": "Jane", "location": "Cupertino"])
/// Prints "Hello Jane!"
/// Prints "I hope the weather is nice in Cupertino."


/**Checking API Availability*/
///Swift内置支持检查 API 可用性，这可以确保我们不会在当前部署机器上，不小心地使用了不可用的API。
///编译器使用 SDK 中的可用信息来验证我们的代码中使用的所有 API 在项目指定的部署目标上是否可用。如果我们尝试使用一个不可用的 API，Swift 会在编译时报错
///以上可用性条件指定，在iOS中，if语句的代码块仅仅在 iOS 10 及更高的系统下运行；在 macOS中，仅在 macOS 10.12 及更高才会运行。最后一个参数，*，是必须的，用于指定在所有其它平台中，如果版本号高于你的设备指定的最低版本，if语句的代码块将会运行。
if #available(iOS 10, macOS 10.12, *) {
    /// Use iOS 10 APIs on iOS, and use macOS 10.12 APIs on macOS
} else {
    /// Fall back to earlier iOS and macOS APIs
}










