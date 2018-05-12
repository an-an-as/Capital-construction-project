/*Creating and Initializing an Empty Set*/
var letters = Set<Character>()


/*Creating a Set with an Array Literal*/
var favoriteGenres: Set<String> = ["Rock", "Classical", "Hip hop"]
var favoriteGenres: Set = ["Rock", "Classical", "Hip hop"]
//重复的会自动去重






/*Accessing and Modifying a Set*/
print("I have \(favoriteGenres.count) favorite music genres.")
if favoriteGenres.isEmpty {
    print("As far as music goes, I'm not picky.")
} else {
    print("I have particular music preferences.")
}
favoriteGenres.insert("Jazz")

if let removedGenre = favoriteGenres.remove("Rock") {
    print("\(removedGenre)? I'm over it.")
} else {
    print("I never much cared for that.")
}

if favoriteGenres.contains("Funk") {
    print("I get up on the good foot.")
} else {
    print("It's too funky in here.")
}


var num:Set = [1,2,3,4,5]
let index =  num.startIndex ?? num.endIndex
num[index]



/*Iterating Over a Set*/
for genre in favoriteGenres {
    print("\(genre)")
}
for genre in favoriteGenres.sorted() {
    print("\(genre)")
}






/*Performing Set Operations*/
//Fundamental Set Operations
let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]

oddDigits.union(evenDigits).sorted()
// [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

oddDigits.intersection(evenDigits).sorted()
// []

oddDigits.subtracting(singleDigitPrimeNumbers).sorted()
// [1, 9]

oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted()
// [1, 2, 9]








/*Set Membership and Equality*/
let houseAnimals: Set = ["🐶", "🐱"]
let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]


houseAnimals.isSubset(of: farmAnimals)
// true      isStrictSubset 判断是否为子集并且不相等
farmAnimals.isSuperset(of: houseAnimals)
// true      isStricSuperset 判断是否为父集并且不相等
farmAnimals.isDisjoint(with: cityAnimals)
// true 判断两个集合是否不含有相同的值





/* set与array的转换 */
// array转换成set
let array10:Array<String> = ["1","1","1","2"]
let set10:Set<String> = Set(array10)
// set转换成array
let set11:Set<String> = ["1","2","3","4"]
let array11 = Array(set11)





/* 索引集合 和 字符集合 */
// Set optionSet CharacterSet IndexSet  实现了SetAlgebra
var indices = IndexSet()
indices.insert(integersIn: 1..<5)
indices.insert(integersIn: 11..<15)
let evenIndices = indices.filter { $0 % 2 == 0 } // [2, 4, 12, 14]”





/*Action*/
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var result: Set<Iterator.Element> = []
        
        return filter {
            if result.contains($0) {
                return false
            }
            else {
                result.insert($0)
                return true
            }
        }
    }
}
[1,2,3,12,1,3,4,5,6,4,6].unique() // [1, 2, 3, 12, 4, 5, 6]


var arr = [1,1,1,2]
let new = Set(arr) // 1,2



















