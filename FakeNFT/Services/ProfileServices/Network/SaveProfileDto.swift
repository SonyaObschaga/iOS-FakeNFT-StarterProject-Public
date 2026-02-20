//
//  ProfileDtoObject.swift
//  TestFakeNFTWebAPI
//
//  Created by Damir Salakhetdinov on 04.12.2025.
//

struct SaveProfileDto: Dto {
    let name: String
    let avatar: String
    let description: String
    var website: String = ""
    var nfts: [String]
    var likes: [String]
    
    var likesStr: String {

            return "\(likes.joined(separator: ", "))"
    }

    var nftsStr: String {
            return "\(nfts.joined(separator: ", "))"
    }

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case avatar
        case website
        case nfts
        case likes
    }

    func asDictionary() -> [String : String] {
     [
        CodingKeys.name.rawValue: name,
        CodingKeys.avatar.rawValue: avatar,
        CodingKeys.description.rawValue: description,
        CodingKeys.website.rawValue: website,
        CodingKeys.nfts.rawValue: nftsStr,
        CodingKeys.likes.rawValue: likesStr
     ].compactMapValues { value in
         // Filter out empty strings
         guard !value.isEmpty else { return nil }
         return value
     }
    }
}
