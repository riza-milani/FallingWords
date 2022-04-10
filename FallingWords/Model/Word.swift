import Foundation

struct Word: Decodable, Equatable {
    let text_eng: String
    let text_spa: String
}

extension Word {
    static func ==(lhs: Word, rhs: Word) -> Bool {
        return lhs.text_eng == rhs.text_eng && lhs.text_spa == rhs.text_spa
    }
}
