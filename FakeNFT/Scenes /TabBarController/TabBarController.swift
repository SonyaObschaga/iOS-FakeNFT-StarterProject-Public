import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly?

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 1
    )
    
    private let profileTabBarItem = UITabBarItem(
        title: "Профиль",
        image: UIImage(resource: .profileTabBar),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let servicesAssembly = servicesAssembly else {
            assertionFailure("servicesAssembly must be set before viewDidLoad")
            return
        }
        
        let profilePresenter = ProfilePresenter(servicesAssembly: servicesAssembly)
        let profileViewController = ProfileViewController()
        profileViewController.configure(profilePresenter)
        
        profileViewController.tabBarItem = profileTabBarItem
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)

        let catalogController = CatalogViewController(
            servicesAssembly: servicesAssembly
        )

        let presenter = CatalogPresenter(
            collectionsService: servicesAssembly.collectionsService
        )
        presenter.view = catalogController
        catalogController.presenter = presenter

        catalogController.tabBarItem = catalogTabBarItem

        let navigationController = UINavigationController(
            rootViewController: catalogController
        )
        navigationController.tabBarItem = catalogTabBarItem
        
        viewControllers = [
            profileNavigationController,
            navigationController
        ]
        
        selectedIndex = 0

        
        view.backgroundColor = .systemBackground
        tabBar.backgroundColor = .systemBackground
    }
}
