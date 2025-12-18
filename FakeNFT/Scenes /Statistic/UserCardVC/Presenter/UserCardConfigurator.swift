import UIKit

// MARK: - UserCardConfigurator
final class UserCardConfigurator {
    
    // MARK: - Private Property
    private let userService: UserServiceProtocol
    private let collectionService: CollectionService
    
    // MARK: - Initialization
    init(userService: UserServiceProtocol, collectionService: CollectionService) {
        self.userService = userService
        self.collectionService = collectionService
    }
    
    // MARK: - Configure
    func configure(with user: User) -> UIViewController {
        let presenter = UserCardPresenter(user: user, userService: userService)
        let viewController = UserCardViewController(presenter: presenter)
        let router = UserCardRouter(collectionService: collectionService)
        
        presenter.view = viewController
        presenter.router = router
        router.viewController = viewController
        
        return viewController
    }
}
