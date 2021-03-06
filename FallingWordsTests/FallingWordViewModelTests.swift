import XCTest
@testable import FallingWords

let mockWords = [
    Word(text_eng: "A", text_spa: "A"),
    Word(text_eng: "B", text_spa: "B"),
]

class FallingWordViewModelTests: XCTestCase {

    var viewModel: FallingWordsViewModelProtocol?

    class MockViewInput: ViewInput {
        var testChecked = false

        func showScore(score: Score) {
            testChecked = true
        }
    }

    override func setUpWithError() throws {
        viewModel = FallingWordsViewModel(wordRepository: WordRepositoryMock())
        viewModel?.viewInput = MockViewInput()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testViewModelLoadAndGenerate() throws {
        let expectation = expectation(description: "load and generate")
        viewModel?.loadWords()
        viewModel?.generateRandomWords(completion: { (word1, word2) in
            XCTAssert(!mockWords.filter{ $0.text_eng == word1 }.isEmpty)
            XCTAssert(!word1.isEmpty)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5)
    }

    func testViewModelPlayerAnswer() throws {
        let expectation = expectation(description: "load and generate")
        viewModel?.loadWords()
        viewModel?.generateRandomWords(completion: { (_, _) in
            expectation.fulfill()
        })
        viewModel?.playerAnswer = .correct
        viewModel?.checkAnswer()
        viewModel?.showScores()
        XCTAssert((viewModel?.viewInput as? MockViewInput)?.testChecked ?? false)
        wait(for: [expectation], timeout: 5)
    }
}

class WordRepositoryMock: WordRepository {

    func fetchWords(completion: @escaping (Result<[Word], Error>) -> Void) {
        completion(.success(mockWords))
    }
    
    
}
