//
//  FakeNFTModelServiceAgentProtocol.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 10/12/25.
//

// MARK: - Protocol
protocol FakeNFTModelServiceAgentProtocol: FakeNFTModelServiceProtocol,
                                           FakeNFTModelTestsHelperMethodsProtocol {
    var profile: ProfileDto { get set }
    var myNfts: [NFTModel] { get }
    var likedNfts: [NFTModel] {get}
}



