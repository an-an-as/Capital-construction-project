class ViewController: UIViewController {
    override func viewDidLoad() {
        func delegateTest() {
            let fileUrl = URL(string: "https://www.xinghuo365.com")
            var requestFile = URLRequest(url: fileUrl!)
            requestFile.cachePolicy = .returnCacheDataElseLoad
            let sessionConfig = URLSessionConfiguration.default
            //使用NSURLSessionDataDelegate处理相应数据
            let sessionWithDelegate = Foundation.URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
            let sessionDataTask = sessionWithDelegate.dataTask(with: requestFile)
            sessionDataTask.resume()
        }
    }
}
//MARK:- URLSessionDelegate
extension ViewController: URLSessionDelegate {
    ///代理方法会在Session无效后被调用
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        print("Session已无效")
    }
    ///该代理方法会在后台Session在执行完后台任务后所执行的方法
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("后台事件已处理完毕")
        DispatchQueue.main.async {
            // self.downloadProgressView.progress = 1
        }
    }
}
//MARK:- URLSessionTaskDelegate
extension ViewController: URLSessionTaskDelegate {
    /**
     请求被重定向后会执行该方法
     * NSURLSessionDelegate的子协议NSURLSessionTaskDelegate
     * 父协议中的代理方法同样适用于所有的子协议
     
     - parameter session:
     - parameter task:
     - parameter response:  请求的响应头
     - parameter request:   被重定向后的request
     - parameter completionHandler: 处理句柄
     */
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        //可以对重定向后request中的URL进行修改,mutableCopy 深拷贝，是直接拷贝整个对象内存到另一块内存中
        if var mutableURLRequest = (request as NSURLRequest).mutableCopy() as? URLRequest {
            //会再次重定向到本地
            mutableURLRequest.url = URL(string: "http://www.baidu.com")
            completionHandler(mutableURLRequest as URLRequest)
            return
        }
        completionHandler(request)
    }
    ///处理认证
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    }
    ///处理流
    func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: @escaping (InputStream?) -> Void) {
    }
    //任务执行完毕后会执行下方的请求
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print(error?._userInfo ?? "")
        }
        print("task\(task.taskIdentifier)执行完毕")
    }
}
//MARK:- URLSessionDataDelegate
extension ViewController: URLSessionDataDelegate {
    /**
     收到响应后执行的方法--didReceiveResponse
     
     *   NSURLSessionResponseDisposition
     *  .Cancel         取消加载，默认为 .Cancel
     *  .Allow          允许继续操作, 会执行 dataTaskDidReceiveData回调方法
     *  .BecomeDownload 将请求转变为DownloadTask，会执行NSURLSessionDownloadDelegate
     *  .BecomeStream   将请求变成StreamTask，会执行NSURLSessionStreamDelegate
     
     - parameter session:
     - parameter dataTask:
     - parameter response:          服务器响应
     - parameter completionHandler: 指定处理响应的策略
     */
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        //if #available(iOS 9.0, *)
        completionHandler(.allow)
    }
    /**
     收到数据后执行的代理方法--didReceiveData
     
     * 上面的处理策略设置成Allow后会执行下方的方法，
     * 如果响应处理策略不是Allow那么就不会接收到服务器的Data，从而也不会执行下面的方法。
     
     - parameter session:
     - parameter dataTask:
     - parameter data:     接收的数据
     */
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let str = String.init(data: data, encoding: String.Encoding.utf8) {
            //...
        }
    }
    /**
     任务转变所执行的代理方法--didBecomeDownloadTask与didBecomeStreamTask
     变成DownLoadTask会调用的方法
     */
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
    }
    ///变成StreamTask会调用下方的方法
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
    }
    /**
     向服务器发送数据所调用的方法，可以监听文件上传进度
     
     - parameter session:
     - parameter task:
     - parameter bytesSent:                 本次上传
     - parameter totalBytesSent:            已上传
     - parameter totalBytesExpectedToSend:  文件总大小
     */
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        let written:Float = Float(totalBytesSent)
        let total:Float = Float(totalBytesExpectedToSend)
        DispatchQueue.main.async {
            // 获取进度  self.downloadProgressView.progress = written/total
        }
    }
    ///将要缓存响应时会触发下述方法
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        let data = proposedResponse.data
        if let str = String.init(data: data, encoding: String.Encoding.utf8) {
            print(str)
        }
        print(proposedResponse.storagePolicy)
        print(proposedResponse.userInfo ?? "")
        print(proposedResponse.response)
        //对缓存响应进行处理
        //completionHandler(proposedResponse)
    }
}
//MARK:- URLSessionStreamDelegate
extension ViewController: URLSessionStreamDelegate {
    /**
     当StreamTask进行closeRead时会执行该代理方法
     
     - parameter session:
     - parameter streamTask:
     */
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask) {
        //因为read已经被关闭了，所以下方的闭包是不会执行的
        streamTask.readData(ofMinLength: 0, maxLength: 1024*1024, timeout: 0) { (data, bool, error) in
            print(streamTask.countOfBytesReceived)
        }
        
    }
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask) {
        //读取流，数据，并进行二进制解析
        streamTask.readData(ofMinLength: 0, maxLength: 1024*1024, timeout: 0) { (data, bool, error) in
            print(streamTask.countOfBytesReceived)
            print(data ?? "")
            let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
            // self.showLog(json! as AnyObject)
        }
        streamTask.closeRead();
    }
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask) {
    }
    @available(iOS 9.0, *)
    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
    }
}
