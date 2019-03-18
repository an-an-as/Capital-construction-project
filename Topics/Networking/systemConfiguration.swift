import UIKit
import SystemConfiguration
class ViewController: UIViewController {
    override func viewDidLoad() {
        let reachability = SCNetworkReachabilityCreateWithName(nil, "www.baidu.com")
        func tapSCNetworkReachabilityButton(_ sender: AnyObject) {
            //1.创建reachability上下文
            var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
            //2.设置回调
            let clouserCallBackEnable = SCNetworkReachabilitySetCallback(reachability!, { (reachability, flags, info) in
                print("reachability=\(reachability)\ninfo=\(String(describing: info))\nflags=\(flags)\n")
                guard flags.contains(SCNetworkReachabilityFlags.reachable) else {
                    print("网络不可用")
                    return
                }
                if !flags.contains(SCNetworkReachabilityFlags.connectionRequired) {
                    print("以太网或者WiFi")
                }
                if flags.contains(SCNetworkReachabilityFlags.connectionOnDemand) ||
                    flags.contains(SCNetworkReachabilityFlags.connectionOnTraffic) {
                    if !flags.contains(SCNetworkReachabilityFlags.interventionRequired) {
                        print("以太网或者WiFi")
                    }
                }
                #if os(iOS)
                if flags.contains(SCNetworkReachabilityFlags.isWWAN) {
                    print("蜂窝数据")
                }
                #endif
            }, &context)
            //3.将reachability添加到执行队列
            let queueEnable = SCNetworkReachabilitySetDispatchQueue(reachability!,  DispatchQueue.main)
            if clouserCallBackEnable && queueEnable {
                print("已监听网络状态")
            }
        }
    }
}
