/**
 Robert W．Floyd & J．Williams US/1964 O(nlogn)
 
 ## Complete Binary Tree
 + 堆是一种完全二叉树或者近似完全二叉树
 + 若设二叉树的深度为h，除第 h 层外，其它各层 (1～h-1) 的结点数都达到最大个数，第 h 层所有的结点都连续集中在最左边，这就是完全二叉树
 
 ## 相关性质
 + 在二叉树的第i层上至多有2^(i-1)（i >= 1）个节点。
 + 深度为k的二叉树至多有2^k-1（k>=1）个节点。
 * 由特性1易知每层最多有多少个节点，那么深度为k的话，说明一共有k层
 * 那么共有节点数为：2^0 + 2^1 + 2^2 + 2^(k-1) = 2^k - 1
 
 ## 堆是具有以下性质的完全二叉树：
 + 每个结点的值都大于或等于其左右孩子结点的值，称为大顶堆；
 + 每个结点的值都小于或等于其左右孩子结点的值，称为小顶堆。
 
 ## 基本思想及步骤
 + 将无序序列构建成一个堆，根据升序降序需求选择大顶堆或小顶堆;
 + 将堆顶元素与末尾元素交换，将最大元素"沉"到数组末端;
 + 重新调整结构，使其满足堆定义，然后继续交换堆顶元素与当前末尾元素，反复执行调整+交换步骤，直到整个序列有序
 
 
 ````
       4            0               arr [4,6,8,5,9]        for i in stride(from: (nodes.count/2-1), through: 0, by: -1){}  确定最后非叶子结点
     /   \         / \                   0 1 2 3 4         如果下标从1开始存储，则编号为i的结点的主要关系为： 父i/2         左2i  右2i+1
   >6<    8       1   2                                    如果下标从0开始存储，则编号为i的结点的主要关系为： (i - 1) / 2   2i+1  2i+2     [(i-1)-1/2] = i/2 -1
   / \           / \
  5   9         3   4                                      假设设完全二叉树中第i个结点的位置为第k层第M个结点，
                                                           根据二叉树的特性，满二叉树的第K层共有2^K-1个节点
                                                           则父节点为全二叉树的第t=2^(K-2)-1+M个节点。子节点为全二叉树的第i=2^(K-1)-1+2M。即父结点编号为t=(i-1)/2=i/2。
                                                           若 2层 父节点t =  m    子节点i = 1 + 2m
 ````
 
 
 ## 从最后一个非叶子结点开始,从下至上,从左至右,进行调整 9 - 6
 
 ````
 
      4                                   9                                       9
    /   \                                / \                                     / \
   9     8            ---->             4   8                 ---->             6   8
  / \                                  / \                                     / \
 5   6                                5   6                                   5   4
 arr [4,9,8,5,6]                      arr [9,4,8,5,6]                         arr[9,6,8,5,4]
 
 ````
 
 
 ## 将堆顶元素与末尾元素进行交换，使末尾元素最大
 
 ````
     4                                   8                               5
    / \                                 / \                             / \
   6   8             ----->            6   4             ---->         6   4
  /                  重新调整          /                  首位交换      [8][9]
 5  [9]                              5  [9]
 arr[4,6,8,5,|9]                     arr[8,6,4,5,|9]                 -> arr[4,5,6,8,9]
 
 ````
 */
import  Foundation
extension Array {
    public mutating func heapSortInplace(sort: @escaping (Element, Element) -> Bool) {
        func shiftDown(from index: Index, to endIndex: Index) {
            var currentIndex = index
            let childIndexL = index * 2 + 1
            let childIndexR = childIndexL + 1
            if childIndexL < endIndex && sort(self[currentIndex], self[childIndexL]) {
                currentIndex = childIndexL
            }
            if childIndexR < endIndex && sort(self[currentIndex], self[childIndexR]) {
                currentIndex = childIndexR
            }
            if currentIndex == index { return }
            self.swapAt(index, currentIndex)
            shiftDown(from: currentIndex, to: endIndex)
        }
        for strideIndex in stride(from: self.count/2 - 1, through: 0, by: -1) {
            shiftDown(from: strideIndex, to: self.count)
        }
        for strideIndex in stride(from: self.count - 1, through: 1, by: -1) {
            self.swapAt(0, strideIndex)
            shiftDown(from: 0, to: strideIndex)
        }
    }
    public func heapSort(sort: @escaping(Element, Element) -> Bool) -> [Element] {
        var clone = Array.init()
        clone.append(contentsOf: self)
        clone.heapSortInplace(sort: sort)
        return clone
    }
}
var nums = [Int]()
(1...10).forEach { _ in
    let num = Int(arc4random_uniform(1_000))
    nums.append(num)
}
print(nums.heapSort(sort: <))
