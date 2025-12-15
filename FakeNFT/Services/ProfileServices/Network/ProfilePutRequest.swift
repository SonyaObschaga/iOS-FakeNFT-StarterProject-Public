//
//  ProfilePutRequest.swift
//  TestFakeNFTWebAPI
//
//  Created by Damir Salakhetdinov on 04.12.2025.
//
import Foundation

struct ProfilePutRequest: NetworkRequest {
    private var index: Int
    private var profile: ProfileDto = ProfileDto()
    init(index: Int, profile: ProfileDto) {
        self.index = index
        self.profile = profile
        
        self.dto = SaveProfileDto(
            name: profile.name,
            avatar: profile.avatar ?? "",
            description: profile.description ?? "",
            website: profile.website,
            nfts: profile.nfts,
            likes: profile.likes
        )
        
    }
   var endpoint: URL? {
       URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(index)")
   }
    var httpMethod: HttpMethod = .put
    
    var dto: Dto?
    
}
