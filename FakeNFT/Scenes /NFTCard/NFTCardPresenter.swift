//
//  NFTCardPresenter.swift
//  FakeNFT
//
//  Created by Илья on 07.12.2025.
//

import Foundation

protocol NFTCardPresenterProtocol {
    func viewDidLoad()
    func didTapFavorite(at index: Int)
    func didTapCart(at index: Int)
    func numberOfNFTs() -> Int
    func nft(at index: Int) -> NFTItem
    func priceInUSD() -> Double
    func priceInCurrency(for currency: Currency) -> String
    func currencyRateInUSD(for currency: Currency) -> String
    func didTapBuyButton()
}

final class NFTCardPresenter: NFTCardPresenterProtocol {
    private enum Constants {
        static let profileId = "1"
        static let orderId = "1"
    }

    private let ethRateUSD: Double = 4000.0

    weak var view: NFTCardViewProtocol?
    private let input: NFTCardInput
    private let nftService: NftService
    private let currencyService: CurrencyService
    private let profileService: ProfileService
    private let orderService: OrderService

    private var nftItems: [NFTItem] = []
    private var cartNFTIds: Set<String> = []
    private var favoriteNFTIds: Set<String> = []
    private var currentCartArray: [String] = []
    private var currentLikesArray: [String] = []

    init(
        input: NFTCardInput,
        nftService: NftService,
        currencyService: CurrencyService,
        profileService: ProfileService,
        orderService: OrderService
    ) {
        self.input = input
        self.nftService = nftService
        self.currencyService = currencyService
        self.profileService = profileService
        self.orderService = orderService
    }

    func viewDidLoad() {
        loadData()
    }

    private func loadData() {
        loadInitialData()
        displayInitialNFTData()
        loadAsyncData()
    }

    private func loadInitialData() {
        loadProfile()
        loadOrder()
    }

    private func displayInitialNFTData() {
        view?.displayNFT(
            name: input.name,
            rating: input.rating,
            price: input.price,
            collectionName: input.collectionName
        )
        view?.displayNFTCollection(input.collectionNFTs)
    }

    private func loadAsyncData() {
        view?.showLoading()

        let group = DispatchGroup()

        loadNFTImages(group: group)
        loadCurrencies(group: group)

        group.notify(queue: .main) { [weak self] in
            self?.view?.hideLoading()
        }
    }

