//
//  CollectionByIdRequest.swift
//  FakeNFT
//
//  Created by Илья on 30.11.2025.
//

import Foundation

struct CollectionByIdRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections/\(id)")
    }
    var dto: Dto?
}
