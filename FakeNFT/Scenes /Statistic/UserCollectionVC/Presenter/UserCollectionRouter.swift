import UIKit

// MARK: - UserCollectionRouter
final class UserCollectionRouter: UserCollectionRouterProtocol {
    
    // MARK: -  Property
    weak var viewController: UIViewController?
    
    // MARK: - Private Property
    private var userCollectionPresenter: UserCollectionPresenterProtocol
    
    // MARK: - Initialization
    init(userCollectionPresenter: UserCollectionPresenterProtocol) {
        self.userCollectionPresenter = userCollectionPresenter
    }
    
    // MARK: - Piblic Interface
    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
