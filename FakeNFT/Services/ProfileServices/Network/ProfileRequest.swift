//
//  ProfilesRequest.swift
//  TestFakeNFTWebAPI
//
//  Created by Damir Salakhetdinov on 02.12.2025.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    init(id: Int) {
        self.id = "\(id)"
    }
    init(id: String) {
        self.id = id
    }
 
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(id)")
    }
    var dto: Dto?
}

