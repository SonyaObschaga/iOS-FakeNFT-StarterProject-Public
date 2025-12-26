// MARK: - StatisticAssembly
final class StatisticAssembly {
    
    // MARK: - Private Property
    private let servicesAssembly: ServicesAssembly
    
    // MARK: - Initialization
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: - Public Interface
    func makeStatisticViewController() -> StatisticViewController {
        let router = StatisticRouter(servicesAssembly: servicesAssembly)
        let presenter = StatisticPresenter(userService: servicesAssembly.userService, router: router)
        let viewController = StatisticViewController(presenter: presenter)

        presenter.view = viewController
        router.viewController = viewController
        return viewController
    }
}
