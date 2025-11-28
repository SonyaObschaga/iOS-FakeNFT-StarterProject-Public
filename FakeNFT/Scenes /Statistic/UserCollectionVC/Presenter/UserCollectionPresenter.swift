import UIKit

// MARK: -
final class UserCollectionPresenter: UserCollectionPresenterProtocol {
    
    // MARK: - Property
    weak var view: UserCollectionViewProtocol?

    // MARK: -Private Property
    private var router: UserCollectionRouterProtocol?
    
    // MARK: - Initialization
//    init(router: UserCollectionRouterProtocol) {
//        self.router = router
//    }
    // MARK: - Public Interface
    func viewDidLoad() {
        
    }
    
    func backwardButtonTapped() {
        router?.dismiss()
    }
}
