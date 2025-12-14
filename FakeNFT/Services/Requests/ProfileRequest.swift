//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Илья on 01.12.2025.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    let profileId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(profileId)")
    }
    
    var httpMethod: HttpMethod {
        .get
    }
    
    var dto: Dto? {
        nil
    }
}
