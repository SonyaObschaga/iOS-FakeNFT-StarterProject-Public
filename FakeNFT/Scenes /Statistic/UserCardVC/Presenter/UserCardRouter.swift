import UIKit

// MARK: - UserCardRouter
final class UserCardRouter: UserCardRouterProtocol {
    
    // MARK: - Property
    weak var viewController: UIViewController?
    
    // MARK: - Public Interface
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
    
    func showUserCollection() {
        let userCollectionConfigurator = UserCollectionConfigurator()
        let userCollectionViewController = userCollectionConfigurator.configure()
        
        viewController?.navigationController?.pushViewController(userCollectionViewController, animated: true)
    }
    
    func showWebView(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let webViewController = WebViewController(url: url)
        viewController?.navigationController?.pushViewController(webViewController, animated: true)
    }
}
