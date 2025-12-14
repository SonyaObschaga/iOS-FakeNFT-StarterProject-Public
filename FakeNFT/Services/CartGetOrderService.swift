import Foundation

struct CartResponse: Decodable {
    let nfts: [String]
    let id: String
}

typealias CartCompletion = (Result<[String], Error>) -> Void

protocol GetCartService {
    func loadCart(completion: @escaping CartCompletion)
}

final class CartGetOrderServiceImpl: GetCartService {

    private let networkClient: NetworkClient
    private var nftIds: [String] = []

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadCart(completion: @escaping CartCompletion) {
        
        let request = CartOrderRequest()

        networkClient.send(request: request, type: CartResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.nftIds = response.nfts
                completion(.success(response.nfts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func currentNftIds() -> [String] {
        nftIds
    }
}
