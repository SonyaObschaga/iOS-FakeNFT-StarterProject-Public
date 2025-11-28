// MARK: - Router Protocol
protocol UserCollectionRouterProtocol {
    func showUserCollection()
    func dismiss()
}

// MARK: - Presenter Protocol
protocol UserCollectionPresenterProtocol {
    func viewDidLoad()
    func backwardButtonTapped()
}

// MARK: - View Protocol
protocol UserCollectionViewProtocol: AnyObject {
    func displayUserCollection()
}
