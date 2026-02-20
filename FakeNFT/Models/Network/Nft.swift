import Foundation

struct Nft: Decodable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let price: Double
    let description: String?
    let author: String?
    let createdAt: String?
    var isLiked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case images
        case name
        case rating
        case price
        case author
        case description
        case createdAt
        case isLiked = "likes"
    }
}
