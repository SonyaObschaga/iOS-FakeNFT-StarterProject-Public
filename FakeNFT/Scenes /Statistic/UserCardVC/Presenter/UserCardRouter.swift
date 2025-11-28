import UIKit

// MARK: - UserCardRouter
final class UserCardRouter: UserCardRouterProtocol {
    
    // MARK: - Property
    weak var viewController: UIViewController?
    
    // MARK: - Private Property
//    private var userCollectionPresenter: UserCollectionPresenterProtocol
    
    // MARK: - Initialization
//    init(userCollectionPresenter: UserCollectionPresenterProtocol) {
//        self.userCollectionPresenter = userCollectionPresenter
//    }
    
    // MARK: - Public Interface
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
    
    func showUserCollection() {
        /// конфиг
        let userCollectionConfigurator = UserCollectionConfigurator()
        let userCollectionViewController = userCollectionConfigurator.configure()
        
        viewController?.navigationController?.pushViewController(userCollectionViewController, animated: true)
    }
}
