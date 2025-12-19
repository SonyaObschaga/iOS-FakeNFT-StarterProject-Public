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
                        id: response.id,
                        name: response.name,
                        score: response.nfts.count,
                        website: response.website,
                        avatar: response.avatar,
                        description: response.description,
                        nfts: response.nfts
                    )
                }
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchUserById(_ id: String, completion: @escaping (Result<UserResponse, Error>) -> Void) {
        let request = UserByIdRequest(id: id)
        networkClient.send(request: request, type: UserResponse.self) { result in
            switch result {
            case .success(let userResponse):
                completion(.success(userResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
