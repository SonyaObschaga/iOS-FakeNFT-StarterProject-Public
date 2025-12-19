import Foundation

struct Nft: Decodable {
    let id: String
    let images: [URL]
    let name: String?
    let rating: Int?
    let price: Double?
    let author: String?
    let description: String?
    let createdAt: String?
    
    // Handle potential typo in API response (descriprion instead of description)
    enum CodingKeys: String, CodingKey {
        case id
        case images
        case name
        case rating
        case price
        case author
        case description
        case descriprion // Handle typo if API returns it
        case createdAt
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
        
        // Try to decode description, fallback to descriprion if needed
        if let desc = try? container.decode(String.self, forKey: .description) {
            description = desc
        } else if let desc = try? container.decode(String.self, forKey: .descriprion) {
            description = desc
        } else {
            description = nil
        }
    }
}
