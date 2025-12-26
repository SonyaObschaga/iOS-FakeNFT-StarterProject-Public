import Foundation

final class NFTPresenter: NFTPresenterProtocol {

    // MARK: - Properties
    let agent: FakeNFTModelServiceAgentProtocol
    private let isFavoritesPresenter: Bool
    private var myNFTsLikedObserverAdded: Bool = false
    weak var view: NFTViewProtocol?

    private var notificationObserver: NSObjectProtocol?
    private var nftLikedNotificationObserver: NSObjectProtocol?

    // MARK: - Sorting
    private var activeSortField: UserNFTCollectionSortField {
        get {
            if let savedValue = UserDefaults.standard.string(forKey: "activeSortField") {
                switch savedValue {
                case "byPrice": return .byPrice
                case "byName": return .byName
                default: return .byRating
                }
            }
            return .byRating
        }
        set {
            let rawValue: String
            switch newValue {
            case .byPrice: rawValue = "byPrice"
            case .byName: rawValue = "byName"
            case .byRating: rawValue = "byRating"
            }
            UserDefaults.standard.set(rawValue, forKey: "activeSortField")
        }
    }

    // MARK: - Init
    init(servicesAssembly: ServicesAssembly, isFavoritesPresenter: Bool) {
        self.isFavoritesPresenter = isFavoritesPresenter
        self.agent = servicesAssembly.modelServiceAgent
        addObserver()
        addMyNFTLikedObserver()
    }

    deinit {
        removeObserver()
    }

    // MARK: - Notification
    private func addObserver() {
        let notificationName = isFavoritesPresenter
            ? FakeNFTModelServicesNotifications.profileLikedNTFsLoadedNotification
            : FakeNFTModelServicesNotifications.profileNTFsLoadedNotification

        notificationObserver = NotificationCenter.default.addObserver(
            forName: notificationName,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleNotification(notification)
        }
    }
    
    func addMyNFTLikedObserver() {
        if self.myNFTsLikedObserverAdded == true { return }
        let notificationName = FakeNFTModelServicesNotifications.likedNFTSavedNotification
        nftLikedNotificationObserver = NotificationCenter.default.addObserver(
            forName: notificationName,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleLikedNFTSavedNotification(notification)
        }
        self.myNFTsLikedObserverAdded = true
    }

    private func removeObserver() {
        if let observer = notificationObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = nftLikedNotificationObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func handleNotification(_ notification: Notification) {
        view?.hideLoading()

        guard let userInfo = notification.userInfo,
              let result = userInfo["Result"] as? Result<[NFTModel], Error> else {
            print("Invalid notification data")
            return
        }

        switch result {
        case .success(let nfts):
            let sortedNFTs = getSortedUserNFTs(activeSortField, useUserDefaults: true)
            if isFavoritesPresenter {
                view?.updateNFTs(nfts: [], likedNFTs: nfts)
            } else {
                view?.updateNFTs(nfts: sortedNFTs, likedNFTs: [])
            }
        case .failure(let error):
            view?.errorDetected(error: error)
        }
    }
    
    private func handleLikedNFTSavedNotification(_ notification: Notification) {
        view?.hideLoading()

        guard let userInfo = notification.userInfo,
              let result = userInfo["Result"] as? Result<ProfileDto, Error> else {
            print("Invalid notification data")
            return
        }

        switch result {
        case .success(_):
            if isFavoritesPresenter {
                let likedNFTs = agent.likedNfts
                view?.updateNFTs(nfts: [], likedNFTs: likedNFTs)
                print("Successfully saved favorites liked NFTs, Count = \(likedNFTs.count)")
            } else {
                let sortedNFTs = getSortedUserNFTs(activeSortField, useUserDefaults: true)
                view?.updateNFTs(nfts: sortedNFTs, likedNFTs: [])
                print("Successfully saved my liked NFTs, Count = \(sortedNFTs.count)")
            }
        case .failure(let error):
            view?.errorDetected(error: error)
        }
    }

    // MARK: - Public Methods
    func viewDidLoad() {
        if isFavoritesPresenter {
            if agent.fetchProfileLikedNFTs() == false {
                view?.updateNFTs(nfts: [], likedNFTs: [])
            }
        } else {
            agent.fetchProfileMyNFTs()
        }
    }

    func sortNFTs(by sortField: UserNFTCollectionSortField) {
        activeSortField = sortField
        let sortedNFTs = getSortedUserNFTs(sortField, useUserDefaults: false)
        if isFavoritesPresenter {
            // Сортировка для likedNFTs (по желанию можно не сортировать)
            view?.updateNFTs(nfts: [], likedNFTs: sortedNFTs)
        } else {
            view?.updateNFTs(nfts: sortedNFTs, likedNFTs: [])
        }
    }

    func getSortedUserNFTs(_ sortField: UserNFTCollectionSortField, useUserDefaults: Bool) -> [NFTModel] {
        var field = sortField
        if useUserDefaults {
            field = activeSortField
        } else {
            activeSortField = sortField
        }

        switch field {
        case .byName:
            return agent.myNfts.sorted { $0.nftName < $1.nftName }
        case .byPrice:
            return agent.myNfts.sorted { $0.price > $1.price }
        case .byRating:
            return agent.myNfts.sorted {
                if let r0 = $0.rating, let r1 = $1.rating {
                    return r0 > r1 || (r0 == r1 && $0.nftName < $1.nftName)
                }
                return false
            }
        }
    }
    
    func toggleLike(nftId: String) {
        // Получаем текущее состояние
        let isCurrentlyLiked = agent.profile.likes.contains(nftId)

        if isFavoritesPresenter && agent.likedNFTsCount == 1 {
            let errorModel = lastLikedNFTCantBeDeletedErrorModel()
            view?.showError(errorModel)
            return 
        }
        
        // Переключаем
        agent.toggleNFTLikedFlag(nftId, !isCurrentlyLiked)
        
    }
    
    private func lastLikedNFTCantBeDeletedErrorModel() -> ErrorModel {
        let message: String = NSLocalizedString("NFT.lastFavoriteCannotBeDeleted", comment: "")
        
        let actionText = NSLocalizedString("Common.ok", comment: "")
        return ErrorModel(message: message, actionText: actionText) {
        }
    }
    
}
