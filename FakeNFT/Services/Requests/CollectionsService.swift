//
//  CollectionsService.swift
//  FakeNFT
//
//  Created by Илья on 22.11.2025.
//

import Foundation

typealias CollectionsCompletion = (Result<[NFTCollection], Error>) -> Void

protocol CollectionsService {
    func loadCollections(completion: @escaping CollectionsCompletion)
}

final class CollectionsServiceImpl: CollectionsService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCollections(completion: @escaping CollectionsCompletion) {
        let request = CollectionsRequest()
        
        networkClient.send(request: request, type: [CollectionResponse].self) { result in
            switch result {
            case .success(let responseArray):
                let collections = responseArray.map { response in
                    NFTCollection(
                        id: response.id,
                        title: response.name,         
                        coverURL: response.cover,
                        nftsCount: response.nfts.count
                    )
                }
                completion(.success(collections))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
