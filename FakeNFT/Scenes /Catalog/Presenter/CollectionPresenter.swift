//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Илья on 29.11.2025.
//

import Foundation

protocol CollectionPresenterProtocol {
    func viewDidLoad()
    func numberOfNFTs() -> Int
    func nft(at index: Int) -> NFTItem
    func didTapFavorite(at index: Int)
    func didTapCart(at index: Int)
}

final class CollectionPresenter: CollectionPresenterProtocol {
    weak var view: CollectionViewProtocol?
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
        orderService: OrderService
    ) {
        self.input = input
        self.collectionsService = collectionsService
        self.nftService = nftService
        self.profileService = profileService
        self.orderService = orderService
    }
    
    private var currentLikesArray: [String] = []
        
    func viewDidLoad() {
        view?.showLoading()
        loadProfile()
        loadOrder()
    }
    
    private func loadProfile() {
        profileService.loadProfile(profileId: "1") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                self.favoriteNFTIds = Set(profile.likes)
                self.currentLikesArray = profile.likes  // Сохраняем массив
                self.loadCollection()
                
            case .failure(let error):
                print("Error loading profile: \(error)")
                self.loadCollection()
            }
        }
    }
    
    private func loadCollection() {
        collectionsService.loadCollection(by: input.collectionId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let collectionResponse):
                DispatchQueue.main.async {
                    self.view?.displayCollection(
                        title: collectionResponse.name,
                        description: collectionResponse.description ?? "",
                        author: collectionResponse.author ?? "",
                        coverURL: collectionResponse.cover
                    )
                }
                self.loadNFTs(ids: collectionResponse.nfts)
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.hideLoading()
                    print("Error loading collection: \(error)")
                }
            }
        }
    }
    
    private func loadOrder() {
            orderService.loadOrder(orderId: "1") { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let order):
                    self.cartNFTIds = Set(order.nfts)
                    self.currentCartArray = order.nfts
                    print("✅ Order loaded: \(order.nfts.count) items in cart")
                    
                case .failure(let error):
                    print("Error loading order: \(error)")
                }
            }
        }
    
    private func loadNFTs(ids: [String]) {
        guard !ids.isEmpty else {
            DispatchQueue.main.async {
                self.view?.hideLoading()
                self.view?.reloadNFTs()
            }
            return
        }
        
        let group = DispatchGroup()
        var loadedNFTs: [NFTItem] = []
        
        for nftId in ids {
            group.enter()
            
            nftService.loadNft(id: nftId) { result in
                defer { group.leave() }
                
                switch result {
                case .success(let nft):
                    let isFavorite = self.favoriteNFTIds.contains(nft.id)
                    let isInCart = self.cartNFTIds.contains(nft.id)
                    
                    let nftItem = NFTItem(
                        id: nft.id,
                        title: nft.name,
                        imageURL: nft.images.first ?? URL(string: "https://example.com")!,
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
            
            // Проверяем, есть ли NFT в избранном
            if favoriteNFTIds.contains(nftId) {
                // Удаляем из избранного
                favoriteNFTIds.remove(nftId)
                currentLikesArray.removeAll { $0 == nftId }
                print("❌ Removed from favorites: \(nftId)")
            } else {
                // Добавляем в избранное
                favoriteNFTIds.insert(nftId)
                currentLikesArray.append(nftId)
                print("❤️ Added to favorites: \(nftId)")
            }
            
            // Обновляем локально UI сразу для отзывчивости
            nftItems[index].isFavorite = favoriteNFTIds.contains(nftId)
            
            // Отправляем PUT запрос на сервер
            updateProfileLikes()
        }
    
    func didTapCart(at index: Int) {  // Новый метод
            guard index < nftItems.count else { return }
            
            let nftId = nftItems[index].id
            
            // Проверяем, есть ли NFT в корзине
            if cartNFTIds.contains(nftId) {
                // Удаляем из корзины
                cartNFTIds.remove(nftId)
                currentCartArray.removeAll { $0 == nftId }
                print("❌ Removed from cart: \(nftId)")
            } else {
                // Добавляем в корзину
                cartNFTIds.insert(nftId)
                currentCartArray.append(nftId)
                print("🛒 Added to cart: \(nftId)")
            }
            
            // Обновляем локально UI сразу
            nftItems[index].isInCart = cartNFTIds.contains(nftId)
            
            // Отправляем PUT запрос
            updateOrder()
        }
    
    private func updateOrder() {
            orderService.updateOrder(orderId: "1", nfts: currentCartArray) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let order):
                    // Обновляем локальные данные
                    self.cartNFTIds = Set(order.nfts)
                    self.currentCartArray = order.nfts
                    
                    // Обновляем все NFT items
                    for i in 0..<self.nftItems.count {
                        self.nftItems[i].isInCart = self.cartNFTIds.contains(self.nftItems[i].id)
                    }
                    
                    // Обновляем UI
                    DispatchQueue.main.async {
                        self.view?.reloadNFTs()
                    }
                    
                    print("✅ Order updated successfully")
                    
                case .failure(let error):
                    print("❌ Error updating order: \(error)")
                    // Откатываем изменения при ошибке
                    self.loadOrder()
                }
            }
        }
        
        private func updateProfileLikes() {
            profileService.updateProfile(profileId: "1", likes: currentLikesArray) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let profile):
                    // Обновляем локальные данные
                    self.favoriteNFTIds = Set(profile.likes)
                    self.currentLikesArray = profile.likes
                    
                    // Обновляем все NFT items
                    for i in 0..<self.nftItems.count {
                        self.nftItems[i].isFavorite = self.favoriteNFTIds.contains(self.nftItems[i].id)
                    }
                    
                    // Обновляем UI
                    DispatchQueue.main.async {
                        self.view?.reloadNFTs()
                    }
                    
                    print("✅ Profile updated successfully")
                    
                case .failure(let error):
                    print("❌ Error updating profile: \(error)")
                    
                    // Откатываем изменения при ошибке
                    self.loadProfile()
                }
            }
        }
}
