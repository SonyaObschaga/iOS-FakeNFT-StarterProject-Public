//
//  NFT.swift
//  TEST_TOOL2
//
//  Created by Damir Salakhetdinov on 24/11/25.
//

import Foundation

struct NFTModel: Encodable, Decodable {
    init() {
        createdAt = Date()
    }
    var createdAt: Date
    var name: String = ""
    var images: [String] = []
    var rating: Int? = 0
    var description: String? = ""
    var price: Double = 0
    var author: String = ""
    var id: String = ""
    var isLiked: Bool = false
    var nftAuthor: String {
            return name
        }
        var nftName: String {
            return extractSubstringFromURL(images[0])
        }

        private func extractSubstringFromURL(_ urlString: String) -> String {
            guard let url = URL(string: urlString) else {
                return "N/A"
            }
            
            // Get the path components of the URL
            let pathComponents = url.pathComponents
            
            // Find the component before the last one (which is the file name)
            if pathComponents.count >= 2 {
                return pathComponents[pathComponents.count - 2]
            }
            
            return "N/A"
        }
}
