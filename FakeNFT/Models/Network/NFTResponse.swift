//
//  NFTResponse.swift
//  FakeNFT
//
//  Created by Илья on 30.11.2025.
//

import Foundation

struct NFTResponse: Decodable {
    let id: String
    let title: String
    let imageURL: URL
    let favorite: Bool
    let rating: Int
    let price: Double
    let isInCart: Bool
}
