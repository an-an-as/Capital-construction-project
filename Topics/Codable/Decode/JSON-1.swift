let response = """
{
    "title": "How to parse JSON",
    "created_at": "2017-08-23T01:42:42Z",
    "duration": "NaN",
    "url": "video.com",
    "origin": "Ym94dWVpby5jb20=",
    "type": "free"
}
"""
enum EpisodeType: String ,Codable{
    case free
    case paid
}
struct Episode: Codable {
    var title: String
    var createdAt: Date
    var duration: Float
    var type: EpisodeType
    var origin: Data
    let url: URL
    
    enum CodingKeys:String,CodingKey {
        case title
        case type
        case duration
        case origin
        case url
        case createdAt = "created_at"
        /// 自定义样式映射规则 枚举名: CodingKeys 
    }
}
let data = response.data(using: .utf8)
let jsonDecoder = JSONDecoder()
jsonDecoder.dateDecodingStrategy = .iso8601
jsonDecoder.dataDecodingStrategy = .base64
jsonDecoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+Infinity", negativeInfinity: "-Infinity", nan: "NaN")
let result = try! jsonDecoder.decode(Episode.self, from: data!)
/// 处理时间显示样式
/// 数据格式
/// 处理特殊无限浮点数 Nan
