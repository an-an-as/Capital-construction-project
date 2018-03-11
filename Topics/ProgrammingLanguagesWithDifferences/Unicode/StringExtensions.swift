extension String {
    var allPrefixes: [Substring] {
        return [""] + self.indices.map { index in self[...index]
        }
    }
}
