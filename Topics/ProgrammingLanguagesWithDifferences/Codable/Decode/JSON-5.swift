
import Foundation
let response5 = """
{
    "meta": {
    "total_exp": 1000,
    "level": "beginner",
    "total_duration": 120
    },
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
    enum EpisodeType: String, Codable {
        case free
        case paid
    }
}
struct EpisodeMeta: Codable {
    let total_exp: Int
    let level: EpisodeLevel
    let total_duration: Int
    enum EpisodeLevel: String, Codable {
        case beginner
        case intermediate
        case advanced
    }
}
struct EpisodePage: Codable {
    let meta: EpisodeMeta
    let list: [Episode]
}
let data = response5.data(using: .utf8)!
let jsonDecoder = JSONDecoder()
jsonDecoder.dateDecodingStrategy = .iso8601
jsonDecoder.dataDecodingStrategy = .base64
jsonDecoder.nonConformingFloatDecodingStrategy = .convertFromString(positiveInfinity: "+Infinity", negativeInfinity: "-Infinity", nan: "NaN")
let result = try! jsonDecoder.decode( EpisodePage.self, from: data)
