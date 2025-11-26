import UIKit

// MARK: - UserCardConfigurator
final class UserCardConfigurator {
    
    // MARK: - Private Property
    private let userService: UserServiceProtocol
    
    // MARK: - Initialization
    init(userService: UserServiceProtocol) {
        self.userService = userService
    }
    
    // MARK: - Configure
    func configure(with user: User) -> UIViewController {
        let viewController = UserCardViewController()
        let presenter = UserCardPresenter(user: user, userService: userService)
        let router = UserCardRouter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.router = router
        router.viewController = viewController
        
        return viewController
    }
}
