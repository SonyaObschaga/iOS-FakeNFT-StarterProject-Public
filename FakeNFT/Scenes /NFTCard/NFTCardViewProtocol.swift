//
//  NFTCardViewProtocol.swift
//  FakeNFT
//
//  Created by Илья on 07.12.2025.
//

import Foundation

protocol NFTCardViewProtocol: AnyObject {
    func displayNFT(name: String, rating: Int, price: Double, collectionName: String)
    func displayImages(_ imageURLs: [URL])
    func displayCurrencies(_ currencies: [Currency])
    func displayNFTCollection(_ nftItems: [NFTItem])
    func reloadNFTCollectionItem(at index: Int) 
    func showLoading()
    func hideLoading()
    func updateBuyButtonState(isInCart: Bool) 
}
