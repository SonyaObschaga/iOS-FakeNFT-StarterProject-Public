//
//  FakeNFTModelServiceAgent.swift
//  TestFakeNFTWebAPI
//
//  Created by Damir Salakhetdinov on 04.12.2025.
//
import Foundation

typealias NftsCompletion = (Result<[Nft], Error>) -> Void

final class FakeNFTModelServiceAgent: FakeNFTModelServiceProtocol,
                                      FakeNFTServiceAgentNotificationsProtocol,
                                      FakeNFTServiceAgentEventsProtocol,
                                      FakeNFTModelTestsHelperMethodsProtocol
{
    
    let profileLoadedNotification = Notification.Name(rawValue: "ProfileLoaded")
    let profileSavedNotification = Notification.Name(rawValue: "ProfileSaved")
    let profileNTFsLoadedNotification = Notification.Name(rawValue: "ProfileNTFsLoaded")
 
    var profileLoadingStarted: ProfileLoadingStarted?
    var profileLoadingCompleted: ProfileLoadingCompleted?
 
    let profileService : ProfileService //Impl
    let nftService : NftService //Impl
    
    init(servicesAssembly:ServicesAssembly) {
        profileService = servicesAssembly.profileService
        nftService = servicesAssembly.nftService
    }
    
    private var loadedProfileId: Int = -1
    var profile: ProfileDto = ProfileDto.EmptyProfile
    
    var operationInProgress: Bool = false
    
    private func loadingStarted() {
        operationInProgress = true
    }
    
    private func loadingCompleted() {
        operationInProgress = false
    }

    private func loadProfile() {
        let id = FakeNFTService.DEFAULT_USER_INDEX
        self.loadedProfileId = -1
 
        self.loadingStarted()
        
        self.profileService.loadProfile(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.profile = profile
                    self?.loadedProfileId = id
                    
                    self?.profileLoadingCompleted?(result)
                    
                    if let self {
                        if let myNtfsCount = profile.nfts?.count,
                           let likedNtfsCount = profile.likes?.count  {
                            self.myNFTsCount = myNtfsCount
                            self.likedNFTsCount = likedNtfsCount
                        }
                        
                        NotificationCenter.default.post(
                            name: self.profileLoadedNotification,
                            object: self,
                            userInfo: ["Result":result]
                        )
                    }
                    self?.loadingCompleted()
                    
                case .failure(let error):
                    print("Error loading profile: \(error)")
                    if let self {
                        NotificationCenter.default.post(
                            name: self.profileLoadedNotification,
                            object: self,
                            userInfo: ["Result":result]
                        )
                    }
                    self?.loadingCompleted()
                }
            }
        }
    }
 
    func saveProfile() {
        if self.profile.name == "" {
            // TODO: it can't happen? report profile is not loaded yet
            return
        }
        
        loadingStarted()
 
        profileService.saveProfile(id: loadedProfileId, profile: self.profile) { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                if let self {
                    NotificationCenter.default.post(
                        name: self.profileSavedNotification,
                        object: self,
                        userInfo: ["Result":result]
                    )
                }
                print("Profile updated successfully, C = \(profile.name)")
                self?.loadingCompleted()
            case .failure(let error):
                if let self {
                    NotificationCenter.default.post(
                        name: self.profileSavedNotification,
                        object: self,
                        userInfo: ["Result":result]
                    )
                }
                print("Error updating profile: \(error)")
                self?.loadingCompleted()
            }
        }
    }
    
    var MyNfts: [NFTModel] = []
    func loadProfileNfts() {
        loadingStarted()
        
        var nfts:[NFTModel] = []
        self.MyNfts = []
        
        let c = self.profile.nfts!.count
        
        DispatchQueue.global().async { [weak self ] in
            guard let self = self else { return }
            
            for nftId in self.profile.nfts! {
                self.nftService.loadNft(id: nftId) { [weak self] result in
                    switch result {
                    case .success(let nft):
                        
                        //let nftModel = ntf.
                        //nfts.append(nft)
                        
                        let nftModel = nft.NftModelObject()
                        nfts.append(nftModel)
                        
                        if nfts.count < c {
                            print("  loaded mynfts \(nfts.count) of \(c) -> id = \(nft.id)")
                        } else
                        {
                            if let self {
                                
                                self.MyNfts = nfts
                                //self?.applySavedSortOption()
                                let result: Result<[NFTModel], Error>
                                result = .success(nfts)

                                NotificationCenter.default.post(
                                    name: self.profileNTFsLoadedNotification,
                                    object: self,
                                    userInfo: ["Result": result]
                                )
                                self.loadingCompleted()
                            }
                            
                        }
                        
                    case .failure(let error):
                        print("Error loading profile's MyNFTs: \(error)")
                        if let self {
                            let result: Result<[NFTModel], Error>
                            result = .failure(error)

                            NotificationCenter.default.post(
                                name: self.profileNTFsLoadedNotification,
                                object: self,
                                userInfo: ["Result": result]
                            )
                        }
                        
                        self?.loadingCompleted()
                        break
                    }
                }
            }
        }
    }

    var LikedNfts: [Nft] = []
    func loadProfileLikedNfts() {
        loadingStarted()
        var nfts:[Nft] = []
        self.LikedNfts = []
        
        let c = self.profile.likes!.count
        for nftId in self.profile.likes! {
            self.nftService.loadNft(id: nftId) { [weak self] result in
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                    
                    if nfts.count < c {
                        print("  loaded liked nft \(nfts.count) of \(c) -> id = \(nft.id)")
                    } else
                    {
                        self?.LikedNfts = nfts
                        //self?.applySavedSortOption()
                        //self?.hideLoading()
                        //self?.reloadTable()
                        self?.loadingCompleted()
                    }
                    
                case .failure(let error):
                    //self?.hideLoading()
                    print("Error loading profile's liked NFTs: \(error)")
                    self?.loadingCompleted()
                    break
                }
            }
        }
    }

    
    //+ FakeNFTModelServiceProtocol
    var profileModel: ProfileModel = ProfileModel()
    
    func fetchProfile() {
        loadProfile()
    }
    
    var myNFTsCount: Int = 0
    var likedNFTsCount: Int = 0
    
    func addNFTToMyNFTsCollection(_ nftId: String) {
        //TODO
    }
    
    func toggleNFTLikedFlag(_ nftId: String, _ flagValue: Bool) {
       //TODO
    }
    
    func getUserNFTs(_ sortField: UserNFTCollectionSortField) -> [NFTModel] {
        //TODO - sorted
        return []
    }
    
    func saveUserProfile() {
        //guard let profile = profileService.inMemoryStorageProfile  else { return }
        //saveProfile(id: profile.)
        saveProfile();
    }
    //- FakeNFTModelServiceProtocol
 
    
    //+ FakeNFTModelTestsHelperMethodsProtocol
    // no implementations for real web api
    func resetUserDefaults() {}
    func loadSavedUserDefaults() {}
    func clearMyNFTsCollection() {}
    // - FakeNFTModelTestsHelperMethodsProtocol

    
    }

