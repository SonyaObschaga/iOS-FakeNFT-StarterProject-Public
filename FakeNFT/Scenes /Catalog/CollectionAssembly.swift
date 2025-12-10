//
//  CollectionAssembly.swift
//  FakeNFT
//
//  Created by Илья on 29.11.2025.
//

import UIKit

final class CollectionAssembly {
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func build(with input: CollectionInput) -> UIViewController {
        let presenter = CollectionPresenter(
            input: input,
            collectionsService: servicesAssembly.collectionsService,
            nftService: servicesAssembly.nftService,
            profileService: servicesAssembly.profileService,
            orderService: servicesAssembly.orderService
        )
        let viewController = CollectionViewController()

        viewController.onNftSelected = {
            [weak viewController] nftId, name, price, rating, collectionName in
            guard let presenter = viewController?.presenter else { return }
            var collectionNFTs: [NFTItem] = []
            for i in 0..<presenter.numberOfNFTs() {
                collectionNFTs.append(presenter.nft(at: i))
            }

            let nftCardAssembly = NFTCardAssembly(
                servicesAssembly: self.servicesAssembly
            )
            let nftCardInput = NFTCardInput(
                id: nftId,
                name: name,
                collectionName: collectionName,
                price: price,
                rating: rating,
                collectionNFTs: collectionNFTs
            )
            let nftCardVC = nftCardAssembly.build(with: nftCardInput)
            viewController?.navigationController?.pushViewController(
                nftCardVC,
                animated: true
            )
        }

        presenter.view = viewController
        viewController.presenter = presenter
        return viewController
    }
}