    private func loadNFTImages(group: DispatchGroup) {
        group.enter()
        nftService.loadNft(id: input.id) { [weak self] result in
            defer { group.leave() }
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let nft):
                    self.view?.displayImages(nft.images)
                case .failure(let error):
                    self.view?.hideLoading()
                    print("Error loading NFT images: \(error)")
                }
            }
        }
    }

    private func loadCurrencies(group: DispatchGroup) {
        group.enter()
        currencyService.loadCurrencies { [weak self] result in
            defer { group.leave() }
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let currencies):
                    self.view?.displayCurrencies(currencies)
                case .failure(let error):
                    print("Error loading currencies: \(error)")
                }
            }
        }
    }

    func priceInUSD() -> Double {
        return input.price * ethRateUSD
    }

    func currencyRateInUSD(for currency: Currency) -> String {
        return String(format: "$%.2f", currency.priceUsd)
    }

    func priceInCurrency(for currency: Currency) -> String {
        let priceETH = input.price
        let convertedPrice = convertPrice(from: priceETH, to: currency)
        return String(format: "%.2f %@", convertedPrice, currency.name)
    }

    private func loadProfile() {
        profileService.loadProfile(profileId: Constants.profileId) {
            [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let profile):
                self.favoriteNFTIds = Set(profile.likes)
                self.currentLikesArray = profile.likes
                self.updateNFTItemsWithFavorites()
                self.displayNFTCollection()

            case .failure(let error):
                print("Error loading profile: \(error)")
                self.displayNFTCollection()
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
                self.updateNFTItemsWithCart()

            case .failure(let error):
                print("Error loading order: \(error)")
            }
        }
    }

    private func updateNFTItemsWithFavorites() {
        for index in 0..<nftItems.count {
            nftItems[index].isFavorite = favoriteNFTIds.contains(
                nftItems[index].id
            )
        }
    }

    private func updateNFTItemsWithCart() {
        for index in 0..<nftItems.count {
            nftItems[index].isInCart = cartNFTIds.contains(nftItems[index].id)
        }
    }

    private func displayNFTCollection() {
        nftItems = input.collectionNFTs.map { nftItem in
            var updatedItem = nftItem
            updatedItem.isFavorite = favoriteNFTIds.contains(nftItem.id)
            updatedItem.isInCart = cartNFTIds.contains(nftItem.id)
            return updatedItem
        }
        view?.displayNFTCollection(nftItems)
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
        ) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let order):
                self.cartNFTIds = Set(order.nfts)
                self.currentCartArray = order.nfts
                self.nftItems[index].isInCart = self.cartNFTIds.contains(
                    self.nftItems[index].id
                )
                DispatchQueue.main.async { [weak self] in
                    self?.view?.reloadNFTCollectionItem(at: index)
                }

            case .failure(let error):
                print("Error updating order: \(error)")
                self.nftItems[index].isInCart = self.cartNFTIds.contains(
                    self.nftItems[index].id
                )
                DispatchQueue.main.async { [weak self] in
                    self?.view?.reloadNFTCollectionItem(at: index)
                }
                self.loadOrder()
            }
        }
    }

    private func updateProfileLikes(for index: Int) {
        profileService.updateProfile(
            profileId: Constants.profileId,
            likes: currentLikesArray
        ) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let profile):
                self.favoriteNFTIds = Set(profile.likes)
                self.currentLikesArray = profile.likes
                self.nftItems[index].isFavorite = self.favoriteNFTIds.contains(
                    self.nftItems[index].id
                )
                DispatchQueue.main.async { [weak self] in
                    self?.view?.reloadNFTCollectionItem(at: index)
                }

            case .failure(let error):
                print("Error updating profile: \(error)")
                self.nftItems[index].isFavorite = self.favoriteNFTIds.contains(
                    self.nftItems[index].id
                )
                DispatchQueue.main.async { [weak self] in
                    self?.view?.reloadNFTCollectionItem(at: index)
                }
                self.loadProfile()
            }
        }
    }

    private func convertPrice(from eth: Double, to currency: Currency) -> Double
    {
        let priceUSD = eth * ethRateUSD
        let currencyRate = currency.priceUsd
        return priceUSD / currencyRate
    }

    func didTapBuyButton() {
        let nftId = input.id

        if cartNFTIds.contains(nftId) {
            cartNFTIds.remove(nftId)
            currentCartArray.removeAll { $0 == nftId }
        } else {
            cartNFTIds.insert(nftId)
            currentCartArray.append(nftId)
        }

        updateOrderForCurrentNFT()
    }

    private func updateOrderForCurrentNFT() {
        orderService.updateOrder(
            orderId: Constants.orderId,
            nfts: currentCartArray
        ) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let order):
                self.cartNFTIds = Set(order.nfts)
                self.currentCartArray = order.nfts
                let isInCart = self.cartNFTIds.contains(self.input.id)
                DispatchQueue.main.async { [weak self] in
                    self?.view?.updateBuyButtonState(isInCart: isInCart)
                }
                print("Order updated successfully")

            case .failure(let error):
                print("Error updating order: \(error)")
                if self.cartNFTIds.contains(self.input.id) {
                    self.cartNFTIds.remove(self.input.id)
                    self.currentCartArray.removeAll { $0 == self.input.id }
                } else {
                    self.cartNFTIds.insert(self.input.id)
                    self.currentCartArray.append(self.input.id)
                }
                self.loadOrder()
            }
        }
    }

}
