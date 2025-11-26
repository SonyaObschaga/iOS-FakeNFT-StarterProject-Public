// MARK: - UserCardViewProtocol
protocol UserCardViewProtocol: AnyObject {
    func displayUser(_ user: User)
}

// MARK: - UserCardPresenterProtocol
protocol UserCardPresenterProtocol {
    func viewDidLoad()
    func backwardButtonTapped()
}

// MARK: - UserCardRouterProtocol
protocol UserCardRouterProtocol {
    func dismiss()
}
