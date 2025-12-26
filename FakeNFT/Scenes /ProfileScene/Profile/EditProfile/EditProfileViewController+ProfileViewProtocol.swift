//
//  EditProfileViewController+ProfileViewProtocol.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 30.11.2025.
//

import Foundation
import UIKit

extension EditProfileViewController: ProfileViewProtocol {
    func updateProfile(name: String?, descripton: String?, website: String?) {
        nameTextField.text = name
        descriptionTextField.text = descripton
        urlTextField.text = website
    }
    
    func updateAvatar(url: URL?) {
        // TODO: retrieve image by URL
        let image = UIImage(resource: .joaquin).alpha(0.6)
        editPhotoButton.setBackgroundImage(image, for: .normal)
        editPhotoButton.setTitle(NSLocalizedString("EditProfile.changePhoto", comment: ""), for: .normal)
    }
    
    func updateNftsCount(nftsCount:Int, likedNftsCount:Int) {
        // not used here
    }

    func profileUpdated(profile: ProfileDto) {
        print("Profile updated id = \(profile.id)")
    }
 
    func errorDetected(error: any Error) {
        print("Error detected: \(error.localizedDescription)")
        showErrorDialog(title: NSLocalizedString("Error.title", comment: ""), message: error.localizedDescription)
    }
    
    func hideControls() {
        // not used here
    }

    func unhideControls() {
        // not used here
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
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
