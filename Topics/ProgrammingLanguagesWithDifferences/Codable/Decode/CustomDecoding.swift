import Foundation
let response = """
{
"title": "How to parse a json - IV",
"comment": "null",
"created_at": "2017-08-24 00:00:00 +0800",
"duration": 100,
"slices": [125, 250, 375]
}
"""

struct Episode: Codable {
    var title: String
    var createdAt: Date
    var comment: String?
    var duration: Int
    var slices: [Float]
    
    enum CodingKeys:String,CodingKey {
        case title
        case createdAt = "created_at"
        case comment
        case duration
        case slices
        
    }
    
    init(title: String,createdAt: Date, comment: String?, duration: Int,slices: [Float]) {
        self.title = title
        self.createdAt = createdAt
        self.comment = comment
        self.duration = duration
        self.slices = slices
    }
}
extension Episode{
    init(from decoder: Decoder) throws {
        let container = try decoder.container( keyedBy: CodingKeys.self)
        let title = try container.decode( String.self, forKey: .title)
        let createdAt = try container.decode( Date.self, forKey: .createdAt)
        let duration = try container.decode( Int.self, forKey: .duration)
        let comment = try container.decodeIfPresent( String.self, forKey: .comment)
        var unkeyedContainer = try container.nestedUnkeyedContainer(forKey: .slices)
        var percentages: [Float] = []
        while (!unkeyedContainer.isAtEnd) {
            let sliceDuration = try unkeyedContainer.decode(Float.self)
            percentages.append(sliceDuration / Float(duration))
        }
        self.init(title: title,createdAt: createdAt, comment: comment, duration: duration, slices: percentages)
    }
}

let data = response.data(using: .utf8)!
let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
    let data = try decoder.singleValueContainer().decode(String.self)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    return formatter.date(from: data)!
})
let episode = try! decoder.decode(Episode.self, from: data)
