//
//  FakeNFTModelServiceAgent.swift
//  TestFakeNFTWebAPI
//
//  Created by Damir Salakhetdinov on 04.12.2025.
//

import Foundation

final class FakeNFTModelServiceAgent: FakeNFTModelServiceAgentProtocol {
    public static var DEFAULT_USER_INDEX = 1
    
    public static var dataSourceType: AppDataSourceType = .webAPI
//    public static var dataSourceType: AppDataSourceType = .mockData

    // MARK: - Public Variables
    var profile: ProfileDto = ProfileDto.EmptyProfile
    var myNfts: [NFTModel] = []
    var likedNfts: [NFTModel] = []
    
    var profileModel: ProfileModel {
        get {
            let p = self.profile
            let p2 = ProfileModel()
            p2.name = p.name
            p2.description = p.description
            p2.website = p.website
            p2.avatar = p.avatar_url
            p2.nfts = myNfts
            return p2
        }
    }
    
    var myNFTsCount: Int = 0
    var likedNFTsCount: Int = 0
    var operationInProgress: Bool = false
    
    // MARK: - Private Variables
    private let profileService: ProfileService
    private let nftService: NftService
    private var loadedProfileId: Int = -1
    
    // MARK: - Init
    init(servicesAssembly: ServicesAssembly) {
        self.profileService = servicesAssembly.profileService
        self.nftService = servicesAssembly.nftService
    }
    
    // MARK: - Public Methods
    func fetchProfile() {
        loadProfile()
    }
    
    func saveUserProfile() {
        saveProfile()
    }
    
