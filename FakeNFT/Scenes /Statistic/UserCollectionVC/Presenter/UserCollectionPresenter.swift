import UIKit

// MARK: - UserCollectionPresenter
final class UserCollectionPresenter: UserCollectionPresenterProtocol {
    
    // MARK: - Property
    weak var view: UserCollectionViewProtocol?
    var router: UserCollectionRouterProtocol?
    
    // MARK: - Public Interface
    func viewDidLoad() {
        view?.displayUserCollection()
    }
    
    func backwardButtonTapped() {
        router?.dismiss()
    }
}
