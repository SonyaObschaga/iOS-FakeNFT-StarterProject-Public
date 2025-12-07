import UIKit

// MARK: - StatisticPresenter
final class StatisticPresenter: StatisticPresenterProtocol {
    
    // MARK: - Property
    weak var view: StatisticViewProtocol?
    
    // MARK: - Private Properties
    private let userService: UserServiceProtocol
    private var users: [User] = []
    private let router: StatisticRouterProtocol
    private var currentSortOption: SortOption = .rating
    
    // MARK: - Initialization
    init(
        view: StatisticViewProtocol? = nil,
        userService: UserServiceProtocol,
        router: StatisticRouterProtocol
    ) {
        self.view = view
        self.userService = userService
        self.router = router
    }
    
    // MARK: - Public Interface
    func viewDidLoad() {
        loadSavedSortOption()
        loadUsers()
    }
    
    func didSelectUser(at index: Int) {
        guard index < users.count else { return }
        let user = users[index]
        router.showUserCard(user)
    }
    
    var numberOfUsers: Int {
        users.count
    }
    
    func user(at index: Int) -> User {
        users[index]
    }
    
    func didTapSortButton() {
        view?.showSortOptions()
    }
    
    func didSelectSortOption(_ option: SortOption) {
        guard !option.isCancel else { return }
        
        currentSortOption = option
        saveSortOption(option)
        
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
                    self?.applySavedSortOption()
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
    
    private func loadSavedSortOption() {
        if let savedOptionRawValue = UserDefaults.standard.string(forKey: UserDefaultsKeys.sortOption),
           let savedOption = SortOption(rawValue: savedOptionRawValue) {
            currentSortOption = savedOption
        } else {
            // Значение по умолчанию - по рейтингу
            currentSortOption = .rating
        }
    }
    
    private func saveSortOption(_ option: SortOption) {
        UserDefaults.standard.set(option.rawValue, forKey: UserDefaultsKeys.sortOption)
    }
    
    private func applySavedSortOption() {
        switch currentSortOption {
        case .name:
            sortByName()
        case .rating:
            sortByRating()
        case .cancel:
            view?.displayUsers(users)
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
