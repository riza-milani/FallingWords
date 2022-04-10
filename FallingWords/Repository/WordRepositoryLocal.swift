import Foundation

class WordRepositoryLocal: WordRepository {
    struct JsonParsingError: Error { }

    func fetchWords(completion: @escaping (Result<[Word], Error>) -> Void) {
        if let url = Bundle.main.url(forResource: Constants.fileName, withExtension: Constants.extensionType) {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Word].self, from: data)
                completion(.success(jsonData))
            } catch {
                completion(.failure(JsonParsingError()))
            }
        }
    }

    enum Constants {
        static fileprivate let extensionType = "json"
        static fileprivate let fileName = "words"
    }
}
