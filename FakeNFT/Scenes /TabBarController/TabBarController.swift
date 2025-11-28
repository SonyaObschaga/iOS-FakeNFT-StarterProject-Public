import UIKit

final class TabBarController: UITabBarController {

    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let profileTabBarItem = UITabBarItem(
        title: "Профиль",
        //image: UIImage(named: "Profile"),
        image: UIImage(resource: .profileTabBar),
        tag: 0
    )

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let profileController = ProfileViewController()
        profileController.tabBarItem = profileTabBarItem
        let profileNavigationController = UINavigationController(rootViewController: profileController)
        
        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [
            profileNavigationController,
            catalogController
        ]
        selectedIndex = 0

        view.backgroundColor = .systemBackground
    }
}
//final class TabBarController: UITabBarController {
//
//    var servicesAssembly: ServicesAssembly!
//
//    private let catalogTabBarItem = UITabBarItem(
//        title: NSLocalizedString("Tab.catalog", comment: ""),
//        image: UIImage(systemName: "square.stack.3d.up.fill"),
//        tag: 0
//    )
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let catalogController = TestCatalogViewController(
//            servicesAssembly: servicesAssembly
//        )
//        catalogController.tabBarItem = catalogTabBarItem
//
//        viewControllers = [catalogController]
//
//        view.backgroundColor = .systemBackground
//    }
//}
