import UIKit

// MARK: - UserCollectionConfigurator
final class UserCollectionConfigurator {
    
    private let collectionService: CollectionService
    
    init(collectionService: CollectionService) {
        self.collectionService = collectionService
    }
    
    // MARK: - Configure
    func configure() -> UIViewController {
        let presenter = UserCollectionPresenter(collectionService: collectionService)
        let router = UserCollectionRouter(userCollectionPresenter: presenter)
        
        let viewController = UserCollectionViewController(presenter: presenter)
        
        presenter.view = viewController
        presenter.router = router
        router.viewController = viewController
        
        return viewController
    }
}
