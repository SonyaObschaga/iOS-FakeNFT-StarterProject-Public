//
//  MockDataFakeNFTService.swift
//  TEST_TOOL2
//
//  Created by Damir Salakhetdinov on 24/11/25.
//

import Foundation

class FakeNFTMockDataBackendService: FakeNFTBackendServiceProtocol {
    
    func saveUserProfile(_ profile: ProfileDto) {
        print("TODO: MockDataFakeNFTService.saveUserProfile")
    }
    
    func getUserProfile(_ id: Int) throws -> ProfileDto {
        let users = usersDtos
        
        guard users.count >= id else {
            let errorMessage = "Default user index exceeds loaded users array length"
            assertionFailure(errorMessage)
            throw RuntimeError(errorMessage)
            
        }
        return users[id - 1]
    }
    
    func getNFT(_ id: String) throws -> NFTDto {
        let nfts = nftsDtos

        do {
            if let foundNFT = nfts.first(where: { $0.id == id }) {
                return foundNFT
            } else {
                throw RuntimeError("NFT с таким id = \(id) не найден")
            }
            
        } catch {
            throw RuntimeError("Decoding failed: \(error)")
        }
    }

    func resetUserDefaults() -> ProfileModel {
        let users = usersDtos
        var p = users[FakeNFTModelServiceAgent.DEFAULT_USER_INDEX-1]
        p.likes = []
        
        let ntfs = nftsDtos
        
        var defaultUserProfile = ProfileModel() //name: "", avatar: "", description: "", website: "", id: "")
        defaultUserProfile.name = p.name
        defaultUserProfile.avatar = p.avatar
        defaultUserProfile.description = p.description
        defaultUserProfile.website = p.website
        defaultUserProfile.id = p.id
        
        addProfileDTOs(p.nfts, p.likes, &defaultUserProfile, ntfs);

        let userProfile = defaultUserProfile

        return userProfile
    }

    private func addProfileDTOs(
                                _ nftsIds: [String],
                                _ likedIds: [String],
                                _ profile: inout ProfileModel,
                                _ allNFTDTOs: [NFTDto]) {
            for id in nftsIds {
                if let nftDto = allNFTDTOs.first(where: { $0.id == id }) {
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
                    
                    profile.nfts.append(nft)
                    nft.isLiked = likedIds.contains(id)
                }
            }
        }

    var usersDtos: [ProfileDto] {
        return FakeNFTMockData().usersDto
    }
    
    var nftsDtos: [NFTDto] {
        return FakeNFTMockData().nftsDtos
    }
}
