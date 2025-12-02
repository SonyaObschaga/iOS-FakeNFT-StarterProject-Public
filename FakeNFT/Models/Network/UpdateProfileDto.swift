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
        // Формируем строку с ID через запятую
        let likesString = likes.joined(separator: ",")
        return ["likes": likesString]
    }
}
