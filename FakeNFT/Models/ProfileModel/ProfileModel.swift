//
//  ProfileModel.swift
//  TEST_TOOL2
//
//  Created by Damir Salakhetdinov on 24/11/25.
//

import Foundation

public class ProfileModel: Encodable, Decodable {
    var name: String = ""
    var avatar: String?
    var description: String?
    var website: String?
    var nfts: [NFT] = []
    var likedNFTs: [NFT] {
        return nfts.filter { $0.isLiked }
    }
    var id: String = ""
    
    func clearNFTs() {
        self.nfts = []
    }
    
    func addNFT(_ nft: NFT) {
        self.nfts.append(nft)
    }
}

