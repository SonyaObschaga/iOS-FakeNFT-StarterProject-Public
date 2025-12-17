//
//  ProfileViewController+ProfileViewProtocol.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 30.11.2025.
//

import Foundation
import UIKit

extension ProfileViewController: ProfileViewProtocol {
    func updateProfile(name: String?, descripton: String?, website: String?) {
        nameLabel.text = name
        bioTextView.text = descripton
        urlButton.setTitle(website, for: .normal)
    }
    
    func updateNftsCount(nftsCount:Int, likedNftsCount:Int) {
        DispatchQueue.global().async { [weak self ] in
            guard let self = self else { return }
            
            self.tableCells[0].count = nftsCount
            self.tableCells[1].count = likedNftsCount
            
            DispatchQueue.main.async {
                let indexPathsToReload = [IndexPath(row: 0, section: 0), IndexPath(row: 1, section: 0)]
                self.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
            }
        }
    }
    
    func updateAvatar(url: URL?) {
        avatarImageView.image = UIImage(named: "Joaquin")
    }
    
    
    func profileUpdated(profile: ProfileDto)
    {
        DispatchQueue.main.async {
            
            self.nameLabel.text = profile.name
            self.bioTextView.text = profile.description
            self.urlButton.setTitle(profile.website, for: .normal)
        }
        
        let nftsCount = profile.nfts.count
        let likedNftsCount = profile.likes.count
        updateNftsCount(nftsCount:nftsCount, likedNftsCount:likedNftsCount)
    }
    
    func errorDetected(error: any Error)
    {
        print("Error detected: \(error.localizedDescription)")
        showErrorDialog(title: NSLocalizedString("Error.title", comment: ""), message: error.localizedDescription)
    }
    
    func hideControls() {
        for sw in view.subviews {
            sw.alpha = 0
        }
        activityIndicator.alpha = 1
    }
    
    func unhideControls() {
        view.alpha = 1
        
        for sw in view.subviews {
            sw.alpha = 1
        }
    }
    
    func showErrorDialog(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Common.ok", comment: ""), style: .default) { _ in
            // Handle the OK button tap (optional)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
