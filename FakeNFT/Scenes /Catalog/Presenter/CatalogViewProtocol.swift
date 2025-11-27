//
//  CatalogViewProtocol.swift
//  FakeNFT
//
//  Created by Илья on 22.11.2025.
//

protocol CatalogViewProtocol: AnyObject {
    func reloadTable()
    func showLoading()
    func hideLoading()
    func showCollectionDetails(collectionId: String)
}
