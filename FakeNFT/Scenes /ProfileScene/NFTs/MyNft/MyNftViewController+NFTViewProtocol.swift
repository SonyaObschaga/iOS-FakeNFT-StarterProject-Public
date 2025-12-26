//
//  MyNftViewController+NFTViewProtocol.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 30.11.2025.
//

import Foundation
import UIKit

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
       showErrorDialog(title: NSLocalizedString("Error.title", comment: ""), message: error.localizedDescription)
   }

    func showErrorDialog(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Common.ok", comment: ""), style: .default) { _ in            // Handle the OK button tap (optional)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
