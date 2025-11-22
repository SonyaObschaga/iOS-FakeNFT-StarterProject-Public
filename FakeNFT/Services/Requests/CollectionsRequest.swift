//
//  CollectionsRequest.swift
//  FakeNFT
//
//  Created by Илья on 22.11.2025.
//

import Foundation

struct CollectionsRequest: NetworkRequest {
   // let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
    var dto: Dto?
}
