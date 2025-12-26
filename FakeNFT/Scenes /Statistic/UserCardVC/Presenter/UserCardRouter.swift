import UIKit

// MARK: - UserCardRouter
final class UserCardRouter: UserCardRouterProtocol {
    
    // MARK: - Property
    weak var viewController: UIViewController?
    
    // MARK: - Private Property
    private let nftService: NftService
    private let userService: UserServiceProtocol
    private let orderService: OrderService
    private let userId: String
    
    // MARK: - Initialization
    init(nftService: NftService, userService: UserServiceProtocol, orderService: OrderService, userId: String) {
        self.nftService = nftService
        self.userService = userService
        self.orderService = orderService
        self.userId = userId
    }
    
    // MARK: - Public Interface
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
    
    func showUserCollection() {
        let userCollectionConfigurator = UserCollectionConfigurator(
            nftService: nftService,
            userService: userService,
            orderService: orderService
        )
        let userCollectionViewController = userCollectionConfigurator.configure(userId: userId)
        
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
