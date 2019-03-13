
class ViewController: UIViewController, URLSessionTaskDelegate {
    override func viewDidLoad() {
        func uploadTask(_ parameters: Data) {
            let uploadUrlString = "http://127.0.0.1/upload.php"
            let url = URL(string: uploadUrlString)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let session = URLSession.init(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
            let uploadTask = session.uploadTask(with: request, from: parameters) { data, response, error in
                
            }
            uploadTask.resume()
            //会执行NSURLSessionTaskDelegate中的didSendBodyData回调方法监听上传进度
        }
        func downloadTaskTest() {
            //暂停后保存信息、ResumeData中存储的并不是我们上次下载的数据Data，而是存储了下载地址和上次下载的位置等相关的信息
            let resumeData = UserDefaults.standard.object(forKey: "ResumeData") as? Data
            let config = URLSessionConfiguration.background(withIdentifier: "ResumeData")
            var downloadTask: URLSessionDownloadTask?
            var downloadSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
            if resumeData != nil {
                downloadTask = downloadSession.downloadTask(withResumeData: resumeData!)
            } else {
                //如果下载位置为空则重新开始下载
                let fileUrl = URL(string: "https://pic.cnblogs.com/avatar/545446/20140828105334.png")
                let request = URLRequest(url: fileUrl!)
                downloadTask = downloadSession.downloadTask(with: request)
            }
            downloadTask?.resume()
            func cancelTask() {
                //将该Data进行解析，是一个xml格式的数据
                //在下载过程中正在下载的任务会在temp目录中创建一个.tmp的临时文件用来存储下载的临时数据
                downloadTask?.cancel() { data in
                    if resumeData != nil {
                        UserDefaults.standard.set(data, forKey: "ResumeData")
                    }
                }
            }
        }
        // MARK: - URLSESSION DELEGATE
        // 下载结束后对临时文件的处理
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            UserDefaults.standard.removeObject(forKey: "ResumeData")
            //临时文件路径(临时文件用于存放暂停后的下载位置、下载完成后会自动删除)
            let tempFilePath = location.path
            //文件名为当前时间的时间戳
            let newFileName = String(UInt(Date().timeIntervalSince1970))
            var newFileExtensionName = "txt"
            if session.configuration.identifier == "backgroundDownload" {
                newFileExtensionName = "png"
            }
            let newFilePath = NSHomeDirectory() + "/Documents/\(newFileName).\(newFileExtensionName)"
            //创建文件管理器
            let fileManager = FileManager.default
            //将临时文件移动到新目录中
            try! fileManager.moveItem(atPath: tempFilePath, toPath: newFilePath)
            //将下载后的图片进行显示
            if downloadTask == downloadTask {
                let imageData = try? Data(contentsOf: URL(fileURLWithPath: newFilePath))
                DispatchQueue.main.async {
                    //...
                }
            }
        }
        /**
         实时监听下载任务
         - parameter session:                   session对象
         - parameter downloadTask:              下载任务
         - parameter bytesWritten:              本次接收
         - parameter totalBytesWritten:         已下载
         - parameter totalBytesExpectedToWrite: 下载目标的总量
         */
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64,
                        totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
            let written = Float(totalBytesWritten)
            let total = Float(totalBytesExpectedToWrite)
            DispatchQueue.main.async {
                //获取进度
                // self.downloadProgressView.progress = written/total
            }
        }
        /**
         下载偏移，主要用于暂停续传
         - parameter session:
         - parameter downloadTask:
         - parameter fileOffset:            已下载多少
         - parameter expectedTotalBytes:    文件大小
         */
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                        didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
            print("已经下载：\(fileOffset)")
            print("文件总量：\(expectedTotalBytes)")
            DispatchQueue.main.async {
                //self.downloadProgressView.progress = Float(fileOffset/expectedTotalBytes)
            }
        }
    }
}
