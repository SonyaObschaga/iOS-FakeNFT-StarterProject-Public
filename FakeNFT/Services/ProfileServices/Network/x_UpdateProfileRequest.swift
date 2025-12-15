//import Foundation
//
//struct UpdateProfileRequest: NetworkRequest {
//    let profileId: String
//    let likes: [String]
//    
//    var endpoint: URL? {
//        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(profileId)")
//    }
//    
//    var httpMethod: HttpMethod {
//        .put
//    }
//    
//    var dto: Dto? {
//        UpdateProfileDto(likes: likes)
//    }
//}
