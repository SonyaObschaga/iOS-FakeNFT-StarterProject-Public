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

    // Оповещение наблюдателей о смене профиля
    //var ProfileModelChanged: ((ProfileModel) -> Void)? {get}
 
    //var backend: FakeNFTBackendServiceProtocol {get}
    //var myNFTs: [NFT] { get}
    //var likedNFTs: [NFT] { get}
    
    //func getUserProfile (_ index: Int) -> ProfileModel
    //func getNFT(_ id: String) -> NFT
}
