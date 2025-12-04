//
//  NFTPresenter.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 30.11.2025.
//

import Foundation

final class NFTPresenter: NFTPresenterProtocol {
    
    let agent: FakeNFTModelServiceAgent
    let notifications: FakeNFTServiceAgentNotificationsProtocol
    let isFavoritesPresenter: Bool
    init(servicesAssembly: ServicesAssembly, _ isFavoritesPresenter: Bool) {
        self.isFavoritesPresenter = isFavoritesPresenter
        agent = servicesAssembly.modelServiceAgent
        notifications = agent as FakeNFTServiceAgentNotificationsProtocol
        addObservers()
    }
 
    //var profileLoadedNotification: Notification.Name { get }
    //var profileSavedNotification: Notification.Name { get }
    //var profileNTFsLoadedNotification: Notification.Name { get }

    private var profileNTFsLoadedNotification: NSObjectProtocol?

    private func addObservers() {
        profileNTFsLoadedNotification =
        NotificationCenter.default.addObserver(
            forName: agent.profileNTFsLoadedNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            self.handleProfileNTFsLoadedNotification(notification: notification)
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
                }
                else
                {
                    view?.updateNFTs(nfts: [], likedNFTs: nfts)
                }
                print("success")
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
        agent.loadProfileNfts()
    }
}
