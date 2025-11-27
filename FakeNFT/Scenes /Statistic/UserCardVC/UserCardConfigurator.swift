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
        let presenter = UserCardPresenter(user: user, userService: userService)
        let viewController = UserCardViewController(presenter: presenter)
        let router = UserCardRouter()
        
        presenter.view = viewController
        presenter.router = router
        router.viewController = viewController
        
        return viewController
    }
}
