//
//  CurrencyRequest.swift
//  FakeNFT
//
//  Created by Илья on 09.12.2025.
//

import Foundation

struct CurrencyRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
}
