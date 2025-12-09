//
//  MyNftViewController+NFTViewProtocol.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 30.11.2025.
//

import Foundation

extension MyNftViewController: NFTViewProtocol {
    func updateNFTs(nfts: [NFTModel], likedNFTs: [NFTModel]) {
        DispatchQueue.main.async {
            self.hideLoading()
            self.nfts = nfts
            self.toggleControlsVisibility()
            self.tableView1.reloadData()
        }
    }
        
   func errorDetected(error: any Error)
   {
       print("Error detected: \(error.localizedDescription)")
   }


}
