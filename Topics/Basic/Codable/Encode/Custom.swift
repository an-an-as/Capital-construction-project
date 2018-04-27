struct Episode: Codable {
    var title: String
    var createdAt: Date
    var comment: String?
    var slices: [Float]
    enum CodingKeys:String,CodingKey {
        case title
        case createdAt = "created_at"
        case comment
        case slices
    }
    enum EpisodeType: String ,Codable{
        case free
        case paid
    }
}
extension Episode {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(comment, forKey: .comment)
        var unkeyedContainer = container.nestedUnkeyedContainer(forKey: .slices)
        try slices.forEach { items in try unkeyedContainer.encode("\(items * 100) %") }
    }
}
let episode = Episode( title: "HELLO、WORLD",createdAt: Date(),comment: nil,slices: [0.25, 0.5, 0.75] )
let encoder = JSONEncoder()
encoder.dateEncodingStrategy = .custom({ (date, encoder) in
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
    let stringData = formatter.string(from: date)
    var container = encoder.singleValueContainer()
    try container.encode(stringData)
})
let data = try! encoder.encode(episode)
