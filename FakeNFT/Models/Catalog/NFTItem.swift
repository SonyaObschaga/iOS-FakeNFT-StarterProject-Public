//
//  NFTItem.swift
//  FakeNFT
//
//  Created by Илья on 22.11.2025.
//

import Foundation

struct NFTItem {
    let id: String
    let title: String
    let imageURL: URL?
    let rating: Double
    let price: Double
    var isFavorite: Bool    
    var isInCart: Bool
}
