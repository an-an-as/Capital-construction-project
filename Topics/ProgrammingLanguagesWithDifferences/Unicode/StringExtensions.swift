extension String {
    var allPrefixes: [Substring] {
        return [""] + self.indices.map { index in self[...index]
        }
    }
}
extension String {
    func wrapped(after: Int = 70) -> String {
        var i = 0
        let lines = self.split(omittingEmptySubsequences: false) {
            character in
            switch character {
            case "\n", " " where i >= after:
                i = 0
                return true
            default:
                i += 1
                return false
            }
        }
        return lines.joined(separator: "\n")
    }
}
extension Collection where Element: Equatable {
    func split<S: Sequence>(separators: S) -> [SubSequence] where Element == S.Element {
        return split { separators.contains($0) }
    }
}
