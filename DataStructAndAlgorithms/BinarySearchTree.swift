import Foundation

class BinaryThreadTreeNote {
    var data: String
    
    var leftChild: BinaryThreadTreeNote!
    var rightChild: BinaryThreadTreeNote!
    
    var leftTag: Bool = true
    var rightTag: Bool = true
    
    init(data: String) {
        self.data = data
    }
}

class BinaryThreadTree {
    fileprivate var items: Array<String>
    fileprivate var index = -1
    
    var rootNote: BinaryThreadTreeNote!
    fileprivate var preNote: BinaryThreadTreeNote?
    fileprivate var headNote: BinaryThreadTreeNote?
    
    init(items: Array<String>) {
        self.items = items
        self.rootNote = self.createTree()
        
        self.headNote = BinaryThreadTreeNote(data: "")
        self.headNote?.leftChild = self.rootNote
        self.headNote?.leftTag = true
        
        self.preNote = headNote
    }
    
    fileprivate func createTree() -> BinaryThreadTreeNote! {
        self.index = self.index + 1     
        if index < self.items.count && index >= 0 {
            let item = self.items[index]
            
            if item == "" {
                return nil
            }else {
                let note = BinaryThreadTreeNote(data: item)
                note.leftChild = createTree()
                note.rightChild = createTree()
                return note
            }
        }
        return nil
    }
    
   
    func preOrderTraverse() {
        self.preOrderTraverse(rootNote)
    }
    
    fileprivate func preOrderTraverse (_ note: BinaryThreadTreeNote!) {
        guard let note = note else {
            return
        }
        print(note.data, separator: "", terminator: " ")
        if note.leftTag {
            preOrderTraverse(note.leftChild)
        }
        if note.rightTag {
            preOrderTraverse(note.rightChild)
        }
    }
    
    func inThread() {
        self.inThreading(note: self.rootNote)
    }
    
    private func inThreading(note: BinaryThreadTreeNote?) {
        if note != nil {
            inThreading(note: note?.leftChild)
            if note?.leftChild == nil {
                note?.leftTag = false
                note?.leftChild = preNote
            }
          
            if preNote?.rightChild == nil {
                preNote?.rightTag = false
                preNote?.rightChild = note
            }
            
            preNote = note
            inThreading(note: note?.rightChild)
        }
    }
    
    func displayThreadTree() {
 
        var cursor = self.headNote?.rightChild
        while cursor != nil {
            print((cursor?.data)!, separator: "", terminator: " -> ")
            cursor = cursor?.rightChild
        }
        print("end\n")
    }
    
}

let items:Array<String> = ["A","B","D","","","E","","","C"]
let binaryTree:BinaryThreadTree = BinaryThreadTree(items: items)
binaryTree.preOrderTraverse()
binaryTree.inThread()
binaryTree.displayThreadTree()
