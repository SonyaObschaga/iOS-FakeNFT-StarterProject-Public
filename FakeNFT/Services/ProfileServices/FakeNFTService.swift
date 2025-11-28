//
//  FakeNFTModel.swift
//  TEST_TOOL2
//
//  Created by Damir Salakhetdinov on 24/11/25.
//

import Foundation

class FakeNFTService: FakeNFTModelServiceProtocol,
                      FakeNFTModelTestsHelperMethodsProtocol {
    
    //public static let shared: FakeNFTModelServiceProtocol = FakeNFTService()
    public static let shared: FakeNFTService = FakeNFTService()
    private init() {}
    
    public static var DEFAULT_USER_INDEX = 1
    public static var dataSourceType: AppDataSourceType = .mockData
    private(set) var userDefaults: FakeNFTUserDefaultsKeeperService = FakeNFTUserDefaultsKeeperService()

    private(set) var userProfile: ProfileModel?
    var profile: ProfileModel {
        guard let p = self.userProfile else {
            fatalError("Undefined user profile")
        }
        return p
    }
    
    var ProfileModelChanged: ((ProfileModel) -> Void)?
    // Оповещение наблюдателей о смене профиля
    private func notifyProfileModelChanged() {
        ProfileModelChanged?(self.profile)
    }
 
    private var fakeNFTBackendService: FakeNFTBackendServiceProtocol?
    var backend: FakeNFTBackendServiceProtocol {
        guard let service = self.fakeNFTBackendService else {
            fatalError("Undefined backend service")
        }
        return service
    }
    func fetchProfile() {
        switch FakeNFTService.dataSourceType {
        case .mockData:
            fakeNFTBackendService = FakeNFTMockDataBackendService()
        case .webAPI:
            fatalError("'WebAPI' источник данных ещё не реализован")
        }
        userProfile = defaultUserProfile
    }

    private lazy var defaultUserProfile: ProfileModel = {
        return getUserProfile(FakeNFTService.DEFAULT_USER_INDEX)
    }()
    
    private var myNFTs: [NFTModel] {
        return self.profile.nfts
    }
    
    var myNFTsCount: Int {
        return myNFTs.count
    }

    private var likedNFTs: [NFTModel] {
        return self.profile.likedNFTs
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
                fatalError("Ошибка загрузки NFTS")
            }

            for id in unwrappedNfts {
                do { let nftDto = try backend.getNFT(id) //{
                    let nft = NFTModel()
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
             fatalError("Ошибка получения профиля пользователя: \(error.localizedDescription)")
        }
    }
    
    func addNFTToMyNFTsCollection(_ nftId: String) {
        guard self.profile.nfts.first(where: { $0.id == nftId }) == nil else {
            // stop adding duplicate NFT
            return
        }

        let nft = getNFT(nftId)
     
        self.profile.addNFT(nft)
        saveUserProfile()
        notifyProfileModelChanged()
    }
    
    func toggleNFTLikedFlag(_ nftId: String, _ flagValue: Bool) {
        guard let nft = self.profile.nfts.first(where: { $0.id == nftId }) else {
            fatalError("NFT с ID '\(nftId)' не найден в коллекции пользователя")
        }

        nft.isLiked = flagValue
        saveUserProfile()
        notifyProfileModelChanged()
    }

    private func getNFT(_ id: String) -> NFTModel {
        guard let nftDto = try? fakeNFTBackendService?.getNFT(id) else {
            fatalError("NFT с ID '\(id)' не найден")
        }

        let nft = NFTModel()
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
            return self.profile.nfts.sorted { $0.name < $1.name }
        case .byPrice:
            return self.profile.nfts.sorted { ($0.price) < ($1.price) }
        case .byRating:
            return self.profile.nfts.sorted {
                if let r0 = $0.rating, let r1 = $1.rating {
                    return r0 < r1 || (r0 == r1 && ($0.name < $1.name))
                }
                return false
            }
        }
    }
    
    func saveUserProfile() {
        var p = ProfileDto.dto()
        p.name = profile.name
        p.avatar_url = profile.avatar
        p.description = profile.description
        p.website = profile.website ?? ""
        p.id = profile.id
        
        for nft in self.myNFTs {
            p.nfts?.append(nft.id)
        }
        
        for likeNft in self.likedNFTs {
            p.likes?.append(likeNft.id)
        }
        backend.saveUserProfile(p)

        userDefaults.saveUserDefaults(self.profile)
    }
        
    func resetUserDefaults() {
        userProfile = backend.resetUserDefaults()
        userDefaults.saveUserDefaults(profile)
        notifyProfileModelChanged()
    }

    func loadSavedUserDefaults() {
        userProfile = userDefaults.loadUserDefaults()
        notifyProfileModelChanged()
    }
    
    func clearMyNFTsCollection() {
        self.profile.clearNFTs()
        saveUserProfile()
        notifyProfileModelChanged()
    }
  }

