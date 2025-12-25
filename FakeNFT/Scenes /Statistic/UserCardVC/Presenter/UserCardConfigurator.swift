import UIKit

// MARK: - UserCardConfigurator
final class UserCardConfigurator {
    
    // MARK: - Private Properties
    private let userService: UserServiceProtocol
    private let nftService: NftService
    
    // MARK: - Initialization
    init(userService: UserServiceProtocol, nftService: NftService) {
        self.userService = userService
        self.nftService = nftService
    }
    
    // MARK: - Configure
    func configure(with user: User) -> UIViewController {
        let presenter = UserCardPresenter(user: user, userService: userService)
        let viewController = UserCardViewController(presenter: presenter)
        let router = UserCardRouter(
            nftService: nftService,
            userService: userService,
            userId: user.id
        )
        
        presenter.view = viewController
        presenter.router = router
        router.viewController = viewController
        
        return viewController
    }
}
