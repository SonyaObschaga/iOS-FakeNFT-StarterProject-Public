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
                isLiked: false,
                id: ""
            )
        }
        return items[index]
    }
    
    func toggleLikeStatus(at index: Int) {
        let nftId = items[index].id
        let previousState = items[index].isLiked
        let newState = !previousState
        
        items[index].isLiked = newState
        view?.updateItem(at: index, with: items[index])
        
        nftService.updateLikeStatus(for: nftId, isLiked: newState) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("✅ Like updated")
                    
                case .failure(let error):
                    self.items[index].isLiked = previousState
                    self.view?.updateItem(at: index, with: self.items[index])
                    self.view?.showError(message: "Не удалось обновить лайк - \(error)", retryHandler: nil)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func loadUserCollection() {
        view?.showLoading()
        
        let dispatchGroup = DispatchGroup()
        var userResponse: UserResponse?
        var profileResponse: ProfileResponse?
        var userError: Error?
        
        dispatchGroup.enter()
        userService.fetchUserById(userId) { result in
            switch result {
            case .success(let response):
                userResponse = response
            case .failure(let error):
                userError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        userService.fetchProfile(userId: "1") { result in
            switch result {
            case .success(let response):
                profileResponse = response
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            if let userResponse = userResponse {
                let nftIds = userResponse.nfts
                let likedNftIds = Set(profileResponse?.likes ?? [])
                
                guard !nftIds.isEmpty else {
                    self.view?.hideLoading()
                    self.items = []
                    self.view?.displayUserCollection(self.items)
                    return
                }
                
                self.loadNfts(nftIds: nftIds, likedNftIds: likedNftIds)
            } else if let error = userError {
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
    
    private func loadNfts(nftIds: [String], likedNftIds: Set<String>) {
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
                    let name = nft.name /*?? "NFT #\(nft.id)"*/
                    let rating = nft.rating /*?? 0*/
                    let priceString: String
                    let id = nft.id
                    let isLiked = likedNftIds.contains(id)
                    let price = String(format: "%.2f ETH", nft.price)
                    
                    let item = UserCollectionNftItem(
                        imageURL: imageURL,
                        name: name,
                        rating: rating,
                        price: price,
                        isLiked: isLiked,
                        id: id
                    )
                    
                    lock.lock()
                    loadedItems.append(item)
                    lock.unlock()
                    
                case .failure(let error):
                   assertionFailure(error.localizedDescription)
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
