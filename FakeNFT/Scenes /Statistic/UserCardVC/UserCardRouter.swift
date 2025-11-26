import UIKit

// MARK: - UserCardRouter
final class UserCardRouter: UserCardRouterProtocol {
    
    // MARK: - Property
    weak var viewController: UIViewController?
    
    // MARK: - Public Interface
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
