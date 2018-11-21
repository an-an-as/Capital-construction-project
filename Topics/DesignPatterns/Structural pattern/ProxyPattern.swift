//代理模式：为另一个对象提供一个替身或占位符以控制对这个对象的访问。
//远程代理：控制访问远程对象
//保护代理：基于权限的资源访问
//虚拟代理：控制访问创建开销大的资源

// === 虚拟代理 =======
//给大对象创建替身，以图片的占位图为例

protocol ImageType {
    func imageLoad()
}
class BigImage: ImageType {
    func imageLoad() {
        print("大图片")
    }
}
class SmallImage: ImageType {
    func imageLoad() {
        print("小占位图片")
    }
}
//图片虚拟代理
class BigImageProxy: ImageType {
    var bigImage: ImageType?
    var bigImageNoInit = true
    var smallImage = SmallImage()
    func imageLoad() {
        if bigImage != nil {
            bigImage?.imageLoad()
        } else {
            smallImage.imageLoad()
            if bigImageNoInit {
                self.bigImage = BigImage() //模拟大图片需要长时间的初始化加载
                bigImageNoInit = false
            }
        }
    }
}
class ImageClient {
    var image: ImageType?
    func setImage(_ image: ImageType) {
        self.image = image
    }
    func imageLoad() {
        image?.imageLoad()
    }
}

let imageClient = ImageClient()
imageClient.setImage(BigImageProxy())
imageClient.imageLoad()
imageClient.imageLoad()
protocol InternetAccessProtocol {
    func response()
    func getId() -> String
}
class Facebook: InternetAccessProtocol {
    func response() {
        print("你好，欢迎访问脸书 ")
    }
    func getId() -> String {
        return "FaceBook"
    }
}
class Twitter: InternetAccessProtocol {
    func response() {
        print("你好，欢迎访问推特")
    }
    func getId() -> String {
        return "Twitter"
    }
}
class Cnblogs: InternetAccessProtocol {
    func response() {
        print("你好，欢迎访问博客园")
    }
    func getId() -> String {
        return "Cnblogs"
    }
}
protocol ProxyType: InternetAccessProtocol {
    func setDelegate(delegate: InternetAccessProtocol)
}
/// 远程代理
class ShadowsocksProxy: ProxyType {
    private var delegate: InternetAccessProtocol?
    init(_ delegate: InternetAccessProtocol? = nil) {
        self.delegate = delegate
    }
    func setDelegate(delegate: InternetAccessProtocol) {
        self.delegate = delegate
    }
    func response() {
        delegate?.response()
    }
    func getId() -> String {
        return "ShadowsocksProxy"
    }
}

//=======保护代理============
class GreatFirewall: ProxyType {
    //黑名单
    private var blackList: Array<String> = [Facebook().getId(), Twitter().getId()]
    private var delegate: InternetAccessProtocol? = nil
    /// 判断是否被墙
    func hasInTheBlackList(webSite: InternetAccessProtocol) -> Bool {
        return blackList.contains { (item) -> Bool in
            if webSite.getId() == item {
                return true
            } else {
                return false
            }
        }
    }
    func setDelegate(delegate: InternetAccessProtocol) {
        if hasInTheBlackList(webSite: delegate) {
            print("你访问的\(delegate.getId())不可用")
            self.delegate = nil
        } else {
            self.delegate = delegate
        }
    }
    func response() {
        delegate?.response()
    }
    func getId() -> String {
        return (delegate?.getId())!
    }
}
class Client {
    private var shadowsocksProxy = ShadowsocksProxy()
    private var greatFirewall = GreatFirewall()
    func useProxyAcccessWebSite(webSite: InternetAccessProtocol) {
        shadowsocksProxy.setDelegate(delegate: webSite)   ///为代理指定代理对象，也就是要访问的网站
        shadowsocksProxy.response()
    }
    func useGreatFirewall(webSite: InternetAccessProtocol)  {
        greatFirewall.setDelegate(delegate: webSite)
        greatFirewall.response()
    }
}

let client = Client()

print("使用远程代理直接访问Facebook：")
client.useProxyAcccessWebSite(webSite: Facebook())

print("\n经过防火墙直接访问FaceBook：")
client.useGreatFirewall(webSite: Facebook())

print("\n经过防火墙访问远程代理，然后使用远程代理来访问Facebook：")
client.useGreatFirewall(webSite: ShadowsocksProxy(Facebook()))

print("\n经过防火墙直接访问博客园：")
client.useGreatFirewall(webSite: Cnblogs())

