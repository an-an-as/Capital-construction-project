let response3 = """
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
    "title": "How to parse JSON",
    "type": "free",
    "created_at": "2017-08-23T01:42:42Z",
    "duration": "NaN",
    "origin": "Ym94dWVpby5jb20=",
    "url": "video.com"
    }
]
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

let data = response3.data(using: .utf8)!
let jsonDecoder = JSONDecoder()
jsonDecoder.dateDecodingStrategy = .iso8601
jsonDecoder.dataDecodingStrategy = .base64
jsonDecoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+Infinity", negativeInfinity: "-Infinity", nan: "NaN")
let result = try! jsonDecoder.decode( [Episode].self, from: data)
