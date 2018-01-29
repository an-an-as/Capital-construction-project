import Foundation

class GeneralBinaryTreeNote {
    var data: String
    var leftChild: GeneralBinaryTreeNote!
    var rightChild: GeneralBinaryTreeNote!
    init(data: String) {
        self.data = data
    }
}

class GeneralBinaryTree {
    var rootNote: GeneralBinaryTreeNote!
    fileprivate var items: Array<String>
    fileprivate var index = -1

    init(items: Array<String>) {
        self.items = items
        self.rootNote = self.createTree()
    }
    
    fileprivate func createTree() -> GeneralBinaryTreeNote! {
        self.index = self.index + 1
        if index < self.items.count && index >= 0 {
            let item = self.items[index]
            if item == "" {
                return nil
            } else {
                let note = GeneralBinaryTreeNote(data: item)
                note.leftChild = createTree()
                note.rightChild = createTree()
                return note
            }
        }
        return nil;
    }
    
    func preOrderTraverse() {
        self.preOrderTraverse(note: rootNote)
        print("\n")
    }
    private func preOrderTraverse (note: GeneralBinaryTreeNote!) {
        guard let note = note else { return }
        print(note.data, separator: "", terminator: " ")
        preOrderTraverse(note: note.leftChild)
        preOrderTraverse(note: note.rightChild)
    }
    func inOrderTraverse() {
        self.inOrderTraverse(note: rootNote)
    }
    private func inOrderTraverse (note: GeneralBinaryTreeNote!) {
        guard let note = note else { return }
        inOrderTraverse(note: note.leftChild)
        print(note.data, separator: "", terminator: " ")
        inOrderTraverse(note: note.rightChild)
    }
    func afterOrderTraverse() {
        self.afterOrderTraverse(note: rootNote)
        print("\n")
    }
    
    private func afterOrderTraverse (note: GeneralBinaryTreeNote!) {
        guard let note = note else { return }
        afterOrderTraverse(note: note.leftChild)
        afterOrderTraverse(note: note.rightChild)
        print(note.data, separator: "", terminator: " ")
    }
}
