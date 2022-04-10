import Foundation

struct Score {
    var correct: Int
    var incorrect: Int
    var none: Int

    var total: Int {
        correct + incorrect + none
    }
}
