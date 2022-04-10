import Foundation

protocol FallingWordsViewModelProtocol {
    var playerAnswer: AnswerType { get set }
    var shouldGenerate: Bool { get }
    func loadWords()
    func generateRandomWords(completion: @escaping ((String, String)) -> Void)
    func checkAnswer()
    func resetScores()
    func showScores()
}

protocol ViewInput {
    func showScore(score: Score)
}

