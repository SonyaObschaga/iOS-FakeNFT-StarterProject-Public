import UIKit

// MARK: - StatisticPresenter
final class StatisticPresenter: StatisticPresenterProtocol {
    
    // MARK: - Property
    weak var view: StatisticViewProtocol?
    
    // MARK: - Private Properties
    private let userService: UserServiceProtocol
    private var users: [User] = []
    private let router: StatisticRouterProtocol
    
    // MARK: - Initialization
    init(view: StatisticViewProtocol? = nil, userService: UserServiceProtocol, router: StatisticRouterProtocol) {
        self.view = view
        self.userService = userService
        self.router = router
    }
    
    // MARK: - Public Interface
    func viewDidLoad() {
        loadUsers()
    }
    
    func didSelectUser(at index: Int) {
        guard index < users.count else { return }
        let user = users[index]
        router.showUserCard(user)
    }
    
    var numberOfUsers: Int {
        return users.count
    }
    
    func user(at index: Int) -> User {
        return users[index]
    }
    
    func didTapSortButton() {
        view?.showSortOptions()
    }
    
    func didSelectSortOption(_ option: SortOption) {
        guard !option.isCancel else { return }
        
        switch option {
        case .name:
            sortByName()
        case .rating:
            sortByRating()
        case .cancel:
            break
        }
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

    private func sortByName() {
        users.sort { $0.name < $1.name }
        view?.displayUsers(users)
    }
    
    private func sortByRating() {
        users.sort { $0.score > $1.score }
        view?.displayUsers(users)
    }
}
