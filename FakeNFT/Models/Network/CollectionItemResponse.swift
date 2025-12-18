import Foundation

struct CollectionItemResponse: Decodable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let id: String
    
    // Handle potential typo in API response (descriprion instead of description)
    enum CodingKeys: String, CodingKey {
        case createdAt
        case name
        case images
        case rating
        case description
        case descriprion // Handle typo if API returns it
        case price
        case author
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        name = try container.decode(String.self, forKey: .name)
        images = try container.decode([String].self, forKey: .images)
        rating = try container.decode(Int.self, forKey: .rating)
        // Try to decode description, fallback to descriprion if needed
        if let desc = try? container.decode(String.self, forKey: .description) {
            description = desc
        } else if let desc = try? container.decode(String.self, forKey: .descriprion) {
            description = desc
        } else {
            description = ""
        }
        price = try container.decode(Double.self, forKey: .price)
        author = try container.decode(String.self, forKey: .author)
        id = try container.decode(String.self, forKey: .id)
    }
}
