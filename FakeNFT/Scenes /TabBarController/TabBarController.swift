import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!

    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(resource: .cartTabBar),
        tag: 0
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        let cartController = CartViewController()
        cartController.tabBarItem = cartTabBarItem

        viewControllers = [cartController]

        view.backgroundColor = .backgroundSecondary
    }
}
