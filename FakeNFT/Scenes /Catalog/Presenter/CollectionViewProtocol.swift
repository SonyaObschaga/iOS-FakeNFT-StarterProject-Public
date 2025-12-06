//
//  CollectionViewProtocol.swift
//  FakeNFT
//
//  Created by Илья on 29.11.2025.
//

import Foundation

protocol CollectionViewProtocol: AnyObject {
    func displayCollection(
        title: String,
        description: String,
        author: String,
        coverURL: URL
    )
    func reloadNFTs()
    func reloadNFT(at index: Int)
    func showLoading()
    func hideLoading()
}
