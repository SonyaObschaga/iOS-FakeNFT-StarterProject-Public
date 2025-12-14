//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Илья on 29.11.2025.
//

import Foundation
import UIKit

protocol CollectionPresenterProtocol {
    func viewDidLoad()
    func numberOfNFTs() -> Int
    func nft(at index: Int) -> NFTItem
    func didTapFavorite(at index: Int)
    func didTapCart(at index: Int)
    func didSelectNFT(at index: Int, collectionName: String, allNFTs: [NFTItem])
}

final class CollectionPresenter: CollectionPresenterProtocol {
    private enum Constants {
        static let profileId = "1"
        static let orderId = "1"
    }

    weak var view: CollectionViewProtocol?
    weak var router: CollectionRouterProtocol?

    private let input: CollectionInput
    private let collectionsService: CollectionsService
    private let nftService: NftService
    private let profileService: ProfileService
    private let orderService: OrderService
    private var nftItems: [NFTItem] = []
    private var cartNFTIds: Set<String> = []
    private var favoriteNFTIds: Set<String> = []
    private var currentCartArray: [String] = []

    init(
        input: CollectionInput,
        collectionsService: CollectionsService,
        nftService: NftService,
        profileService: ProfileService,
        orderService: OrderService,
        router: CollectionRouterProtocol? = nil
    ) {
        self.input = input
        self.collectionsService = collectionsService
        self.nftService = nftService
        self.profileService = profileService
        self.orderService = orderService
        self.router = router
    }

    private var currentLikesArray: [String] = []

    func viewDidLoad() {
        view?.showLoading()
        loadProfile()
        loadOrder()
    }

    private func loadProfile() {
        profileService.loadProfile(profileId: Constants.profileId) {
            [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let profile):
                self.favoriteNFTIds = Set(profile.likes)
                self.currentLikesArray = profile.likes
                self.loadCollection()

            case .failure(let error):
                self.loadCollection()
            }
        }
    }

    private func loadCollection() {
        collectionsService.loadCollection(by: input.collectionId) {
            [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let collectionResponse):
                let name = collectionResponse.name
                let description = collectionResponse.description ?? ""
                let author = collectionResponse.author ?? ""
                let coverURL = collectionResponse.cover
                let nftIds = collectionResponse.nfts

                DispatchQueue.main.async { [weak self] in
                    self?.view?.displayCollection(
                        title: name,
                        description: description,
                        author: author,
                        coverURL: coverURL
                    )
                }
                self.loadNFTs(ids: nftIds)

            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.view?.hideLoading()
                }
            }
        }
    }

    private func loadOrder() {
        orderService.loadOrder(orderId: Constants.orderId) {
            [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let order):
                self.cartNFTIds = Set(order.nfts)
                self.currentCartArray = order.nfts

            case .failure(let error):
                print("Error loading order: \(error)")
            }
        }
    }

    private func loadNFTs(ids: [String]) {
        guard !ids.isEmpty else {
            DispatchQueue.main.async { [weak self] in
                self?.view?.hideLoading()
                self?.view?.reloadNFTs()
            }
            return
        }

        let group = DispatchGroup()
        var loadedNFTs: [NFTItem] = []

        for nftId in ids {
            group.enter()

            nftService.loadNft(id: nftId) { [weak self] result in
                defer { group.leave() }
                guard let self = self else { return }

                switch result {
                case .success(let nft):
                    let isFavorite = self.favoriteNFTIds.contains(nft.id)
                    let isInCart = self.cartNFTIds.contains(nft.id)

                    let nftItem = NFTItem(
                        id: nft.id,
                        title: nft.name,
                        imageURL: nft.images.first,
                        rating: Double(nft.rating),
                        price: nft.price,
                        isFavorite: isFavorite,
                        isInCart: isInCart
                    )
                    loadedNFTs.append(nftItem)

                case .failure(let error):
                    print("Error loading NFT \(nftId): \(error)")
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.nftItems = loadedNFTs.sorted { $0.id < $1.id }
            self?.view?.hideLoading()
            self?.view?.reloadNFTs()
        }
    }

    func numberOfNFTs() -> Int {
        return nftItems.count
    }

    func nft(at index: Int) -> NFTItem {
        return nftItems[index]
    }

    func didTapFavorite(at index: Int) {
        guard index < nftItems.count else { return }

        let nftId = nftItems[index].id

        if favoriteNFTIds.contains(nftId) {
            favoriteNFTIds.remove(nftId)
            currentLikesArray.removeAll { $0 == nftId }
        } else {
            favoriteNFTIds.insert(nftId)
            currentLikesArray.append(nftId)
        }

        nftItems[index].isFavorite = favoriteNFTIds.contains(nftId)
        updateProfileLikes(for: index)
    }

    func didTapCart(at index: Int) {
        guard index < nftItems.count else { return }

        let nftId = nftItems[index].id

        if cartNFTIds.contains(nftId) {
            cartNFTIds.remove(nftId)
            currentCartArray.removeAll { $0 == nftId }
        } else {
            cartNFTIds.insert(nftId)
            currentCartArray.append(nftId)
        }
        nftItems[index].isInCart = cartNFTIds.contains(nftId)
        updateOrder(for: index)
    }

    private func updateOrder(for index: Int) {
        orderService.updateOrder(
            orderId: Constants.orderId,
            nfts: currentCartArray
        ) {
            [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let order):
                self.cartNFTIds = Set(order.nfts)
                self.currentCartArray = order.nfts
                self.nftItems[index].isInCart = self.cartNFTIds.contains(
                    self.nftItems[index].id
                )
                DispatchQueue.main.async { [weak self] in
                    self?.view?.reloadNFT(at: index)
                }

            case .failure(let error):
                self.nftItems[index].isInCart = self.cartNFTIds.contains(
                    self.nftItems[index].id
                )
                DispatchQueue.main.async { [weak self] in
                    self?.view?.reloadNFT(at: index)
                }
                self.loadOrder()
            }
        }
    }

    private func updateProfileLikes(for index: Int) {
        profileService.updateProfile(
            profileId: Constants.profileId,
            likes: currentLikesArray
        ) {
            [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let profile):
                self.favoriteNFTIds = Set(profile.likes)
                self.currentLikesArray = profile.likes
                self.nftItems[index].isFavorite = self.favoriteNFTIds.contains(
                    self.nftItems[index].id
                )

                DispatchQueue.main.async { [weak self] in
                    self?.view?.reloadNFT(at: index)
                }

            case .failure(let error):
                self.nftItems[index].isFavorite = self.favoriteNFTIds.contains(
                    self.nftItems[index].id
                )
                DispatchQueue.main.async { [weak self] in
                    self?.view?.reloadNFT(at: index)
                }
                self.loadProfile()
            }
        }
    }

    func didSelectNFT(at index: Int, collectionName: String, allNFTs: [NFTItem]) {
        guard index < allNFTs.count else {
            print("⚠️ Index out of bounds: \(index) >= \(allNFTs.count)")
            return
        }
        guard let viewController = view?.viewController else {
            print("⚠️ View controller is nil")
            return
        }
        guard let router = router else {
            print("⚠️ Router is nil")
            return
        }
        
        let nftItem = allNFTs[index]
        let data = NFTSelectionData(
            nftItem: nftItem,
            collectionName: collectionName,
            collectionNFTs: allNFTs
        )
        
        print("✅ Navigating to NFTCard with id: \(nftItem.id)")
        router.showNFTCard(data: data, from: viewController)
    }

}
