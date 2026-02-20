//
//  CurrencyService.swift
//  FakeNFT
//
//  Created by Илья on 09.12.2025.
//

import Foundation

typealias CurrencyCompletion = (Result<[Currency], Error>) -> Void

protocol CurrencyService {
    func loadCurrencies(completion: @escaping CurrencyCompletion)
}

final class CurrencyServiceImpl: CurrencyService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadCurrencies(completion: @escaping CurrencyCompletion) {
        let request = CurrencyRequest()
        networkClient.send(request: request, type: [CurrencyResponse].self) {
            result in
            switch result {
            case .success(let responseArray):
                let currencies = responseArray.map { response in
                    let currencyID = CurrencyID(rawValue: response.id)
                    let rateUSD = currencyID?.rateUSD ?? 1.0

                    return Currency(
                        id: response.id,
                        title: response.title,
                        name: response.name,
                        imageURL: response.image,
                        priceUsd: rateUSD
                    )
                }
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
