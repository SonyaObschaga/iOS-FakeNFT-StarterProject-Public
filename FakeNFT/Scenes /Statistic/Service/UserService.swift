import UIKit

final class UserService: UserServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            let users = [
                User(name: "Иван", score: 100, position: 1),
                User(name: "Мария", score: 85, position: 3),
                User(name: "Петр", score: 92, position: 2),
                User(name: "Анна", score: 78, position: 4),
                User(name: "Сергей", score: 95, position: 2)
                ]
            completion(.success(users))
        }
    }
    
    
}
