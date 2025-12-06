import UIKit

final class UserService: UserServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            let users = [
                User(name: "Иван", score: 100, website: "https://www.figma.com/design/owAO4CAPTJdpM1BZU5JHv7/Tracker?node-id=37878-26606&p=f&t=7u9lvsHqta8BlH61-0"),
                User(name: "Мария", score: 85, website: "https://translate.yandex.ru/"),
                User(name: "Петр", score: 92, website: "https://kick.com/"),
                User(name: "Анна", score: 78, website: "https://rostics.ru/"),
                User(name: "Сергей", score: 95, website: "https://dzen.ru/a/aAKspcEuQSTbBuMj")
            ]
            completion(.success(users))
        }
    }
}
