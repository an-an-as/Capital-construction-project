let dictOfFunctions: [String: (Int, Int) -> Int] = ["add": (+), "subtract": (-)]
dictOfFunctions["add"]?(1, 1) /// Optional(2)

let one: Int?? = .some(nil)
let two: Int? = 2
let three: Int? = 3
one ?? two ?? three         // nil
(one ?? two) ?? three       // 3
