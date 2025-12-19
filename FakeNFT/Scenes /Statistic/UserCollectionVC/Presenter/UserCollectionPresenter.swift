import UIKit

// MARK: - UserCollectionPresenter
final class UserCollectionPresenter: UserCollectionPresenterProtocol {
    
    // MARK: - Properties
    weak var view: UserCollectionViewProtocol?
    var router: UserCollectionRouterProtocol?
    
    private let nftService: NftService
    private let userService: UserServiceProtocol
    private let userId: String
    private var items: [UserCollectionNftItem] = []
    
    // MARK: - Initialization
    init(nftService: NftService, userService: UserServiceProtocol, userId: String) {
        self.nftService = nftService
        self.userService = userService
        self.userId = userId
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
        
        userService.fetchUserById(userId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userResponse):
                let nftIds = userResponse.nfts
                
                guard !nftIds.isEmpty else {
                    DispatchQueue.main.async {
                        self.view?.hideLoading()
                        self.items = []
                        self.view?.displayUserCollection(self.items)
                    }
                    return
                }
                
                self.loadNfts(nftIds: nftIds)
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.hideLoading()
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
    
    private func loadNfts(nftIds: [String]) {
        let dispatchGroup = DispatchGroup()
        var loadedItems: [UserCollectionNftItem] = []
        let lock = NSLock()
        
        for nftId in nftIds {
            dispatchGroup.enter()
            nftService.loadNft(id: nftId) { result in
                defer { dispatchGroup.leave() }
                
                switch result {
                case .success(let nft):
                    let imageURL = nft.images.first?.absoluteString
                    let name = nft.name ?? "NFT #\(nft.id)"
                    let rating = nft.rating ?? 0
                    let priceString: String
                    if let price = nft.price {
                        priceString = String(format: "%.2f ETH", price)
                    } else {
                        priceString = "—"
                    }
                    
                    let item = UserCollectionNftItem(
                        imageURL: imageURL,
                        name: name,
                        rating: rating,
                        price: priceString,
                        isLiked: false
                    )
                    
                    lock.lock()
                    loadedItems.append(item)
                    lock.unlock()
                    
                case .failure(let error):
                    print("⚠️ Failed to load NFT \(nftId): \(error.localizedDescription)")
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view?.hideLoading()
            self.items = loadedItems
            self.view?.displayUserCollection(self.items)
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
