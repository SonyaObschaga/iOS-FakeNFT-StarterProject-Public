import Foundation

struct ProfileRequest: NetworkRequest {
    let userId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(userId)")
    }
    
    var httpMethod: HttpMethod { .get }
    var dto: (any Dto)? { nil }
}

struct UpdateProfileRequest: NetworkRequest {
    let userId: String
    let likes: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(userId)")
    }
    
    var httpMethod: HttpMethod { .put }
    
    var dto: (any Dto)? {
        UpdateProfileDto(likes: likes)
    }
}

struct UpdateProfileDto: Dto {
    let likes: [String]
    
    func asDictionary() -> [String: String] {
        if likes.isEmpty {
            return ["likes": "[]"]
        }
        
        let likesString = likes.joined(separator: ",")
        return ["likes": likesString]
    }
}

struct ProfileResponse: Decodable {
    let id: String
    let likes: [String]
}
