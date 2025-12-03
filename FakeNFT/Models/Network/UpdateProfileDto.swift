//
//  UpdateProfileDto.swift
//  FakeNFT
//
//  Created by Илья on 01.12.2025.
//

import Foundation

struct UpdateProfileDto: Dto {
    let likes: [String]
    
    func asDictionary() -> [String: String] {
        let likesString = likes.joined(separator: ",")
        return ["likes": likesString]
    }
}
