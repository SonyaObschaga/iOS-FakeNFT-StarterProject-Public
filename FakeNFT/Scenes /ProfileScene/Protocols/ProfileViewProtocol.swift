//
//  ProfileViewProtocol.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 29.11.2025.
//

import Foundation

protocol ProfileViewProtocol: AnyObject {
    func updateProfile(name: String? , descripton: String?, website: String?)
    func updateNftsCount(nftsCount:Int, likedNftsCount:Int)
    func updateAvatar(url: URL?)
    
    func profileUpdated(profile: ProfileDto)
    func errorDetected(error: Error)

    func hideControls()
    func unhideControls()
    
    func showLoading()
    func hideLoading()
    
    func showError(_ model: ErrorModel)

}
