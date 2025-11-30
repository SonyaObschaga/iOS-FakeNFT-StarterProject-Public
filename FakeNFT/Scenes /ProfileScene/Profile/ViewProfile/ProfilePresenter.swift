//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 30.11.2025.
//
import Foundation

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewProtocol?

    func viewDidLoad() {
        if !FakeNFTService.shared.profileFetched {
            FakeNFTService.shared.fetchProfile()
        }
        let profile = FakeNFTService.shared.profile
        
        view?.updateProfile(name: profile.name, descripton: profile.description, website: profile.website)
        view?.updateNftsCount(nftsCount: profile.nfts.count, likedNftsCount: profile.likedNFTs.count)
        if let avatar_url = profile.avatar {
            view?.updateAvatar(url: URL(string: avatar_url))
        }
    }
}
