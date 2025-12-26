import UIKit

// MARK: - UserCollectionConfigurator
final class UserCollectionConfigurator {
    
    private let nftService: NftService
    private let userService: UserServiceProtocol
    private let orderService: OrderService
    
    init(nftService: NftService, userService: UserServiceProtocol, orderService: OrderService) {
        self.nftService = nftService
        self.userService = userService
        self.orderService = orderService
    }
    
    // MARK: - Configure
    func configure(userId: String) -> UIViewController {
        let presenter = UserCollectionPresenter(
            nftService: nftService,
            userService: userService,
            orderService: orderService,
            userId: userId
        )
        let router = UserCollectionRouter(userCollectionPresenter: presenter)
        
        let viewController = UserCollectionViewController(presenter: presenter)
        
        presenter.view = viewController
        presenter.router = router
        router.viewController = viewController
        
        return viewController
    }
}
