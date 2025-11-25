// MARK: - StatisticAssembly
final class StatisticAssembly {
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func makeStatisticViewController() -> StatisticViewController {
        let presenter = StatisticPresenter(userService: servicesAssembly.userService)
        
        let viewController = StatisticViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
