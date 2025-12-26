// MARK: - Router Protocol
protocol UserCollectionRouterProtocol {
    func dismiss()
}

// MARK: - Presenter Protocol
protocol UserCollectionPresenterProtocol {
    func viewDidLoad()
    func backwardButtonTapped()
    
    var numberOfItems: Int { get }
    func item(at index: Int) -> UserCollectionNftItem
    func toggleLikeStatus(at index: Int)
    func toggleCartStatus(at index: Int)
}

// MARK: - View Protocol
protocol UserCollectionViewProtocol: AnyObject {
    func displayUserCollection(_ items: [UserCollectionNftItem])
    func showError(message: String, retryHandler: (() -> Void)?)
    func showLoading()
    func hideLoading()
    func updateItem(at: Int, with: UserCollectionNftItem)
}
