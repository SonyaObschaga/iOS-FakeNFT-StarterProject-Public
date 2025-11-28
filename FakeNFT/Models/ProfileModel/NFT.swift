//
//  NFT.swift
//  TEST_TOOL2
//
//  Created by Damir Salakhetdinov on 24/11/25.
//

import Foundation

//class NFTModel: Codable {
class NFTModel: Encodable, Decodable {
    init() {
        createdAt = Date()
    }
    var createdAt: Date
    var name: String = ""
    var images: [String] = []
    var rating: Int? = 0
    var description: String? = ""
    var price: Float = 0
    var author: String = ""
    var id: String = ""
    var isLiked: Bool = false
}
