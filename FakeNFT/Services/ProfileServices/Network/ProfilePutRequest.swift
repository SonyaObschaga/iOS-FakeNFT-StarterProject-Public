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
        
        // ok - self.dto = profile
        self.dto = ProfileDtoObject(
            name: profile.name,
            avatar: profile.avatar_url ?? "",
            description: profile.description ?? "",
            website: profile.website,
            nfts: profile.nfts ?? [],
            likes: profile.likes ?? []
        )
        
    }
   var endpoint: URL? {
       //error 404: URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(profile.id)")
       URL(string: "\(RequestConstants.baseURL)/api/v1/profile/\(index)")
   }
   var httpMethod: HttpMethod = .put
   //var dto: Dto? = profile
    /*
    func asDictionary() -> [String: String] {
        return [
            "name": profile.name,
            "avatar": self.profile.avatar_url!,
            "description": profile.description!
        ]
    }
     */
    var dto: Dto?
    
}

