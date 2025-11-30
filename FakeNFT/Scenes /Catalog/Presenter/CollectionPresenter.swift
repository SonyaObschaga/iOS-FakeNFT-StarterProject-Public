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
}

final class CollectionPresenter: CollectionPresenterProtocol {
    weak var view: CollectionViewProtocol?
    private let input: CollectionInput
    
    // Мок-данные для верстки
    private let mockData = (
        title: "Test Collection",
        description: "Test description for collection",
        author: "Test Author",
        coverURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Обложки_коллекций/Brown.png")!
    )
    
    init(input: CollectionInput) {
        self.input = input
    }
    
    func viewDidLoad() {
        // Показать мок-данные для верстки
        DispatchQueue.main.async {
            self.view?.showLoading()
        }
        
        // Имитация загрузки
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.view?.displayCollection(
                title: self.mockData.title,
                description: self.mockData.description,
                author: self.mockData.author,
                coverURL: self.mockData.coverURL
            )
            self.view?.hideLoading()
            self.view?.reloadNFTs()
        }
    }
    
    func numberOfNFTs() -> Int {
        return 0 // Пока без NFT для верстки
    }
}
