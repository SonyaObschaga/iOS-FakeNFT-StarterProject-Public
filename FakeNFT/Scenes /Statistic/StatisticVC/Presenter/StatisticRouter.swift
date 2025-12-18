import UIKit

// MARK: - StatisticRouter
final class StatisticRouter: StatisticRouterProtocol {
    
    // MARK: - Property
    weak var viewController: UIViewController?
    
    // MARK: -Private Property
    private let servicesAssembly: ServicesAssembly
    
    // MARK: - Initialization
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: - Public Interface
    func showUserCard(_ user: User) {
        let userCardConfigurator = UserCardConfigurator(
            userService: servicesAssembly.userService,
            collectionService: servicesAssembly.collectionService
        )
        let userCardController = userCardConfigurator.configure(with: user)
        
        let navigationController = UINavigationController(rootViewController: userCardController)
        navigationController.modalPresentationStyle = .fullScreen
        
        viewController?.present(navigationController, animated: true)
    }
}
