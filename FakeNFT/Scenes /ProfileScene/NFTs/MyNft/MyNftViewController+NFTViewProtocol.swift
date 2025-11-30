//
//  MyNftViewController+NFTViewProtocol.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 30.11.2025.
//

import Foundation

extension MyNftViewController: NFTViewProtocol {
    func updateNFTs(nfts: [NFTModel], likedNFTs: [NFTModel]) {
        self._nfts = nfts
    }

}
