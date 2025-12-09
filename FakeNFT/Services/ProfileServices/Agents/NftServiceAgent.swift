//
//  NftServiceAgent.swift
//  TestFakeNFTWebAPI
//
//  Created by Damir Salakhetdinov on 04.12.2025.
//

import Foundation

final class NftServiceAgent {
    //weak var view: NftViewProtocol?
  
    let service : NftService //Impl
    
    init(_ networkClient: DefaultNetworkClient, _ storage:NftStorageImpl) {
        self.service = NftServiceImpl(networkClient: DefaultNetworkClient(), storage: NftStorageImpl())
    }
    init(_ service: NftService) { //Impl) {
        self.service = service
    }

    var nft: Nft = Nft.emptyNft
    
    var loadingProgress: Bool = false
    
    private func showLoading() {
        loadingProgress = true
        //DispatchQueue.main.async { self.view?.showLoading() }
    }
    private func hideLoading() {
        //DispatchQueue.main.async {
            //self.view?.hideLoading()
        //}
        loadingProgress = false
    }

    func loadNft(nftId: String) {
        showLoading()
        
        self.service.loadNft(id: nftId) { [weak self] result in
            switch result {
            case .success(let nft):
                self?.nft = nft
                //self?.applySavedSortOption()
                self?.hideLoading()
                //self?.reloadTable()
                
            case .failure(let error):
                self?.hideLoading()
                print("Error loading NFT: \(error)")
            }
        }
    }
}

