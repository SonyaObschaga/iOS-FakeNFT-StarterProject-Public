//
//  NFTCardAssembly.swift
//  FakeNFT
//
//  Created by Илья on 07.12.2025.
//

import UIKit

final class NFTCardAssembly {
    private let servicesAssembly: ServicesAssembly

    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }

    func build(with input: NFTCardInput) -> UIViewController {
        let presenter = NFTCardPresenter(
            input: input,
            nftService: servicesAssembly.nftService,
            currencyService: servicesAssembly.currencyService,
            profileService: servicesAssembly.profileService,
            orderService: servicesAssembly.orderService
        )
        let viewController = NFTCardViewController()
        presenter.view = viewController
        viewController.presenter = presenter
        return viewController
    }
}
