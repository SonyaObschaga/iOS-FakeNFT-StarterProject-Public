//
//  ProfileDtoObject.swift
//  TestFakeNFTWebAPI
//
//  Created by Damir Salakhetdinov on 04.12.2025.
//

struct ProfileDtoObject: Dto {
   //let param1: String
   //let param2: String

    let name: String
    let avatar: String
    let description: String
    var website: String = ""
    var nfts: [String]
    var likes: [String]
    
    enum CodingKeys: String, CodingKey {
        //case param1 = "param_1" //имя поля в запросе будет param_1
        //case param2 //имя поля в запросе будет param_2
        case name
        case description
        case avatar
        case website
        case nfts
        case likes
    }

    var likesStr: String {
        if likes.isEmpty {
            return "[]"
        } else {
            return "\(likes.joined(separator: ", "))"
        }
    }
    var nftsStr: String {
        if nfts.isEmpty {
            return "[]"
        } else {
            return "\(nfts.joined(separator: ", "))"
        }
    }
    
    func asDictionary() -> [String : String] {
     [
        CodingKeys.name.rawValue: name,
        CodingKeys.avatar.rawValue: avatar,
        CodingKeys.description.rawValue: description,
        CodingKeys.website.rawValue: website,
        //CodingKeys.nfts.rawValue: nftsStr,
        CodingKeys.likes.rawValue: likesStr
     ].compactMapValues { value in
         // Filter out empty strings
         guard !value.isEmpty else { return nil }
         return value
     }
    }
}
