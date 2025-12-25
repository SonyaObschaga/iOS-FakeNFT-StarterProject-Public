import UIKit

// MARK: - StatisticPresenter
final class StatisticPresenter: StatisticPresenterProtocol {
    
    // MARK: - Property
    weak var view: StatisticViewProtocol?
    
    // MARK: - Private Properties
    private let userService: UserServiceProtocol
    private var users: [User] = []
    private let router: StatisticRouterProtocol
    private var currentSortOption: SortOption = .rating {
        didSet {
            saveSortingPreference(currentSortOption)
        }
    }
    
    // MARK: - UserDefaults Key
    private enum UserDefaultsKeys {
        static let selectedSortOption = "selectedSortOption"
    }
    
    // MARK: - Initialization
    init(
        view: StatisticViewProtocol? = nil,
        userService: UserServiceProtocol,
        router: StatisticRouterProtocol
    ) {
        self.view = view
        self.userService = userService
        self.router = router
        
        restoreSortingPreference()
    }
    
    // MARK: - Public Interface
    func viewDidLoad() {
        applySavedSorting()
        loadUsers()
    }
    
    func didSelectUser(at index: Int) {
        guard users.indices.contains(index) else { return }
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
        saveSortingPreference(option)
        applySorting(option)
    }
    
    // MARK: - Private Methods
    private func loadUsers() {
        view?.showLoading()
        
        userService.fetchUsers { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self?.view?.hideLoading()
                    self?.users = users
                    self?.applySavedSorting()
                case .failure(let error):
                    self?.view?.hideLoading()
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
    
    private func saveSortingPreference(_ option: SortOption) {
        UserDefaults.standard.set(option.rawValue, forKey: UserDefaultsKeys.selectedSortOption)
    }
    
    private func restoreSortingPreference() {
        if let savedOption = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedSortOption),
           let option = SortOption(rawValue: savedOption) {
            currentSortOption = option
        } else {
            currentSortOption = .rating
            saveSortingPreference(currentSortOption)
        }
    }
    
    private func applySavedSorting() {
        guard let savedOption = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedSortOption),
              let option = SortOption(rawValue: savedOption) else {
            view?.displayUsers(users)
            return
        }
        
        applySorting(option)
    }
    
    private func applySorting(_ option: SortOption) {
        switch option {
        case .name:
            sortByName()
        case .rating:
            sortByRating()
        case .cancel:
            break
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
