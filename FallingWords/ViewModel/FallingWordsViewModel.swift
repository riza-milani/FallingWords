import Foundation


class FallingWordsViewModel: FallingWordsViewModelProtocol {

    private var score = Score(correct: 0, incorrect: 0, none: 0)
    private var words: [Word]?
    private var generateWords = [Word]()

    let wordRepository: WordRepository

    var playerAnswer: AnswerType
    var viewInput: ViewInput?
    var shouldGenerate: Bool {
        if score.incorrect >= Constants.maxErrors ||
            score.none >= Constants.maxErrors ||
            (score.total >= Constants.maxAttempts) {
            return false
        }
        return true
    }

    init(wordRepository: WordRepository) {
        self.wordRepository = wordRepository
        playerAnswer = .none
    }
    
    func loadWords() {
        wordRepository.fetchWords { [weak self] result in
            switch(result) {
            case .success(let words):
                self?.words = words
            case .failure(_):
                // TODO: Handle error
                break
            }
        }
    }

    func generateRandomWords(completion: @escaping ((String, String)) -> Void)  {
        generateWords = Bool.random() ? generateCorrectPair() : generateWrongPair()
        completion((generateWords[0].text_eng, generateWords[1].text_spa))
    }

    func showScores() {
        viewInput?.showScore(score: score)
    }

    func resetScores() {
        score.correct = 0
        score.incorrect = 0
        score.none = 0
    }

    func checkAnswer() {
        guard generateWords.count == 2 else {
            return
        }
        switch(playerAnswer) {
        case .correct:
            if generateWords[0] == generateWords[1] {
                score.correct += 1
            } else {
                score.incorrect += 1
            }
        case .incorrect:
            if generateWords[0] != generateWords[1] {
                score.correct += 1
            } else {
                score.incorrect += 1
            }
        case .none:
            score.none += 1
        }
    }

    private func generateCorrectPair() -> [Word] {
        if let word = words?.randomElement() {
            return [word, word]
        }
        return []
    }

    private func generateWrongPair() -> [Word] {
        let word1 = words?.randomElement()
        let word2 = words?
            .filter {$0 != word1}
            .randomElement()
        if let word1 = word1, let word2 = word2 {
            return [word1, word2]
        }
        return []
    }
    
    enum Constants {
        static fileprivate let maxAttempts = 10
        static fileprivate let maxErrors = 3
    }
}
