// 在指定最大范围内是否存在重复元素
///  [1, 2, 3, 1]  k = 3  TRUE
extension Array where Element: Hashable {
    func containsNearbyDuplicate(range: Int) -> Bool {
        var set = Set<Element>()
        for index in indices {
            if index > range {
                set.remove( self[index - range - 1] )
            }
            if !set.insert(self[index]).inserted {
                return true
            }
        }
        return false
    }
}
let result = [1, 2, 3, 1, 3].containsNearbyDuplicate(range: 2)
print(result)
/// Set [1, 2, 3] index3 > offset2 超出范围  删除无效数据1  Set[2, 3, 1] -> Set[3, 1, 3]
