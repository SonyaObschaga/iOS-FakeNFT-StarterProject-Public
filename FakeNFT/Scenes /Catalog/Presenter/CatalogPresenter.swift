//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Илья on 22.11.2025.
//

import Foundation

protocol CatalogPresenterProtocol {
    func viewDidLoad()
    func numberOfCollections() -> Int
    func collection(at index: Int) -> NFTCollection
    func didSelectCollection(at index: Int)
}

final class CatalogPresenter: CatalogPresenterProtocol {

    private var collections: [NFTCollection] = []
    weak var view: CatalogViewController?

    func viewDidLoad() {
        // Здесь получаем данные (сеть / локально)
        loadCollections()
    }

    func numberOfCollections() -> Int {
        return collections.count
    }

    func collection(at index: Int) -> NFTCollection {
        return collections[index]
    }

    func didSelectCollection(at index: Int) {
        let selected = collections[index]
        // Переходим на экран коллекции NFT
        print("Selected collection: \(selected.title)")
    }

    private func loadCollections() {
        // Пример данных
        collections = [
            NFTCollection(id: "1", title: "CryptoPunks", coverURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png")!, nftsCount: 100),
            NFTCollection(id: "2", title: "BoredApe", coverURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png")!, nftsCount: 50)
        ]
        view?.reloadTable()
    }
}
