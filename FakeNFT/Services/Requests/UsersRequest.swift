import Foundation

struct UsersRequest: NetworkRequest {
    let page: Int
    let size: Int
    
    var endpoint: URL? {
        var components = URLComponents(string: "\(RequestConstants.baseURL)/api/v1/users")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "\(size)")
        ]
        return components?.url
    }
    
    var dto: Dto?
}

struct UserResponse: Decodable {
    let name: String
    let avatar: String?
    let website: String?
    let nfts: [String]
    let id: String
    let description: String?
    let likes: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case avatar
        case website
        case nfts
        case id
        case description
        case likes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        avatar = try? container.decode(String.self, forKey: .avatar)
        website = try? container.decode(String.self, forKey: .website)
        nfts = try container.decode([String].self, forKey: .nfts)
        id = try container.decode(String.self, forKey: .id)
        description = try? container.decode(String.self, forKey: .description)
        likes = try container.decodeIfPresent([String].self, forKey: .likes) ?? []
    }
}

