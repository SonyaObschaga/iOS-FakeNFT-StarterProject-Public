// MARK: - View Protocol
protocol StatisticViewProtocol: AnyObject {
    func displayUsers(_ users: [User])
    func showError(message: String, retryHandler: (() -> Void)?)
    func showSortOptions()
    func showLoading()
    func hideLoading()
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
    func fetchUserById(_ id: String, completion: @escaping (Result<UserResponse, Error>) -> Void)
    func fetchProfile(userId: String, completion: @escaping (Result<ProfileResponse, Error>) -> Void)
}

// MARK: - Router Protocol
protocol StatisticRouterProtocol {
    func showUserCard(_ user: User)
}
