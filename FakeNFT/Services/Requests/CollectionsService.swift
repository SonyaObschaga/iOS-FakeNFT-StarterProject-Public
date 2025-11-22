//
//  CollectionsService.swift
//  FakeNFT
//
//  Created by Илья on 22.11.2025.
//

import Foundation

// Тип для completion handler
typealias CollectionsCompletion = (Result<[NFTCollection], Error>) -> Void

// Протокол сервиса
protocol CollectionsService {
    func loadCollections(completion: @escaping CollectionsCompletion)
}

// Реализация сервиса
final class CollectionsServiceImpl: CollectionsService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCollections(completion: @escaping CollectionsCompletion) {
        // 1. Создаём запрос
        let request = CollectionsRequest()
        
        // 2. Отправляем запрос, получаем [CollectionResponse]
        networkClient.send(request: request, type: [CollectionResponse].self) { result in
            switch result {
            case .success(let responseArray):
                // 3. Преобразуем [CollectionResponse] → [NFTCollection]
                let collections = responseArray.map { response in
                    NFTCollection(
                        id: response.id,
                        title: response.name,           // name → title
                        coverURL: response.cover,       // cover → coverURL
                        nftsCount: response.nfts.count  // количество NFT
                    )
                }
                completion(.success(collections))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
