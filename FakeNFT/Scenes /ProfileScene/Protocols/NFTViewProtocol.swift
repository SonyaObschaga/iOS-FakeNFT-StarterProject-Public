//
//  NFTViewProtocol.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 30.11.2025.
//

import Foundation

protocol NFTViewProtocol: AnyObject {
    func updateNFTs(nfts: [NFTModel], likedNFTs: [NFTModel])
 
    func errorDetected(error: Error)
    func showLoading()
    func hideLoading()
}
