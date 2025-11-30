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
        let presenter = CollectionPresenter(input: input)
        let viewController = CollectionViewController(servicesAssembly: servicesAssembly)
        presenter.view = viewController
        viewController.presenter = presenter
        return viewController
    }
}
