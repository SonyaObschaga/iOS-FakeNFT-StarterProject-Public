import Foundation

typealias UpdateOrderCompletion = (Result<Void, Error>) -> Void

protocol UpdateAndPayService {
    func updateOrder(nftIds: [String], completion: @escaping UpdateOrderCompletion)
}

final class UpdateAndPayOrderServiceImpl: UpdateAndPayService {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func updateOrder(nftIds: [String], completion: @escaping UpdateOrderCompletion) {
        let request = UpdateAndPayOrderRequest(nftIds: nftIds)

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
