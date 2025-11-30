//
//  NFTPresenter.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 30.11.2025.
//

import Foundation

final class NFTPresenter: NFTPresenterProtocol {
    
    weak var view: NFTViewProtocol?
    
    func viewDidLoad() {
        let profile = FakeNFTService.shared.profile
        view?.updateNFTs(nfts: profile.nfts, likedNFTs: profile.likedNFTs)
    }
}

