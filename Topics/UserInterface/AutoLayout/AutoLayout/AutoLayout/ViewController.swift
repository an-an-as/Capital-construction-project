import UIKit
class ViewController: UIViewController {
    var redView: UIView!
    var visable = false
    @IBOutlet weak var hideContainer: NSLayoutConstraint!
}
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        redView = UIView()
        redView.backgroundColor = .red
        self.view .addSubview(redView)
        redView.translatesAutoresizingMaskIntoConstraints = false
        hideConstainer()
    }
}
/// 一元约束处理尺寸
extension ViewController {
    /// 宽度 >= 100
    func contraint1() {
        let widthConstraint = NSLayoutConstraint(item: redView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        view.addConstraint(widthConstraint)
    }
}
extension ViewController {
    /**
     constraintWithItem 第一个视图 self.redView
     attribute          属性      NSLayoutAttributeLeft
     relatedBy          关系      NSLayoutRelationEqual
     toItem             第二个视图 self.view
     attribute          属性      NSLayoutAttributeLeft
     multiplier:        乘数      1.0f
     constant           常数      0.0f
     */
    func contraint() {
        let height = NSLayoutConstraint(item: redView, attribute: .height,
                                        relatedBy: .equal, toItem: view,
                                        attribute: .height, multiplier: 0.5, constant: 0)
        let weight = NSLayoutConstraint(item: redView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: 0)
        let centerX = NSLayoutConstraint(item: redView, attribute: .centerX,
                                         relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: redView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        view .addConstraints([height, weight, centerX, centerY])
        UIView.animate(withDuration: 5) {
            self.view.constraints.forEach {
                if $0.firstAttribute == NSLayoutConstraint.Attribute.width {
                    $0.constant = 200
                }
            }
            self.view.layoutIfNeeded()
        }
    }
}
extension ViewController {
    func hideConstainer() {
        let barButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hide))
        navigationItem.leftBarButtonItem = barButton
    }
    @objc func hide() {
        visable = !visable
        hideContainer.isActive = visable
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .beginFromCurrentState,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
}
