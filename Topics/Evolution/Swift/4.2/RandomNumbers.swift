/**
 func randomElement() -> Self.Element?
 func shuffled() -> [Self.Element]
 
 protocol RandomNumberGenerator {
 mutating func next() -> UInt64
 }
 
 protocol CaseIterable {
 associatedtype AllCases : Collection where Self.AllCases.Element == Self
 public static var allCases: Self.AllCases { get }
 }
 */
_ = Int.random(in: 1...1000)
_ = UInt8.random(in: .min ... .max)
_ = Double.random(in: 0..<1)
_ = Bool.random()

func coinToss(count tossCount: Int) -> (heads: Int, tails: Int) {
    var tally = (heads: 0, tails: 0)
    for _ in 0..<tossCount {
        let isHeads = Bool.random()
        if isHeads {
            tally.heads += 1
        } else {
            tally.tails += 1
        }
    }
    return tally
}
let (heads, tails) = coinToss(count: 100)
print("100 coin tosses — heads: \(heads), tails: \(tails)")

let emotions = "😀😂😊😍🤪😎😩😭😡"
let randomEmotion = emotions.randomElement()!

let numbers = 1...10
let shuffled = numbers.shuffled()
var mutableNumbers = Array(numbers)
mutableNumbers.shuffle()

/// A dummy random number generator that just mimics `SystemRandomNumberGenerator`.
struct MyRandomNumberGenerator: RandomNumberGenerator {
    var base = SystemRandomNumberGenerator()
    mutating func next() -> UInt64 {
        return base.next()
    }
}
var customRNG = MyRandomNumberGenerator()
print(Int.random(in: 0...100, using: &customRNG))

enum Suit: String, CaseIterable {
    case diamonds = "♦"
    case clubs = "♣"
    case hearts = "♥"
    case spades = "♠"
    static func random<T: RandomNumberGenerator>(using generator: inout T) -> Suit {
        // Using CaseIterable for the implementation
        return allCases.randomElement(using: &generator)!
    }
    static func random() -> Suit {
        var rng = SystemRandomNumberGenerator()
        return Suit.random(using: &rng)
    }
}
let randomSuit = Suit.random()
_ = randomSuit.rawValue

enum Names: String, CaseIterable {
    case boyA = "jack"
    case boyB = "tom"
}
print( Names.allCases[1]) // boyB
_ = Names.allCases.randomElement()
