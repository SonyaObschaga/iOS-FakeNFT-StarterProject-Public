
// MARK: - Models
// MARK: User
struct User {
    let name: String
    let score: Int
    let position: Int
}

// MARK: Sort Options
enum SortOption: String, CaseIterable {
    case name = "По имени"
    case rating = "По рейтингу"
    case cancel = "Закрыть"
    
    var isCancel: Bool {
        return self == .cancel
    }
}

// MARK: - View Protocol
protocol StatisticViewProtocol: AnyObject {
    func displayUsers(_ users: [User])
    func showLoading()
    func hideLoading()
    func showError(message: String, retryHandler: (() -> Void)?)
    func showSortOptions()
}

// MARK: - Presenter Protocol
protocol StatisticPresenterProtocol {
    func viewDidLoad()
    func didSelectUser(at index: Int)
    func didTapSortButton()
    func didSelectSortOption(_ option: SortOption)
    
    var numberOfUsers: Int { get }
    func user(at index: Int) -> User
}

// MARK: - Service Protocol
protocol UserServiceProtocol {
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void)
}

// MARK: - Router Protocol
protocol StatisticRouterProtocol {
    func showUserCard(_ user: User)
}
