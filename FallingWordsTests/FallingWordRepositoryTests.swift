import XCTest
@testable import FallingWords

class FallingWordRepositoryTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
    
    func testWordRepositoryLocal() throws {
        let wordRepositoryLocal = WordRepositoryLocal()
        let expectWords = expectation(description: "Fetch Data")
        wordRepositoryLocal.fetchWords { result in
            switch(result) {
            case .success(let words):
                XCTAssert(words.count > 100)

            case .failure(_):
                XCTFail("wrong repository response")

            }
            expectWords.fulfill()
        }
        wait(for: [expectWords], timeout: 5)
    }

}
