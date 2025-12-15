//
//  FavoriteNftsCollectionView+NFTViewProtocol.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 30.11.2025.
//

import Foundation
import UIKit

extension FavoriteNftsViewController: NFTViewProtocol {
    
    func updateNFTs(nfts: [NFTModel], likedNFTs: [NFTModel]) {
        DispatchQueue.main.async {
            self.hideLoading()
            self.likedNFTs = likedNFTs
            self.toggleControlsVisibility()
            self.nftCollectionView.reloadData()
        }
    }
    
   func errorDetected(error: any Error)
   {
       print("Error detected: \(error.localizedDescription)")
       showErrorDialog(title: "Error", message: error.localizedDescription)
   }

    func showErrorDialog(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
