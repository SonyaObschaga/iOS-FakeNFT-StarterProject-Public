//
//  FakeNFTModelServiceProtocol.swift
//  TEST_TOOL2
//
//  Created by Damir Salakhetdinov on 27.11.2025.
//

//
protocol FakeNFTModelServiceProtocol {
    
    var profileModel: ProfileModel {get}
    var operationInProgress: Bool {get}
    
    func fetchProfile()
    func fetchProfileMyNFTs()
    func fetchProfileLikedNFTs()
    
    var myNFTsCount: Int { get}
    var likedNFTsCount: Int { get}

    func addNFTToMyNFTsCollection(_ nftId: String)
    func toggleNFTLikedFlag(_ nftId: String, _ flagValue: Bool)
    func getUserNFTs(_ sortField: UserNFTCollectionSortField) -> [NFTModel]

    func saveUserProfile()
}
