//
//  NFTPresenterProtocol.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 30.11.2025.
//

import Foundation

protocol NFTPresenterProtocol: AnyObject {
    var view: NFTViewProtocol? { get set }
    func viewDidLoad()
    func sortNFTs(by sortField: UserNFTCollectionSortField)
    func toggleLike(nftId: String)
}
