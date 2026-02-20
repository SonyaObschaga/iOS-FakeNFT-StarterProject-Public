import UIKit

// MARK: - UserCardPresenter
final class UserCardPresenter: UserCardPresenterProtocol {
    
    // MARK: - Properties
    weak var view: UserCardViewProtocol?
    var router: UserCardRouterProtocol?
    let user: User
    
    // MARK: -Private Property
    private let userService: UserServiceProtocol?
    
    // MARK: - Initialization
    init(user: User, userService: UserServiceProtocol) {
        self.user = user
        self.userService = userService
    }
    
    // MARK: - Public Interface
    func viewDidLoad() {
        view?.displayUser(user)
    }
    
    func backwardButtonTapped() {
        router?.dismiss()
    }
    
    func webViewButtonTapped() {
        guard let websiteString = user.website,
              !websiteString.isEmpty else {
            return
        }
        
        var urlString = websiteString
        if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
            urlString = "https://" + urlString
        }
        
        router?.showWebView(urlString: urlString)
    }
    
    func collectionButtonTapped() {
        router?.showUserCollection()
    }
}
