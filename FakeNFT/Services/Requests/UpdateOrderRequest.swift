//
//  UpdateOrderRequest.swift
//  FakeNFT
//
//  Created by Илья on 02.12.2025.
//

import Foundation

struct UpdateOrderRequest: NetworkRequest {
    let orderId: String
    let nfts: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var dto: Dto? {
        UpdateOrderDto(nfts: nfts)
    }
}
