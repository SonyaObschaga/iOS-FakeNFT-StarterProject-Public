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
    let rating: String
    let id: String
}

