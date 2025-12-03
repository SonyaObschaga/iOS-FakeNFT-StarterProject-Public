import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = CatalogViewController(
            servicesAssembly: servicesAssembly
        )
        
        let presenter = CatalogPresenter(
                collectionsService: servicesAssembly.collectionsService
            )
        presenter.view = catalogController
        catalogController.presenter = presenter
            
        catalogController.tabBarItem = catalogTabBarItem
        
        let navigationController = UINavigationController(rootViewController: catalogController)
        navigationController.tabBarItem = catalogTabBarItem
        viewControllers = [navigationController]

        view.backgroundColor = .systemBackground
        tabBar.backgroundColor = .systemBackground
    }
}
