//
//  CurrencyResponse.swift
//  FakeNFT
//
//  Created by Илья on 09.12.2025.
//

import Foundation

struct CurrencyResponse: Decodable {
    let id: String
    let title: String
    let name: String
    let image: URL
}
