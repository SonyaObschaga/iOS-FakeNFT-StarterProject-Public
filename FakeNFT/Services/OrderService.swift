//
//  OrderService.swift
//  FakeNFT
//
//  Created by Илья on 02.12.2025.
//

import Foundation

typealias OrderCompletion = (Result<OrderResponse, Error>) -> Void

protocol OrderService {
    func loadOrder(orderId: String, completion: @escaping OrderCompletion)
    func updateOrder(orderId: String, nfts: [String], completion: @escaping OrderCompletion)
}

final class OrderServiceImpl: OrderService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadOrder(orderId: String, completion: @escaping OrderCompletion) {
        let request = OrderRequest(orderId: orderId)
        networkClient.send(request: request, type: OrderResponse.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateOrder(orderId: String, nfts: [String], completion: @escaping OrderCompletion) {
        let request = UpdateOrderRequest(orderId: orderId, nfts: nfts)
        networkClient.send(request: request, type: OrderResponse.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
