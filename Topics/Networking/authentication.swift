/**
 认证方式
 * NSURLAuthenticationMethodHTTPBasic:  HTTP基本认证，需要提供用户名和密码
 * NSURLAuthenticationMethodHTTPDigest: HTTP数字认证，与基本认证相似需要用户名和密码
 * NSURLAuthenticationMethodHTMLForm:   HTML表单认证，需要提供用户名和密码
 * NSURLAuthenticationMethodNTLM:       NTLM认证，NTLM（NT LAN Manager）是一系列旨向用户提供认证，完整性和机密性的微软安全协议
 * NSURLAuthenticationMethodNegotiate:  协商认证
 * NSURLAuthenticationMethodClientCertificate: 客户端认证，需要客户端提供认证所需的证书
 * NSURLAuthenticationMethodServerTrust:       服务端认证，由认证请求的保护空间提供信任
 
 处理证书的策略: NSURLSessionAuthChallengeDisposition
 * UseCredential：                 使用证书
 * PerformDefaultHandling：        执行默认处理, 类似于该代理没有被实现一样，credential参数会被忽略
 * CancelAuthenticationChallenge： 取消请求，credential参数同样会被忽略
 * RejectProtectionSpace：         拒绝保护空间，重试下一次认证，credential参数同样会被忽略
 */
import UIKit
class ViewController: UIViewController, URLSessionTaskDelegate {
    override func viewDidLoad() {
        func authenticationButton(_ sender: AnyObject) {
            let url = URL(string: "https://www.xinghuo365.com/index.shtml")
            let request = URLRequest(url: url!)
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: OperationQueue.main)
            let sessionDataTask = session.dataTask(with: request) { data, response, error in
                //...
            }
            sessionDataTask.resume()
        }
        //  求数据时，如果服务器需要验证，那么就会调用下方的代理方法
        //- parameter session:           session
        //- parameter challenge:         授权质疑
        //- parameter completionHandler:
        func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            //从保护空间中取出认证方式
            let authenticationMethod = challenge.protectionSpace.authenticationMethod
            //判断是否是服务端认证，由认证请求的保护空间提供信任
            if authenticationMethod == NSURLAuthenticationMethodServerTrust {
                //授权质疑处理策略
                let disposition = URLSession.AuthChallengeDisposition.useCredential
                //创建证书SSL
                let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                //证书处理
                completionHandler(disposition, credential)
                return
            }
            /**
             *  HTTP基本认证和数字认证
             *  NSURLCredentialPersistence
             *      None ：要求 URL 载入系统 “在用完相应的认证信息后立刻丢弃”。
             *      ForSession ：要求 URL 载入系统 “在应用终止时，丢弃相应的 credential ”。
             *      Permanent ：要求 URL 载入系统 "将相应的认证信息存入钥匙串（keychain），以便其他应用也能使用。
             */
            //判断是否是HTTP基本认证，需要提供用户名和密码
            if authenticationMethod == NSURLAuthenticationMethodHTTPBasic {
                let credential = URLCredential.init(user: "username", password: "password", persistence: URLCredential.Persistence.forSession)
                let disposition = Foundation.URLSession.AuthChallengeDisposition.useCredential    //处理策略
                completionHandler(disposition, credential)
                return
            }
            //取消请求
            let disposition = Foundation.URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge
            completionHandler(disposition, nil)
        }
        
    }
}
