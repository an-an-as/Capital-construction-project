/// SE-0199 adds a mutating toggle method to Bool.
/// This is especially useful if you need to toggle a boolean value deep inside a nested data structure
/// because you don’t have to repeat the same expression on both sides of the assignment
struct Layer {
    var isHidden = false
}
struct View {
    lazy var layer = Layer()
}
var view = View()
view.layer.isHidden = !view.layer.isHidden
print(view.layer.isHidden)
/// true

// ✨Swift 4.2
view.layer.isHidden.toggle()
print(view.layer.isHidden)
/// false
