import UIKit

final class UserCollectionConfigurator {
    
    func configure() -> UIViewController {
        let presenter = UserCollectionPresenter()
        let router = UserCollectionRouter(userCollectionPresenter: presenter)
        
        let viewController = UserCollectionViewController(presenter: presenter)
        
        presenter.view = viewController
        router.viewController = viewController
        
        return viewController
    }
}
