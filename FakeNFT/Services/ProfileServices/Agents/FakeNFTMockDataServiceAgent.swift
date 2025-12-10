//
//  FakeNFTModel.swift
//  TEST_TOOL2
//
//  Created by Damir Salakhetdinov on 24/11/25.
//

import Foundation

class FakeNFTMockDataServiceAgent: FakeNFTModelServiceAgentProtocol
                      //FakeNFTModelServiceProtocol,
                      //FakeNFTModelTestsHelperMethodsProtocol
{
    private var _profile: ProfileDto = ProfileDto.EmptyProfile
    var profile: ProfileDto {
        get {
            //guard let p = self.profileModel else {
            //    assertionFailure("Undefined user profile")
            //    return ProfileDto.EmptyProfile
            //}
            let p = self.profileModel
            var p2 = _profile
            p2.name = p.name
            p2.description = p.description
            if let w = p.website {
                p2.website = w
            }
            p2.avatar_url = p.avatar
            p2.nfts = []
            for i in p.nfts {
                p2.nfts?.append(i.id)
            }
            p2.likes = []
            for i in p.likedNFTs {
                p2.likes?.append(i.id)
            }
            
            return p2
        }
        set {
            _profile = newValue
        }
    }
 
    var myNfts: [NFTModel] {
        get {
            //guard let p = self.userProfile else {
            //    assertionFailure("Undefined user profile")
            //    return []
            //}
            return profileModel.nfts // p.nfts
        }
        set {
            //_profile = newValue
        }
    }
    
    var likedNfts: [NFTModel] {
        get {
            return profileModel.likedNFTs// p.nfts
        }
        set {
            //_profile = newValue
        }
    }
 
    
    func fetchProfileMyNFTs() {
        let result2: Result<[NFTModel], Error>
        result2 = .success(self.myNfts )

        NotificationCenter.default.post(
            name: FakeNFTModelServicesNotifications.profileNTFsLoadedNotification, // self.profileNTFsLoadedNotification,
            object: self,
            userInfo: ["Result": result2]
        )
        
 
    }
    
    func fetchProfileLikedNFTs() {
        // profileLikedNTFsLoadedNotification
        let result3: Result<[NFTModel], Error>
        result3 = .success(self.likedNFTs )

        NotificationCenter.default.post(
            name: FakeNFTModelServicesNotifications.profileLikedNTFsLoadedNotification, // self.profileNTFsLoadedNotification,
            object: self,
            userInfo: ["Result": result3]
        )
   }
    
    
    public static let shared: FakeNFTMockDataServiceAgent = FakeNFTMockDataServiceAgent()
    init() {
    }
     
    private(set) var userDefaults: FakeNFTUserDefaultsKeeperService = FakeNFTUserDefaultsKeeperService()
    
    var operationInProgress: Bool = false  // from FakeNFTModelServiceProtocol => not used here
    
    //private(set)
    private var _userProfile: ProfileModel = ProfileModel() // ?
    var profileModel: ProfileModel {
        get {
            return _userProfile
        }
        set {
            _userProfile = newValue
        }
    }
    
    var ProfileModelChanged: ((ProfileModel) -> Void)?
    // Оповещение наблюдателей о смене профиля
    private func notifyProfileModelChanged() {
        ProfileModelChanged?(self.profileModel)
    }
    
    private var fakeNFTBackendService: FakeNFTBackendServiceProtocol = FakeNFTMockDataBackendService()
    var backend: FakeNFTBackendServiceProtocol {
        return fakeNFTBackendService
    }
    var profileFetched: Bool = false
    func fetchProfile() {
        self.profileModel = defaultUserProfile
        
        let result: Result<ProfileDto, Error>
        let profile2 = self.profile
        result = .success(profile2)

        NotificationCenter.default.post(
            name: FakeNFTModelServicesNotifications.profileLoadedNotification,
            object: self,
            userInfo: ["Result": result]
        )
        
        profileFetched = true
    }
    
    private lazy var defaultUserProfile: ProfileModel = {
        return getUserProfile(FakeNFTModelServiceAgent.DEFAULT_USER_INDEX)
    }()
    
    private var myNFTs: [NFTModel] {
        return self.profileModel.nfts
    }
    
    var myNFTsCount: Int {
        return myNFTs.count
    }
    
    private var likedNFTs: [NFTModel] {
        return self.profileModel.likedNFTs
    }
    
    var likedNFTsCount: Int {
        return likedNFTs.count
    }
    
    private func getUserProfile (_ index: Int) -> ProfileModel {
        do {
            let p = try backend.getUserProfile(index)
            
            let profile = ProfileModel()
            profile.name = p.name
            profile.avatar = p.avatar_url
            profile.description = p.description
            profile.website = p.website
            profile.id = p.id
            
            guard let unwrappedNfts = p.nfts else {
                print("Ошибка загрузки NFTS")
                return ProfileModel() //TODO: edit
            }
            
            for id in unwrappedNfts {
                do { let nftDto = try backend.getNFT(id) //{
                    var nft = NFTModel()
                    nft.createdAt = nftDto.createdAt
                    nft.name = nftDto.name
                    nft.images = nftDto.images
                    nft.rating = nftDto.rating
                    nft.description = nftDto.description
                    nft.price = nftDto.price
                    nft.author = nftDto.author
                    nft.id = nftDto.id
                    if let likes = p.likes {
                        nft.isLiked = likes.contains(id)
                    } else {
                        nft.isLiked = false // или любое другое подходящее значение по умолчанию
                    }
                    profile.nfts.append(nft)
                }
            }
            return profile
        } catch {
            assertionFailure("Ошибка получения профиля пользователя: \(error.localizedDescription)")
            return ProfileModel() //TODO: edit
        }
    }
    
    func addNFTToMyNFTsCollection(_ nftId: String) {
        guard self.profileModel.nfts.first(where: { $0.id == nftId }) == nil else {
            // stop adding duplicate NFT
            return
        }
        
        let nft = getNFT(nftId)
        
        self.profileModel.addNFT(nft)
        saveUserProfile()
        notifyProfileModelChanged()
    }
    
    func toggleNFTLikedFlag(_ nftId: String, _ flagValue: Bool) {
        //guard var nft = self.profileModel.nfts.first(where: { $0.id == nftId }) else {
        //    assertionFailure("NFT с ID '\(nftId)' не найден в коллекции пользователя")
        //    return //TODO: edit
        //}
        var index = 0
        for nft in profileModel.nfts {
            if nft.id == nftId {
                //nft.isLiked = flagValue
                profileModel.nfts[index].isLiked = flagValue
                break;
            }
            index += 1
        }
        //nft.isLiked = flagValue
        
        saveUserProfile()
        
        let result: Result<ProfileDto, Error>
        result = .success(self.profile)
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
        
        notifyProfileModelChanged()
    }
    
    private func getNFT(_ id: String) -> NFTModel {
        guard let nftDto = try? fakeNFTBackendService.getNFT(id) else {
            assertionFailure("NFT с ID '\(id)' не найден")
            return NFTModel() //TODO: edit
        }
        
        var nft = NFTModel()
        nft.createdAt = nftDto.createdAt
        nft.name = nftDto.name
        nft.images = nftDto.images
        nft.rating = nftDto.rating
        nft.description = nftDto.description
        nft.price = nftDto.price
        nft.author = nftDto.author
        nft.id = nftDto.id
        nft.isLiked = false
        return nft
    }
    
    func getUserNFTs(_ sortField: UserNFTCollectionSortField) -> [NFTModel] {
        switch sortField {
        case .byName:
            return self.profileModel.nfts.sorted { $0.name < $1.name }
        case .byPrice:
            return self.profileModel.nfts.sorted { ($0.price) < ($1.price) }
        case .byRating:
            return self.profileModel.nfts.sorted {
                if let r0 = $0.rating, let r1 = $1.rating {
                    return r0 < r1 || (r0 == r1 && ($0.name < $1.name))
                }
                return false
            }
        }
    }
    
    func saveUserProfile() {
        let p = self.profile  // Dto
        
        backend.saveUserProfile(p)
        
        let result: Result<ProfileDto, Error>
        result = .success(p )

        NotificationCenter.default.post(
            name: FakeNFTModelServicesNotifications.profileSavedNotification, // self.profileSavedNotification,
            object: self,
            userInfo: ["Result":result]
        )
        
        userDefaults.saveUserDefaults(self.profileModel)
    }
    
    func resetUserDefaults() {
        profileModel = backend.resetUserDefaults()
        userDefaults.saveUserDefaults(profileModel)
        notifyProfileModelChanged()
    }
    
    func loadSavedUserDefaults() {
        profileModel = userDefaults.loadUserDefaults()
        notifyProfileModelChanged()
    }
    
    func clearMyNFTsCollection() {
        self.profileModel.clearNFTs()
        saveUserProfile()
        notifyProfileModelChanged()
    }
}
