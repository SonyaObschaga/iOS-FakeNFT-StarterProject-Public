//
//  OrderResponse.swift
//  FakeNFT
//
//  Created by Илья on 02.12.2025.
//

import Foundation

struct OrderResponse: Decodable {
    let id: String
    let nfts: [String]  // Массив ID NFT в корзине
}
