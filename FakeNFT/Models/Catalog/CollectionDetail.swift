//
//  CollectionDetail.swift
//  FakeNFT
//
//  Created by Илья on 29.11.2025.
//

import Foundation

struct CollectionDetail {
    let id: String
    let title: String
    let coverURL: URL
    let description: String
    let author: Author
    let nfts: [String]
}
