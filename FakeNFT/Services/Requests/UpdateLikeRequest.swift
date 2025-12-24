import Foundation

struct UpdateLikeRequest: NetworkRequest {
    
    let nftId: String
    let isLiked: Bool
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(nftId)/likes")
    }
    
    var httpMethod: HttpMethod {
        isLiked ? .put : .delete
    }
    
    var dto: (any Dto)? { nil }
    
    init(nftId: String, isLiked: Bool) {
        self.nftId = nftId
        self.isLiked = isLiked
    }
}
