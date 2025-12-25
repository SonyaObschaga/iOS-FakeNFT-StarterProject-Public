import UIKit

// MARK: - UserCollectionConfigurator
final class UserCollectionConfigurator {
    
    private let nftService: NftService
    private let userService: UserServiceProtocol
    
    init(nftService: NftService, userService: UserServiceProtocol) {
        self.nftService = nftService
        self.userService = userService
    }
    
    // MARK: - Configure
    func configure(userId: String) -> UIViewController {
        let presenter = UserCollectionPresenter(
            nftService: nftService,
            userService: userService,
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
