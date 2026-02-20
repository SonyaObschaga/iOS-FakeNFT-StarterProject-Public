//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Илья on 02.12.2025.
//

import Foundation

struct OrderRequest: NetworkRequest {
    let orderId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)")
    }
    
    var httpMethod: HttpMethod {
        .get
    }
    
    var dto: Dto? {
        nil
    }
}
