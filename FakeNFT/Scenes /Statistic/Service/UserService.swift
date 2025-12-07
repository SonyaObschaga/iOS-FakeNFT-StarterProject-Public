import UIKit

final class UserService: UserServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let request = UsersRequest(page: 0, size: 100)
        
        networkClient.send(request: request, type: [UserResponse].self) { result in
            switch result {
            case .success(let userResponses):
                let users = userResponses.map { response in
                    User(
                        name: response.name,
                        score: response.nfts.count,
                        website: response.website
                    )
                }
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
