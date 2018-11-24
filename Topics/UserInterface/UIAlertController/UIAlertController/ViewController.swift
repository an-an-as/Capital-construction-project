import UIKit
class ViewController: UIViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let alert = UIAlertController(title: "中部警告", message: "最好两个按钮、超出的使用底部", preferredStyle: .alert)
    
        let cancle = UIAlertAction(title: "取消", style: .cancel) { _ in
            print("取消")
        }
        
        let delete = UIAlertAction(title: "删除", style: .destructive, handler: nil)
        
        alert.addAction(cancle)
        alert.addAction(delete)
        alert.preferredAction = cancle
        
        alert.addTextField { (testFild) in
            testFild.text = "输入账户"
            // Text fields can only be added to an alert controller of style UIAlertControllerStyleAlert
        }
        alert.addTextField { (testFild) in
            testFild.text = "输入密码"
        }
        
        self.present(alert, animated: true) {
            print("执行警告")
        }
        
    }
}
