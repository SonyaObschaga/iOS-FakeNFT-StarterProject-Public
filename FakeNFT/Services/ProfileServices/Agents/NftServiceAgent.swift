//
//  NftServiceAgent.swift
//  TestFakeNFTWebAPI
//
//  Created by Damir Salakhetdinov on 04.12.2025.
//

import Foundation

final class NftServiceAgent {
  
    let service : NftService //Impl
    
    init(_ networkClient: DefaultNetworkClient, _ storage:NftStorageImpl) {
        self.service = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
    }
    init(_ service: NftService) {
        self.service = service
    }
    //public static var emptyNft: Nft = Nft(id:"", images: [], rating:0, description:"", price:0, author:"")
    //var nft: Nft = Nft.emptyNft
    static var nft = Nft(id:"", images: [], rating:0, description:"", price:0, author:"")
    
    var loadingProgress: Bool = false
    
    private func showLoading() {
        loadingProgress = true
    }
    private func hideLoading() {
        loadingProgress = false
    }

    func loadNft(nftId: String) {
        showLoading()
        
        self.service.loadNft(id: nftId) { [weak self] result in
            switch result {
            case .success(let nft):
                NftServiceAgent.nft = nft
                self?.hideLoading()
                
            case .failure(let error):
                self?.hideLoading()
                print("Error loading NFT: \(error)")
            }
        }
    }
}

