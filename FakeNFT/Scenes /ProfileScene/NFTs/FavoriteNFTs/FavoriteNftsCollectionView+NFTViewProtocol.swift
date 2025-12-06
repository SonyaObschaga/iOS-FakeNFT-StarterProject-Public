//
//  FavoriteNftsCollectionView+NFTViewProtocol.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 30.11.2025.
//

import Foundation

extension FavoriteNftsViewController: NFTViewProtocol {
    
    func updateNFTs(nfts: [NFTModel], likedNFTs: [NFTModel]) {
        DispatchQueue.main.async {
            self.hideLoading()
            self._likedNFTs = likedNFTs
            self.toggleControlsVisibility()
            self.nftCollectionView.reloadData()
        }
    }
    
   func errorDetected(error: any Error)
   {
       // todo: report error
       print("Error detected: \(error.localizedDescription)")
   }


}
