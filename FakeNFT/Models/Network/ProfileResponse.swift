//
//  ProfileResponse.swift
//  FakeNFT
//
//  Created by Илья on 01.12.2025.
//

import Foundation

struct ProfileResponse: Decodable {
    let id: String
    let name: String?
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]
    let likes: [String]  // Массив ID избранных NFT
}
