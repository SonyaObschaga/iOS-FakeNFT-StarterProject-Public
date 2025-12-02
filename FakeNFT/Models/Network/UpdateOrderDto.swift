//
//  UpdateOrderDto.swift
//  FakeNFT
//
//  Created by Илья on 02.12.2025.
//

import Foundation

struct UpdateOrderDto: Dto {
    let nfts: [String]
    
    func asDictionary() -> [String: String] {
        // Формируем строку с ID через запятую
        let nftsString = nfts.joined(separator: ",")
        return ["nfts": nftsString]
    }
}
