import Foundation

struct Nft: Decodable {
<<<<<<< HEAD
        let id: String
        let name: String
        let images: [URL]
        let rating: Int
        let price: Double
        let description: String?
        let author: String?
        let createdAt: String?
=======
    let id: String
    let images: [URL]
    let name: String?
    let rating: Int?
    let price: Double?
    let author: String?
    let description: String?
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        images = try container.decode([URL].self, forKey: .images)
        name = try? container.decode(String.self, forKey: .name)
        rating = try? container.decode(Int.self, forKey: .rating)
        price = try? container.decode(Double.self, forKey: .price)
        author = try? container.decode(String.self, forKey: .author)
        createdAt = try? container.decode(String.self, forKey: .createdAt)
        isLiked = try? container.decode(Bool.self, forKey: .isLiked)
        
        if let desc = try? container.decode(String.self, forKey: .description) {
            description = desc
        } else if let desc = try? container.decode(String.self, forKey: .description) {
            description = desc
        } else {
            description = nil
        }
    }
>>>>>>> fresh-start-statistic
}