    func fetchProfileMyNFTs() {
        loadingStarted()
        var nfts: [NFTModel] = []
        self.myNfts = []
        
        guard let myNFTIds = profile.nfts else { return }
        let totalNFTs = myNFTIds.count
        print("Fetching my NFTs...")
        
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            for nftId in myNFTIds {
                self.nftService.loadNft(id: nftId) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let nft):
                        
                        var isLiked = false
                        if let isLiked2 = self.profile.likes?.contains(nftId) {
                            isLiked = isLiked2
                        }
                        
                        let nftModel = nft.NftModelObject(isLiked: isLiked)
                        nfts.append(nftModel)
                        
                        if nfts.count < totalNFTs {
                            print("  loaded my NFTs \(nfts.count) of \(totalNFTs) -> id = \(nft.id)")
                        } else {
                            print("  loaded all my NFTs \(nfts.count) of \(totalNFTs) -> id = \(nft.id)")
                            self.myNfts = nfts
                            let result: Result<[NFTModel], Error> = .success(nfts)
                            NotificationCenter.default.post(
                                name: FakeNFTModelServicesNotifications.profileNTFsLoadedNotification,
                                object: self,
                                userInfo: ["Result": result]
                            )
                            self.loadingCompleted()
                        }
                        
                    case .failure(let error):
                        print("Error loading profile's MyNFTs: \(error)")
                        let result: Result<[NFTModel], Error> = .failure(error)
                        NotificationCenter.default.post(
                            name: FakeNFTModelServicesNotifications.profileNTFsLoadedNotification,
                            object: self,
                            userInfo: ["Result": result]
                        )
                        self.loadingCompleted()
                    }
                }
            }
        }
    }
    
    func fetchProfileLikedNFTs() {
        if self.myNfts.isEmpty{
            fetchProfileMyNFTs()
        }
        loadingStarted()
        var nfts: [NFTModel] = []
        self.likedNfts = []
        
        guard let likedNFTIds = profile.likes else { return }
        let totalLikedNFTs = likedNFTIds.count
        print("Fetching liked NFTs...")
        
        for nftId in likedNFTIds {
            self.nftService.loadNft(id: nftId) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let nft):
                    let nftModel = nft.NftModelObject(isLiked:true)
                    nfts.append(nftModel)
                    
                    if nfts.count < totalLikedNFTs {
                        print("  loaded liked NFTs \(nfts.count) of \(totalLikedNFTs) -> id = \(nft.id)")
                    } else {
                        print("  loaded all liked NFTs \(nfts.count) of \(totalLikedNFTs) -> id = \(nft.id)")
                        self.likedNfts = nfts
                        let result: Result<[NFTModel], Error> = .success(nfts)
                        NotificationCenter.default.post(
                            name: FakeNFTModelServicesNotifications.profileLikedNTFsLoadedNotification,
                            object: self,
                            userInfo: ["Result": result]
                        )
                        self.loadingCompleted()
                    }
                    
                case .failure(let error):
                    print("Error loading profile's liked NFTs: \(error)")
                    let result: Result<[NFTModel], Error> = .failure(error)
                    NotificationCenter.default.post(
                        name: FakeNFTModelServicesNotifications.profileLikedNTFsLoadedNotification,
                        object: self,
                        userInfo: ["Result": result]
                    )
                    self.loadingCompleted()
                }
            }
        }
    }
    
    func getUserNFTs(_ sortField: UserNFTCollectionSortField) -> [NFTModel] {
        // TODO: implement sorting
        return []
    }
    
    func addNFTToMyNFTsCollection(_ nftId: String) {
        // TODO
    }
    
    func toggleNFTLikedFlag(_ nftId: String, _ flagValue: Bool) {
        // Инициализация, если nil
        if profile.likes == nil {
            profile.likes = []
        }

        if flagValue && !profile.likes!.contains(nftId) {
            // Лайк
                profile.likes!.append(nftId)
        } else {
            // Анлайк
            profile.likes!.removeAll { $0 == nftId }
        }
        
        var index = 0
        self.likedNfts = []
        for nft in self.myNfts {
            if nft.id == nftId {
                self.myNfts[index].isLiked = flagValue
            }
            if self.myNfts[index].isLiked {
                self.likedNfts.append(nft)
            }
            index += 1
        }

        // Сохраняем профиль
//        saveUserProfile()
//        guard self.profile.name != "" else { return }
        
        loadingStarted()
        
        profileService.saveProfile(id: loadedProfileId, profile: self.profile) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                self.profile = profile
                NotificationCenter.default.post(
                    name: FakeNFTModelServicesNotifications.likedNFTSavedNotification,
                    object: self,
                    userInfo: ["Result": result]
                )
                var count = 0;
                if let count2 = self.profile.likes?.count {
                    count = count2
                }
                print("Profile likedNFT updated successfully, Count = \(count)")
                self.loadingCompleted()
                
            case .failure(let error):
                NotificationCenter.default.post(
                    name: FakeNFTModelServicesNotifications.likedNFTSavedNotification,
                    object: self,
                    userInfo: ["Result": result]
                )
                print("Error updating likedNFT: \(error)")
                self.loadingCompleted()
            }
        }
    }
    
    func resetUserDefaults() {}
    func loadSavedUserDefaults() {}
    func clearMyNFTsCollection() {}
    
    // MARK: - Private Methods
    private func loadingStarted() {
        operationInProgress = true
    }
    
    private func loadingCompleted() {
        operationInProgress = false
    }
    
    private func loadProfile() {
        let id = FakeNFTModelServiceAgent.DEFAULT_USER_INDEX
        loadedProfileId = -1
        loadingStarted()
        
        profileService.loadProfile(id: id) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let profile):
                    self.profile = profile
                    self.loadedProfileId = id
                    self.myNFTsCount = profile.nfts?.count ?? 0
                    self.likedNFTsCount = profile.likes?.count ?? 0
                    
                    NotificationCenter.default.post(
                        name: FakeNFTModelServicesNotifications.profileLoadedNotification,
                        object: self,
                        userInfo: ["Result": result]
                    )
                    self.loadingCompleted()
                    
                case .failure(let error):
                    print("Error loading profile: \(error)")
                    NotificationCenter.default.post(
                        name: FakeNFTModelServicesNotifications.profileLoadedNotification,
                        object: self,
                        userInfo: ["Result": result]
                    )
                    self.loadingCompleted()
                }
            }
        }
    }
    
    private func saveProfile() {
        guard self.profile.name != "" else { return }
        
        loadingStarted()
        
        profileService.saveProfile(id: loadedProfileId, profile: self.profile) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                self.profile = profile
                NotificationCenter.default.post(
                    name: FakeNFTModelServicesNotifications.profileSavedNotification,
                    object: self,
                    userInfo: ["Result": result]
                )
                print("Profile updated successfully, C = \(profile.name)")
                self.loadingCompleted()
                
            case .failure(let error):
                NotificationCenter.default.post(
                    name: FakeNFTModelServicesNotifications.profileSavedNotification,
                    object: self,
                    userInfo: ["Result": result]
                )
                print("Error updating profile: \(error)")
                self.loadingCompleted()
            }
        }
    }
}
