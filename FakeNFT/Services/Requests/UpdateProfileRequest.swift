//
//  UpdateProfileRequest.swift
//  FakeNFT
//
//  Created by Илья on 01.12.2025.
//

import Foundation

struct UpdateProfileRequest: NetworkRequest {
    let profileId: String
    let likes: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(profileId)")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var dto: Dto? {
        UpdateProfileDto(likes: likes)
    }
}
