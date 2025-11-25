import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly!
    private lazy var statisticAssembly = StatisticAssembly(servicesAssembly: servicesAssembly)
    
    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 0
    )
    
    private let statisticTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistic", comment: ""),
        image: UIImage(systemName: "flag.2.crossed.fill"),
        tag: 3
        )

    override func viewDidLoad() {
        super.viewDidLoad()

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )
        
        let statisticController = statisticAssembly.makeStatisticViewController()
        statisticController.tabBarItem = statisticTabBarItem
        catalogController.tabBarItem = catalogTabBarItem

        viewControllers = [catalogController, statisticController]

        view.backgroundColor = .systemBackground
    }
}
