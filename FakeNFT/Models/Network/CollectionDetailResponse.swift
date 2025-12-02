//
//  CollectionDetailResponse.swift
//  FakeNFT
//
//  Created by Илья on 30.11.2025.
//

import Foundation

struct CollectionDetailResponse: Decodable {
    let id: String
    let name: String
    let cover: URL
    let description: String?
    let author: String?
   // let createdAt: String?  // Опционально, если не используется
    let nfts: [String]  // Массив ID NFT, а не объекты!
}
