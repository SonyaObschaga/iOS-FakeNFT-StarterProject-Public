import UIKit

final class UserService: UserServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            let users = [
                User(name: "Иван", score: 100),
                User(name: "Мария", score: 85),
                User(name: "Петр", score: 92),
                User(name: "Анна", score: 78),
                User(name: "Сергей", score: 95)
            ]
            completion(.success(users))
        }
    }
    
    
}
