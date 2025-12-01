import Foundation

// MARK: - View Protocol
protocol UserCardViewProtocol: AnyObject {
    func displayUser(_ user: User)
}

// MARK: - Presenter Protocol
protocol UserCardPresenterProtocol {
    func viewDidLoad()
    func backwardButtonTapped()
    func webViewButtonTapped()
    func collectionButtonTapped()
}

// MARK: - Router Protocol
protocol UserCardRouterProtocol {
    func dismiss()
    func showUserCollection()
    func showWebView(url: URL)
}
