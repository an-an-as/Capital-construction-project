import UIKit
class ViewController2: UIViewController {
    
}
extension ViewController2 {
    override func viewDidLoad() {
        super.viewDidLoad()
        let lable1 = MyLable()
        let lable2 = MyLable()
        view.addSubview(lable1)
        view.addSubview(lable2)
        lable1.backgroundColor = UIColor.red
        lable2.backgroundColor = UIColor.gray
        lable1.text = "A"
        lable2.text = "B"
        lable1.translatesAutoresizingMaskIntoConstraints = false
        lable2.translatesAutoresizingMaskIntoConstraints = false
        let views = ["lable1": lable1, "lable2": lable2]
        let horizonal = "H:|-space-[lable1(50)]-space-[lable2]"
        let vertical = "V:|-[lable1]-|"
        let metrics = ["space": 10]
        let constraintH = NSLayoutConstraint.constraints(withVisualFormat: horizonal, options: .alignAllFirstBaseline, metrics: metrics, views: views)
        let constraintV = NSLayoutConstraint.constraints(withVisualFormat: vertical, options: .alignAllCenterY, metrics: metrics, views: views)
        view.addConstraints(constraintH)
        view.addConstraints(constraintV)
    }
}
