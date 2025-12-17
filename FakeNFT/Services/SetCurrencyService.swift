import Foundation

protocol SetCurrencyService {
    func setCurrency(
        currencyId: String,
        completion: @escaping SetCurrencyCompletion
    )
}

typealias SetCurrencyCompletion = (Result<Void, Error>) -> Void

final class SetCurrencyServiceImpl: SetCurrencyService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func setCurrency(
        currencyId: String,
        completion: @escaping SetCurrencyCompletion
    ) {
        let request = SetCurrencyRequest(id: currencyId)

        networkClient.send(request: request, type: EmptyResponse.self) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
