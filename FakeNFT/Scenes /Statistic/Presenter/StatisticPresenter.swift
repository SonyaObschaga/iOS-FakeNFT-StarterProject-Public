import UIKit

// MARK: - StatisticPresenter
final class StatisticPresenter: StatisticPresenterProtocol {
    
    // MARK: - Properties
    weak var view: StatisticViewProtocol?
    private let userService: UserServiceProtocol
    private var users: [User] = []
    
    // MARK: - Initialization
    init(view: StatisticViewProtocol? = nil, userService: UserServiceProtocol) {
        self.view = view
        self.userService = userService
    }
    
    // MARK: - Public Interface
    func viewDidLoad() {
        loadUsers()
    }
    
    func didSelectUser(at index: Int) {
        guard index < users.count else { return }
        let user = users[index]
        print("Selected user: \(user.name)")
    }
    
    func didTapSortButton() {
        
    }
    
    var numberOfUsers: Int {
        return users.count
    }
    
    func user(at index: Int) -> User {
        return users[index]
    }
    
    // MARK: - Private Methods
    private func loadUsers() {
        userService.fetchUsers { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self?.users = users
                    self?.view?.displayUsers(users)
                    self?.view?.hideLoading()
                case .failure(let error):
                    self?.view?.showError(
                        message: error.localizedDescription,
                        retryHandler: { [weak self] in
                            self?.loadUsers()
                        }
                    )
                }
            }
        }
    }
    
    func retryLoading() {
        loadUsers()
    }
}
