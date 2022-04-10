import Foundation

protocol WordRepository {
    func fetchWords(completion: @escaping (Result<[Word], Error>) -> Void)
}
