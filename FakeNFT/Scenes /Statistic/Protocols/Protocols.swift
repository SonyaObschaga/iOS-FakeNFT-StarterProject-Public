import UIKit

// MARK: - Model
struct User {
    let name: String
    let score: Int
    let position: Int
}

//MARK: - View Protocol
protocol StatisticViewProtocol: AnyObject {
    func displayUsers(_ users: [User])
    func showLoading()
    func hideLoading()
    func showError(message: String, retryHandler: (() -> Void)?)
}

//MARK: - Presenter Protocol
protocol StatisticPresenterProtocol {
    func viewDidLoad()
    func didSelectUser(at index: Int)
    func didTapSortButton()
    
    var numberOfUsers: Int { get }
    func user(at index: Int) -> User
}

//MARK: - Service Protocol
protocol UserServiceProtocol {
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void)
}
