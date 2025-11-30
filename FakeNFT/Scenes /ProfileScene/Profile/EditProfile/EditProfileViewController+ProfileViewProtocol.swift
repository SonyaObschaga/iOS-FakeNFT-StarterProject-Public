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
        editPhotoButton.setTitle("Сменить \n фото", for: .normal)
    }
    
    func updateNftsCount(nftsCount:Int, likedNftsCount:Int) {
        // not used here
    }

}
