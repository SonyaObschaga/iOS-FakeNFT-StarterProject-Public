//
//  Untitled.swift
//  FakeNFT
//
//  Created by Илья on 10.12.2025.
//

import Foundation

enum CurrencyID: String {
    case shibaInu = "0"
    case cardano = "1"
    case tether = "2"
    case apeCoin = "3"
    case solana = "4"
    case bitcoin = "5"
    case dogecoin = "6"
    case ethereum = "7"
    
    var rateUSD: Double {
        switch self {
        case .shibaInu: return 0.000009
        case .cardano: return 0.50
        case .tether: return 1.00
        case .apeCoin: return 1.50
        case .solana: return 100.0
        case .bitcoin: return 45000.0
        case .dogecoin: return 0.08
        case .ethereum: return 2500.0
        }
    }
}
