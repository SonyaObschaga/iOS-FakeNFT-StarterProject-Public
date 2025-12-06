//
//  NFTPresenter.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 30.11.2025.
//

import Foundation

internal enum SortOption: String {
    case `default` = "default"
    case byName = "byName"
    case byPrice = "byPrice"
    case byRating = "byRating"
}

final class NFTPresenter: NFTPresenterProtocol {
    
    let agent: FakeNFTModelServiceAgentProtocol
    //let notifications: FakeNFTServiceAgentNotificationsProtocol
    let isFavoritesPresenter: Bool
    init(servicesAssembly: ServicesAssembly, _ isFavoritesPresenter: Bool) {
        self.isFavoritesPresenter = isFavoritesPresenter
        agent = servicesAssembly.modelServiceAgent
        //notifications = agent as FakeNFTServiceAgentNotificationsProtocol
        addObservers()
    }

    private var profileNTFsLoadedNotification: NSObjectProtocol?
    private var profileLikedNTFsLoadedNotification: NSObjectProtocol?

    private func addObservers() {
        profileNTFsLoadedNotification =
        NotificationCenter.default.addObserver(
            forName: FakeNFTModelServicesNotifications.profileNTFsLoadedNotification, // agent.profileNTFsLoadedNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            self.handleProfileNTFsLoadedNotification(notification: notification)
        }
        
        profileLikedNTFsLoadedNotification =
        NotificationCenter.default.addObserver(
            forName: FakeNFTModelServicesNotifications.profileLikedNTFsLoadedNotification, // agent.profileNTFsLoadedNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            self.handleProfileLikedNTFsLoadedNotification(notification: notification)
        }
    }

    private func handleProfileNTFsLoadedNotification(notification: Notification) {
        self.view?.hideLoading()
        
        // Extract the result and profile from the userInfo dictionary
        if let userInfo = notification.userInfo,
           let result = userInfo["Result"] as? Result<[NFTModel], Error> {
            // Handle the result
            switch result {
            case .success(let nfts):
                if !self.isFavoritesPresenter {
                    view?.updateNFTs(nfts: nfts, likedNFTs: [])
                    print("Successfully loaded \(nfts.count) my NTFs")
               }
                else
                {
                    view?.updateNFTs(nfts: [], likedNFTs: nfts)
                    print("Successfully loaded \(nfts.count) liked NTFs")
                }
            case .failure(let error):
                view?.errorDetected(error: error)
            }
        } else {
            print("Invalid notification data")
        }
    }
    private func handleProfileLikedNTFsLoadedNotification(notification: Notification) {
        self.view?.hideLoading()
        
        // Extract the result and profile from the userInfo dictionary
        if let userInfo = notification.userInfo,
           let result = userInfo["Result"] as? Result<[NFTModel], Error> {
            // Handle the result
            switch result {
            case .success(let nfts):
                if !self.isFavoritesPresenter {
                    view?.updateNFTs(nfts: nfts, likedNFTs: [])
                    print("Successfully loaded \(nfts.count) my NTFs")
               }
                else
                {
                    view?.updateNFTs(nfts: [], likedNFTs: nfts)
                    print("Successfully loaded \(nfts.count) liked NTFs")
                }
 
            case .failure(let error):
                view?.errorDetected(error: error)
            }
        } else {
            print("Invalid notification data")
        }
    }

    weak var view: NFTViewProtocol?
    private  func updateNFTs(nfts: [NFTModel], likedNFTs: [NFTModel]) {
        view?.updateNFTs(nfts: nfts, likedNFTs: likedNFTs)
    }

    func viewDidLoad() {

        if !self.isFavoritesPresenter {
            agent.fetchProfileMyNFTs()
        } else {
            agent.fetchProfileLikedNFTs()
        }
    }

    func sortNFTs(by sortField: UserNFTCollectionSortField) {
        let nfts = getSortedUserNFTs(sortField)
        view?.updateNFTs(nfts: nfts, likedNFTs: [])
    }
    
    func getSortedUserNFTs(_ sortField: UserNFTCollectionSortField) -> [NFTModel] {
        switch sortField {
        case .byName:
            return agent.MyNfts.sorted { $0.nftName < $1.nftName }
        case .byPrice:
            return agent.MyNfts.sorted { ($0.price) < ($1.price) }
        case .byRating:
            return agent.MyNfts.sorted {
                if let r0 = $0.rating, let r1 = $1.rating {
                    return r0 < r1 || (r0 == r1 && ($0.name < $1.name))
                }
                return false
            }
        }
    }
  

}
