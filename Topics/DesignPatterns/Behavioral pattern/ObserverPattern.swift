import Foundation
class MyObserver: NSObject {
    var name = ""
    init(name: String) {
        super.init()
        self.name = name
        let notificationName = Notification.Name(rawValue: "DownloadImageNotification") /// 和通知中心的名字需要一致
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(downloadImage(notification:)),
                                               name: notificationName,
                                               object: nil)
    }
    @objc func downloadImage(notification: Notification) {
        let userInfo = notification.userInfo as? [String: AnyObject]
        let value1 = userInfo?["value1"] as? String
        let value2 = userInfo!["value2"] as? Int
        print("\(name) 接到通知 内容:［\(String(describing: value1)), \(String(describing: value2))］")
        sleep(5)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

let observers = [MyObserver(name: "观察者1"), MyObserver(name: "观察者2")]
print("发送通知")
let notificationName = Notification.Name(rawValue: "DownloadImageNotification")
NotificationCenter.default.post(name: notificationName,
                                object: nil,
                                userInfo: ["value1": "从控制器发射了", "value2": 0101010])
print("通知完毕")
