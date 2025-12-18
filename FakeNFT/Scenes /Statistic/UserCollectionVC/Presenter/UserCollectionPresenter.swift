import UIKit

// MARK: - UserCollectionPresenter
final class UserCollectionPresenter: UserCollectionPresenterProtocol {
    
    // MARK: - Properties
    weak var view: UserCollectionViewProtocol?
    var router: UserCollectionRouterProtocol?
    
    private let collectionService: CollectionService
    private var items: [UserCollectionNftItem] = []
    
    // MARK: - Initialization
    init(collectionService: CollectionService) {
        self.collectionService = collectionService
    }
    
    // MARK: - Public Interface
    func viewDidLoad() {
        loadUserCollection()
    }
    
    func backwardButtonTapped() {
        router?.dismiss()
    }
    
    var numberOfItems: Int {
        items.count
    }
    
    func item(at index: Int) -> UserCollectionNftItem {
        guard index < items.count else {
            return UserCollectionNftItem(
                imageURL: nil,
                name: "",
                rating: 0,
                price: "",
                isLiked: false
            )
        }
        return items[index]
    }
    
    // MARK: - Private Methods
    private func loadUserCollection() {
        view?.showLoading()
        
        collectionService.fetchCollections { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.view?.hideLoading()
                
                switch result {
                case .success(let collectionItems):
                    self.items = collectionItems.map { response in
                        let imageURL = response.images.first
                        let priceString = String(format: "%.2f ETH", response.price)
                        
                        return UserCollectionNftItem(
                            imageURL: imageURL,
                            name: response.name,
                            rating: response.rating,
                            price: priceString,
                            isLiked: false
                        )
                    }
                    self.view?.displayUserCollection(self.items)
                    
                case .failure(let error):
                    let errorMessage = self.makeErrorMessage(from: error)
                    self.view?.showError(
                        message: errorMessage,
                        retryHandler: { [weak self] in
                            self?.loadUserCollection()
                        }
                    )
                }
            }
        }
    }
    
    private func makeErrorMessage(from error: Error) -> String {
        if let networkError = error as? NetworkClientError {
            switch networkError {
            case .httpStatusCode(let code):
                return "Ошибка сети: \(code)"
            case .parsingError:
                return "Ошибка обработки данных"
            case .urlRequestError, .urlSessionError:
                return "Ошибка соединения"
            }
        }
        return "Не удалось загрузить коллекции"
    }
}
