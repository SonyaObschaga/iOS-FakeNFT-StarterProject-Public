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
    var agent: FakeNFTModelServiceAgentProtocol
    init(servicesAssembly: ServicesAssembly) {
        profileLoaded = false
        self.servicesAssembly = servicesAssembly
        agent = servicesAssembly.modelServiceAgent
        addObservers()
    }
    
    private var profileLoadingOperationObserver: NSObjectProtocol?
    private var profileSavedOperationObserver: NSObjectProtocol?
    private var nftLikedNotificationObserver: NSObjectProtocol?
    private var profileLoaded: Bool
    
    private func addObservers() {
        profileLoadingOperationObserver =
        NotificationCenter.default.addObserver(
            forName: FakeNFTModelServicesNotifications.profileLoadedNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            self.handleProfileLoadedNotification(notification: notification)
        }
        profileSavedOperationObserver =
        NotificationCenter.default.addObserver(
            forName: FakeNFTModelServicesNotifications.profileSavedNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            self.handleProfileSavedNotification(notification: notification)
        }
        
        nftLikedNotificationObserver = NotificationCenter.default.addObserver(
            forName: FakeNFTModelServicesNotifications.likedNFTSavedNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleLikedNFTSavedNotification(notification)
        }

    }
    
    deinit {
        removeObservers()
    }

    private func removeObservers() {
        if let observer = profileLoadingOperationObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = profileSavedOperationObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = nftLikedNotificationObserver {
            NotificationCenter.default.removeObserver(observer)
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
                profileLoaded = true
                self.profileDtoLoaded(profile: profile)
                print("Profile fetched, name = \(profile.name)")

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
    
    private func handleLikedNFTSavedNotification(_ notification: Notification) {
        view?.hideLoading()

        guard let userInfo = notification.userInfo,
              let result = userInfo["Result"] as? Result<ProfileDto, Error> else {
            print("Invalid notification data")
            return
        }

        switch result {
        case .success(let profile):
            var nftsCount = 0, likesCount = 0
            if ((profile.nfts) != nil) { nftsCount = profile.nfts?.count ?? 0}
            if ((profile.likes) != nil) { likesCount = profile.likes?.count ?? 0 }
            print("To be set for profile: MyNTFs.Count = \(nftsCount), liked NFTs.Count = \(likesCount)")
            
            myNFTsCountToBeUpdated = nftsCount
            likedNFTsCountToBeUpdated = likesCount
 
        case .failure(let error):
            view?.errorDetected(error: error)
        }
    }

    
    private func profileDtoLoaded(profile:ProfileDto) {
        view?.unhideControls()
        
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
        view?.unhideControls()
        
        view?.profileUpdated(profile: profile)
    }
    
    private var myNFTsCountToBeUpdated: Int?
    private var likedNFTsCountToBeUpdated: Int?
    func viewDidLoad() {
        print("Fetching user profile...")
        agent.fetchProfile()
    }
    
    func viewWillAppear()
    {
        if (profileLoaded) {
            let profile = agent.profile
            view?.updateProfile(name: profile.name, descripton: profile.description, website: profile.website)
        }
        
        if let nc = myNFTsCountToBeUpdated,
           let lc = likedNFTsCountToBeUpdated {
            view?.updateNftsCount(nftsCount: nc, likedNftsCount: lc)
            myNFTsCountToBeUpdated = nil
            likedNFTsCountToBeUpdated = nil
        }

    }
}
