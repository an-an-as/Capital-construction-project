/**
 * UseProtocolCachePolicy -- 缓存存在就读缓存，若不存在就请求服务器
 * ReloadIgnoringLocalCacheData -- 忽略缓存，直接请求服务器数据
 * ReturnCacheDataElseLoad -- 本地如有缓存就使用，忽略其有效性，无则请求服务器
 * ReturnCacheDataDontLoad -- 直接加载本地缓存，没有也不请求网络
 * ReloadIgnoringLocalAndRemoteCacheData -- 尚未实现
 * ReloadRevalidatingCacheData -- 尚未实现
 */
class ViewController: UIViewController, URLSessionTaskDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        //通过request配置
        func requestCache1() {
            let fileUrl = URL(string: "http://www.baidu.com")
            var request = URLRequest(url: fileUrl!)
            //再次发起请求的话就会从缓存文件中进行数据的加载
            request.cachePolicy = .returnCacheDataElseLoad
            //shared 默认配置
            let session = Foundation.URLSession.shared
            let dataTask = session.dataTask(with: request) { data, response, error in
                //...
            }
            dataTask.resume()
        }
        //通过URLSessionConfiguration配置
        func requestCache2() {
            let fileUrl = URL(string: "http://www.baidu.com")
            let request = URLRequest(url: fileUrl!)
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.requestCachePolicy = .returnCacheDataElseLoad
            let session = Foundation.URLSession(configuration: sessionConfig)
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                //...
            }
            dataTask.resume()
        }
        //通过URLCache精确配置
        func requestCache3() {
            let fileUrl = URL(string: "http://www.cnblogs.com")
            var request = URLRequest(url: fileUrl!)
            let memoryCapacity = 4 * 1024 * 1024    //内存容量
            let diskCapacity = 10 * 1024 * 1024     //磁盘容量
            let cacheFilePath = "MyCache"           //缓存路径
            let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: cacheFilePath)
            URLCache.shared = urlCache
            request.cachePolicy = .returnCacheDataElseLoad
            let session = Foundation.URLSession.shared
            let dataTask = session.dataTask(with: request) { data, response, error in
                //...
            }
            dataTask.resume()
        }
        //清除缓存
        func clearCacheFile() {
            //获取缓存文件路径
            let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
            //获取BoundleID
            guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return }
            //拼接当前工程所创建的缓存文件路径
            let projectCashPath = "\(cachePath)/\(bundleIdentifier)/"
            //创建FileManager
            let fileManager: FileManager = FileManager.default
            //获取缓存文件列表
            guard let cacheFileList = try?fileManager.contentsOfDirectory(atPath: projectCashPath) else { return }
            //遍历文件列表，移除所有缓存文件
            for fileName in cacheFileList {
                let willRemoveFilePath = projectCashPath + fileName
                if fileManager.fileExists(atPath: willRemoveFilePath) {
                    try!fileManager.removeItem(atPath: willRemoveFilePath)
                }
            }
        }
    }
}
