import Foundation

struct UpdateLikeRequest: NetworkRequest {

    let nftId: String
    let isLiked: Bool
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(nftId)/likes")
    }
    
    var httpMethod: HttpMethod {
        if isLiked {
            return .put
        } else {
            return .delete
        }
    }
    
    var dto: (any Dto)?
    
    init(nftId: String, isLiked: Bool, dto: Encodable? = nil) {
        self.nftId = nftId
        self.isLiked = isLiked
    }
}
