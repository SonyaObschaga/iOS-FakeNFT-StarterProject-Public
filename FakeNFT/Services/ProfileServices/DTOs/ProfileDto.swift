//
//  ProfileDto.swift
//  TEST_TOOL2
//
//  Created by Damir Salakhetdinov on 24/11/25.
//

import Foundation

struct ProfileDto: Decodable {
    var id: String = ""
    var name: String = ""
    var avatar: String?
    var description: String?
    var website: String = ""
    var nfts: [String] = []
    var likes: [String] = []
}
