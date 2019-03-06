
**URL**
|
|--- `init?(string: String)`    如果请求方法是GET  URL添加前需进行编码  ?query......


**URLRequest**
|
|--- `public init(url: URL, cachePolicy: URLRequest.CachePolicy = default, timeoutInterval: TimeInterval = default)` 
|
|--- `var httpMethod: String? { get set }`      默认GET  
|
|--- `var httpBody: Data? { get set }`              如果是请求方法是POST需要对请求参数编码 并设置其Encode字符集为utf-8的二进制数据
|
|--- `var cachePolicy: URLRequest.CachePolicy { get set }`
|                   



**URLSessionConfiguration**
|
|--- `class var default: URLSessionConfiguration { get }`
|
|--- `class var ephemeral: URLSessionConfiguration { get }`
|
|--- `class func background(withIdentifier identifier: String) -> URLSessionConfiguration`
|
|--- `var identifier: String? { get } `  The background session identifier 


**URLSession**
|
|--- `class var shared: URLSession { get }`
|
|--- `func dataTask(with request: URLRequest, 
|                 completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask`
|                                    |
|                                    |--- 接受服务器返回的数据 
|                                    |--- supported in default, ephemeral, and shared sessions, but are not supported in background sessions.
|
|--- `init(configuration: URLSessionConfiguration, delegate: URLSessionDelegate?, delegateQueue queue: OperationQueue?)`
|
|--- `func uploadTask(with request: URLRequest, from bodyData: Data?, 
|                                 completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask`
|
|--- `func downloadTask(with request: URLRequest) -> URLSessionDownloadTask`
|
|--- `func downloadTask(withResumeData resumeData: Data) -> URLSessionDownloadTask`        从记录点开始下载
| 
|--- `func cancel(byProducingResumeData completionHandler: @escaping (Data?) -> Void)`  UserDefaults.standard.set(data, forKey: "ResumeData")
|
|--- `func resume()`
|
|--- `var configuration: URLSessionConfiguration { get }` 当前session配置的一个复制
|                                                       |
|                                                       |--- `var identifier: String? { get }`  The background session identifier 
|
|--- `URLSessionTaskDelegate`
|       |
|       |---`func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)` 下载结束后
|       |
|       |
|       |
|
|
|
|--- `enum AuthChallengeDisposition : Int`  认证策略


URLAuthenticationChallenge
|
|--- `var protectionSpace: URLProtectionSpace { get }` 保护空间
|               |                                   
|               |--- `var authenticationMethod: String { get }`   认证方式 
|               |                                                                                                                 
|               |--- `var serverTrust: SecTrust? { get }`    A representation of the server’s SSL transaction state.          


URLCredential
|
|
|



**认证方式**
* NSURLAuthenticationMethodHTTPBasic:  HTTP基本认证，需要提供用户名和密码
* NSURLAuthenticationMethodHTTPDigest: HTTP数字认证，与基本认证相似需要用户名和密码
* NSURLAuthenticationMethodHTMLForm:   HTML表单认证，需要提供用户名和密码
* NSURLAuthenticationMethodNTLM:       NTLM认证，NTLM（NT LAN Manager）是一系列旨向用户提供认证，完整性和机密性的微软安全协议
* NSURLAuthenticationMethodNegotiate:  协商认证
* NSURLAuthenticationMethodClientCertificate: 客户端认证，需要客户端提供认证所需的证书
* NSURLAuthenticationMethodServerTrust:        服务端认证，由认证请求的保护空间提供信任

**处理证书的策略: NSURLSessionAuthChallengeDisposition**
* UseCredential：                 使用证书
* PerformDefaultHandling：        执行默认处理, 类似于该代理没有被实现一样，credential参数会被忽略
* CancelAuthenticationChallenge： 取消请求，credential参数同样会被忽略
* RejectProtectionSpace：         拒绝保护空间，重试下一次认证，credential参数同样会被忽略
