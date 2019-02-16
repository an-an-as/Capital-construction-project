/**
 有多少种解码方法
 'A' -> 1
 'B' -> 2
 ...
 'Z' -> 26
 
 12 可解码为
 "AB"（1 2）或者 "L"（12）
 
 226 -> 2 26   22 6
 */
extension String {
    var decodingWays: Int {
        guard count != 0 || first! == "0" else { return 0 }
        var temp = Array(repeating: 0, count: count.advanced(by: 1))
        temp[0] = 1
        temp[1] = 1
        var characters = Array(self)
        for index in 1..<count {
            temp[index + 1] = characters[index] == "0" ? 0 : temp[index]
            if characters[index - 1] == "1" || (characters[index - 1] == "2" && characters[index] <= "6") {
                temp[index + 1] += temp[index - 1]
            }
        }
        return temp[characters.count]
    }
}
/// 10213       [10 2 1 3], [10 21 3],  [10 2 13]
/// temp[0]
/// temp[1]  -> [1, 1, 0, 0, 0, 0]                                     .
/// index1   character[1] == 0      temp[1 + 1] = 0            ->  [1, 1, 0, 0, 0, 0]
///          character[1 - 1] == 1  temp[1 + 1] += temp[1 - 1] ->  [1, 1, 1, 0, 0, 0]
///                                                                       .
/// index2   character[2] != 0      temp[2 + 1] = temp[2]      ->  [1, 1, 1, 1, 0, 0]
///          character[2 - 1] == 0
///                                                                          .
/// index3   character[3] != 0      temp[4] = temp[3]          ->  [1, 1, 1, 1, 1, 0]
///          character[3 - 1] == 2  temp[4] += temp[3]         ->  [1, 1, 1, 1, 2, 0]
///                                                                             .
/// index4   character[4] !=0       temp[5] = temp[4]          ->  [1, 1, 1, 1, 1, 2]
///          character[4 - 1] == 1  temp[5] += temp[3]         ->  [1, 1, 1, 1, 2, 3]


/// 10  [1, 1, 0]  ->   character[1] == 0  temp[2] = 0        -> [1, 1, 0]
///                     character[0] == 1  temp[2] += temp[0] -> [1, 1, 1]   last 1

/// 11  [1, 1, 0]  ->   character[1] != 0  temp[2] = 1        ->  [1, 1, 1]
///                     character[0] == 1  temp[2] += temp[0] ->  [1, 1, 2]  last 2

/// 21  [1, 1, 0]  ->   character[1] != 0  temp[2] = 1        ->  [1, 1, 1]
///                     character[0] == 2  temp[2] += temp[0] ->  [1, 1, 2]  last 2
///                     character[1] <= 6

/// 31  [1, 1, 0]  ->   character[1] != 0  temp[2] = 1        ->  [1, 1, 1]  last 1
///
///
print("10213".decodingWays)
