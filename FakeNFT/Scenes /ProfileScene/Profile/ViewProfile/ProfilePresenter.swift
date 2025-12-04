//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 30.11.2025.
//
import Foundation

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?

    let servicesAssembly: ServicesAssembly
    let agent: FakeNFTModelServiceAgent
    let notifications: FakeNFTServiceAgentNotificationsProtocol
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        agent = servicesAssembly.modelServiceAgent
        notifications = agent as FakeNFTServiceAgentNotificationsProtocol
        addObservers()
    }
    
    //var profileLoadedNotification: Notification.Name { get }
    //var profileSavedNotification: Notification.Name { get }
    //var profileNTFsLoadedNotification: Notification.Name { get }

    private var profileLoadingOperationObserver: NSObjectProtocol?

    private func addObservers() {
        profileLoadingOperationObserver =
        NotificationCenter.default.addObserver(
            forName: agent.profileLoadedNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            self.handleProfileLoadedNotification(notification: notification)
        }
    }

    private func handleProfileLoadedNotification(notification: Notification) {
        self.view?.hideLoading()
        
        // Extract the result and profile from the userInfo dictionary
        if let userInfo = notification.userInfo,
           let result = userInfo["Result"] as? Result<ProfileDto, Error> {
            // Handle the result
            switch result {
            case .success(let profile):
                self.profileDtoLoaded(profile: profile)
            case .failure(let error):
                view?.errorDetected(error: error)
            }
        } else {
            print("Invalid notification data")
        }
    }

    private func handleProfileSavedNotification(notification: Notification) {
        self.view?.hideLoading()
        
        // Extract the result and profile from the userInfo dictionary
        if let userInfo = notification.userInfo,
           let result = userInfo["Result"] as? Result<ProfileDto, Error> {
            // Handle the result
            switch result {
            case .success(let profile):
                self.profileDtoSaved(profile: profile)
                print("Profile update notification processed name = \(profile.name)")
            case .failure(let error):
                view?.errorDetected(error: error)
            }
        } else {
            print("Invalid notification data")
        }
    }

    
    private func profileDtoLoaded(profile:ProfileDto) {
        view?.unhideControls()  // !
        
        view?.updateProfile(name: profile.name, descripton: profile.description, website: profile.website)
        
        var nftsCount = 0, likesCount = 0
        if ((profile.nfts) != nil) { nftsCount = profile.nfts?.count ?? 0}
        if ((profile.likes) != nil) { likesCount = profile.likes?.count ?? 0 }
        
        view?.updateNftsCount(nftsCount: nftsCount, likedNftsCount: likesCount)
        
        if let avatar_url = profile.avatar_url {
            view?.updateAvatar(url: URL(string: avatar_url))
        }
    }
    
    func updateProfile(profile: ProfileDto)
    {
        DispatchQueue.global().async { [weak self ] in
            guard let self = self else { return }
            agent.profile.name = profile.name
            agent.profile.description = profile.description
            agent.profile.website = profile.website
            agent.profile.avatar_url = profile.avatar_url
            agent.saveUserProfile()
        }
    }
    
    private func profileDtoSaved(profile:ProfileDto) {
        view?.unhideControls()  // !
        
        view?.profileUpdated(profile: profile)
    }
  
    
    func viewDidLoad() {
        view?.hideControls()
        view?.showLoading()
        agent.fetchProfile()
    }
}
