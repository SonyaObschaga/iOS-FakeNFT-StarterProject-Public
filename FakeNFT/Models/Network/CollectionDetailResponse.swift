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
    let nfts: [String]
}
