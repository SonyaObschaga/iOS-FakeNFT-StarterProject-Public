import UIKit

struct UpdateLikeRequest: NetworkRequest {
    let userId: String
    let nftId: String
    let isLiked: Bool
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(userId)")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var dto: (any Dto)? {
        UpdateLikeDto(nftId: nftId, isLiked: isLiked)
    }
    
    init(userId: String, nftId: String, isLiked: Bool) {
        self.userId = userId
        self.nftId = nftId
        self.isLiked = isLiked
    }
}

struct UpdateLikeDto: Dto {
    let nftId: String
    let isLiked: Bool
    
    func asDictionary() -> [String: String] {
        return ["likes": "\(nftId)"]
    }
}
