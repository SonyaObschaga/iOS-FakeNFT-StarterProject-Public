//
//  FavoriteNftsCollectionView+NFTViewProtocol.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 30.11.2025.
//

import Foundation

extension FavoriteNftsViewController: NFTViewProtocol {
    
    func updateNFTs(nfts: [NFTModel], likedNFTs: [NFTModel]) {
        self._likedNFTs = likedNFTs
    }
    
    
       func errorDetected(error: any Error)
       {
           // todo: report error
           print("Error detected: \(error.localizedDescription)")
       }


}
