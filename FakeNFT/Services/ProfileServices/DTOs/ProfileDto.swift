//
//  ProfileDto.swift
//  TEST_TOOL2
//
//  Created by Damir Salakhetdinov on 24/11/25.
//

import Foundation

struct ProfileDto: Codable, Dto {
    func dto() -> ProfileDto {
        return self //ProfileDto(name:"", avatar_url: "", description: "", website: "", nfts: [], likes:[], id:"")
    }
    
    public static var EmptyProfile: ProfileDto = ProfileDto()
 
    func asDictionary() -> [String: String] {
        return [
            "name": name,
            "avatar": avatar_url ?? "",
            "description": description ?? ""
        ]
    }
    
    var name: String = ""
    var avatar_url: String?
    var description: String?
    var website: String = ""
    var nfts: [String]?
    var likes: [String]?
    var id: String = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case avatar_url = "avatar"
        case description
        case website
        case nfts
        case likes
        case id
        }
}
