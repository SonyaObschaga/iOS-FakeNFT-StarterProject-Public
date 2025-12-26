import UIKit

// MARK: - UserCardConfigurator
final class UserCardConfigurator {
    
    // MARK: - Private Properties
    private let userService: UserServiceProtocol
    private let nftService: NftService

    private let orderService: OrderService
    
    // MARK: - Initialization
    init(userService: UserServiceProtocol, nftService: NftService, orderService: OrderService) {
        self.userService = userService
        self.nftService = nftService
        self.orderService = orderService
    }
    
    // MARK: - Configure
    func configure(with user: User) -> UIViewController {
        let presenter = UserCardPresenter(user: user, userService: userService)
        let viewController = UserCardViewController(presenter: presenter)
        let router = UserCardRouter(
            nftService: nftService,
            userService: userService,
            orderService: orderService,
            userId: user.id
        )
        
        presenter.view = viewController
        presenter.router = router
        router.viewController = viewController
        
        return viewController
    }
}
