//
//  FakeNFTServiceProtocol.swift
//  TEST_TOOL2
//
//  Created by Damir Salakhetdinov on 24/11/25.
//

import Foundation

protocol FakeNFTBackendServiceBaseProtocol {
    var usersDtos: [ProfileDto] {get}
    var nftsDtos: [NFTDto] {get}
}

protocol FakeNFTBackendServiceProtocol:
    FakeNFTBackendServiceBaseProtocol
{
    func getUserProfile(_ id: Int) throws -> ProfileDto
    func getNFT(_ id: String) throws -> NFTDto
    func saveUserProfile(_ profile: ProfileDto)
    
    func resetUserDefaults() -> ProfileModel  // for testing

}
