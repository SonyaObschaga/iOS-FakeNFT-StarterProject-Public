//
//  FakeNFTModel.swift
//  TEST_TOOL2
//
//  Created by Damir Salakhetdinov on 24/11/25.
//

import Foundation

class FakeNFTService: FakeNFTModelServiceProtocol,
                      FakeNFTModelTestsHelperMethodsProtocol {
    
    public static let shared: FakeNFTService = FakeNFTService()
    private init() {}
    
    public static var DEFAULT_USER_INDEX = 1
    public static var dataSourceType: AppDataSourceType = .mockData
    private(set) var userDefaults: FakeNFTUserDefaultsKeeperService = FakeNFTUserDefaultsKeeperService()
    
    var operationInProgress: Bool = false  // from FakeNFTModelServiceProtocol => not used here
    
    private(set) var userProfile: ProfileModel?
    var profileModel: ProfileModel {
        guard let p = self.userProfile else {
            assertionFailure("Undefined user profile")
            return ProfileModel() //TODO: edit
        }
        return p
    }
    
    var ProfileModelChanged: ((ProfileModel) -> Void)?
    // Оповещение наблюдателей о смене профиля
    private func notifyProfileModelChanged() {
        ProfileModelChanged?(self.profileModel)
    }
    
    private var fakeNFTBackendService: FakeNFTBackendServiceProtocol?
    var backend: FakeNFTBackendServiceProtocol {
        guard let service = self.fakeNFTBackendService else {
            assertionFailure("Undefined backend service")
            return FakeNFTMockDataBackendService() //TODO: edit
        }
        return service
    }
    var profileFetched: Bool = false
    func fetchProfile() {
        switch FakeNFTService.dataSourceType {
        case .mockData:
            fakeNFTBackendService = FakeNFTMockDataBackendService()
        case .webAPI:
            assertionFailure("'WebAPI' источник данных ещё не реализован")
        }
        userProfile = defaultUserProfile
        profileFetched = true
    }
    
    private lazy var defaultUserProfile: ProfileModel = {
        return getUserProfile(FakeNFTService.DEFAULT_USER_INDEX)
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
        guard var nft = self.profileModel.nfts.first(where: { $0.id == nftId }) else {
            assertionFailure("NFT с ID '\(nftId)' не найден в коллекции пользователя")
            return //TODO: edit
        }
        
        nft.isLiked = flagValue
        saveUserProfile()
        notifyProfileModelChanged()
    }
    
    private func getNFT(_ id: String) -> NFTModel {
        guard let nftDto = try? fakeNFTBackendService?.getNFT(id) else {
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
        var p = ProfileDto().dto()
        p.name = profileModel.name
        p.avatar_url = profileModel.avatar
        p.description = profileModel.description
        p.website = profileModel.website ?? ""
        p.id = profileModel.id
        
        for nft in self.myNFTs {
            p.nfts?.append(nft.id)
        }
        
        for likeNft in self.likedNFTs {
            p.likes?.append(likeNft.id)
        }
        backend.saveUserProfile(p)
        
        userDefaults.saveUserDefaults(self.profileModel)
    }
    
    func resetUserDefaults() {
        userProfile = backend.resetUserDefaults()
        userDefaults.saveUserDefaults(profileModel)
        notifyProfileModelChanged()
    }
    
    func loadSavedUserDefaults() {
        userProfile = userDefaults.loadUserDefaults()
        notifyProfileModelChanged()
    }
    
    func clearMyNFTsCollection() {
        self.profileModel.clearNFTs()
        saveUserProfile()
        notifyProfileModelChanged()
    }
}
