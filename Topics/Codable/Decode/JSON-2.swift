let response = """
{
    "list":
    [
        {
        "title": "How to parse JSON I",
        "type": "free",
        "created_at": "2017-08-23T01:42:42Z",
        "duration": "NaN",
        "origin": "Ym94dWVpby5jb20=",
        "url": "video.com"
        },

        {
        "title": "How to parse JSON II",
        "type": "free",
        "created_at": "2017-08-23T01:42:42Z",
        "duration": "NaN",
        "origin": "Ym94dWVpby5jb20=",
        "url": "video.com"
        }
    ]
}
"""

enum EpisodeType: String,Codable {
    case free
    case paidb
}
struct Episode: Codable {
    var title: String
    var createdAt: Date
    var duration: Float
    var type: EpisodeType
    var origin: Data
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case title
        case type
        case duration
        case origin
        case url
        case createdAt = "created_at"
    }
}
struct EpisodeList: Codable {
    let list: [Episode]
}
let data = response.data(using: .utf8)!
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601
decoder.dataDecodingStrategy = .base64
decoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+Infinity", negativeInfinity: "-Infinity", nan: "NaN")
let result = try! decoder.decode(EpisodeList.self, from: data)
