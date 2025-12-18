import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly? {
        didSet {
            if isViewLoaded {
                setupViewControllers()
            }
        }
    }

    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.Cart", comment: ""),
        image: UIImage(resource: .cartTabBar),
        tag: 2
    )
  
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 1
    )
    
    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(resource: .profileTabBar),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundPrimary
        tabBar.backgroundColor = .backgroundPrimary
        
        if servicesAssembly != nil {
            setupViewControllers()
        }
    }
    
    private func setupViewControllers() {
        guard let servicesAssembly = servicesAssembly else {
            return
        }
        
      // MARK: - Profile
      
        let profilePresenter = ProfilePresenter(servicesAssembly: servicesAssembly)
        let profileViewController = ProfileViewController()
        profileViewController.configure(profilePresenter)
        
        profileViewController.tabBarItem = profileTabBarItem
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)

      // MARK: - Cart
      
        let cartController = CartViewController()
        cartController.tabBarItem = cartTabBarItem
      
      // MARK: - Catalog
      
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
        
      // MARK: - Add views to tab bar
      
        viewControllers = [
            profileNavigationController,
            navigationController,
            cartController
        ]
        
        selectedIndex = 0
    }
}
