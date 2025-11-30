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
         tableCells[0].count = nftsCount
         tableCells[1].count = likedNftsCount
     }
     
     func updateAvatar(url: URL?) {
         // TODO: retrieve image by URL
          avatarImageView.image = UIImage(named: "Joaquin")
     }
 
 }
 
