//
//  CollectionRouter.swift
//  FakeNFT
//
//  Created by Илья on 12.12.2025.
//

import UIKit

protocol CollectionRouterProtocol: AnyObject {
    func showNFTCard(data: NFTSelectionData, from viewController: UIViewController)
}

final class CollectionRouter: CollectionRouterProtocol {
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func showNFTCard(data: NFTSelectionData, from viewController: UIViewController) {
        let nftCardAssembly = NFTCardAssembly(servicesAssembly: servicesAssembly)
        let nftCardInput = NFTCardInput(
            id: data.nftItem.id,
            name: data.nftItem.title,
            collectionName: data.collectionName,
            price: data.nftItem.price,
            rating: Int(data.nftItem.rating),
            collectionNFTs: data.collectionNFTs
        )
        let nftCardVC = nftCardAssembly.build(with: nftCardInput)
        viewController.navigationController?.pushViewController(nftCardVC, animated: true)
    }
}
