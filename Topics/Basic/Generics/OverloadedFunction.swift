func swap(_ num1: inout Int, _ num2: inout Int) {
    let temporary = num1
    num1 = num2
    num2 = temporary
}
func swap(_ num1: inout String, _ num2: inout String) {
    let temporary = num1
    num1 = num2
    num2 = temporary
}
func swap(_ num1: inout Double, _ num2: inout Double) {
    let temporary = num1
    num1 = num2
    num2 = temporary
}
var num1 = 1_000
var num2 = 2_000
swap(&num1, &num2)
print(num1)

func log<View: UIView>(_ view: View) {
    print("It's a \(type(of: view)), frame: \(view.frame)")
}
func log(_ view: UILabel) {
    let text = view.text ?? "(empty)"
    print("It's a label, text: \(text)")
}
let label = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 32))
label.text = "Password"
log(label)   /// It's a label, text: Password
let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
log(button)  /// It's a UIButton, frame: (0.0, 0.0, 100.0, 50.0)
let views = [label, button] /// Type of views is [UIView]
for view in views {
    log(view)
}
/// It's a UILabel, frame: (20.0, 20.0, 200.0, 32.0)
/// It's a UIButton, frame: (0.0, 0.0, 100.0, 50.0)
