// MARK: - UserCardViewProtocol
protocol UserCardViewProtocol: AnyObject {
    func displayUser(_ user: User)
}

// MARK: - UserCardPresenterProtocol
protocol UserCardPresenterProtocol {
    func viewDidLoad()
    func backwardButtonTapped()
    func webViewButtonTapped()
}

// MARK: - UserCardRouterProtocol
protocol UserCardRouterProtocol {
    func dismiss()
}
