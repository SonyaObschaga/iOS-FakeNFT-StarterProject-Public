//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Илья on 22.11.2025.
//

import Foundation
import UIKit

protocol CatalogPresenterProtocol {
    func viewDidLoad()
    func numberOfCollections() -> Int
    func collection(at index: Int) -> NFTCollection
    func didSelectCollection(at index: Int)
    func sortCollections(by option: SortOption)
}

enum SortOption: String {
    case byName = "byName"
    case byNFTCount = "byNFTCount"
    
    // Значение по умолчанию
    static let `default`: SortOption = .byNFTCount
}

// Добавить константу для ключа UserDefaults
private enum UserDefaultsKeys {
    static let catalogSortOption = "CatalogSortOption"
}

final class CatalogPresenter: CatalogPresenterProtocol {

    private var collections: [NFTCollection] = []
    weak var view: CatalogViewController?
    
    private let collectionsService: CollectionsService
    
    init(collectionsService: CollectionsService) {
        self.collectionsService = collectionsService
    }
    
    func viewDidLoad() {
        // Здесь получаем данные (сеть / локально)
        loadCollections()
    }
    
    func numberOfCollections() -> Int {
        return collections.count
    }
    
    func collection(at index: Int) -> NFTCollection {
        return collections[index]
    }
    
    func didSelectCollection(at index: Int) {
        let selected = collections[index]
        // Переходим на экран коллекции NFT
        print("Selected collection: \(selected.id)")
    }
    
    private var currentSortOption: SortOption {
            get {
                let savedValue = UserDefaults.standard.string(forKey: UserDefaultsKeys.catalogSortOption) ?? ""
                return SortOption(rawValue: savedValue) ?? .default
            }
            set {
                UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaultsKeys.catalogSortOption)
            }
        }
    
    private func loadCollections() {
        DispatchQueue.main.async {
            self.view?.showLoading()
        }
        
        collectionsService.loadCollections { [weak self] result in
            switch result {
            case .success(let collections):
                self?.collections = collections
                // Применяем сохранённую сортировку после загрузки данных
                self?.applySavedSortOption()
                DispatchQueue.main.async {
                    self?.view?.hideLoading()
                    self?.view?.reloadTable()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.view?.hideLoading()
                    print("Error loading collections: \(error)")
                }
            }
        }
    }
    
    private func applySavedSortOption() {
            sortCollections(by: currentSortOption)
        }
    
    func sortCollections(by option: SortOption) {
        // Сохраняем выбранную сортировку (setter автоматически сохранит в UserDefaults)
        currentSortOption = option
        
        // Применяем сортировку
        switch option {
        case .byName:
            // Сортировка по названию (A-Z)
            collections.sort { $0.title < $1.title }
            
        case .byNFTCount:
            // Сортировка по количеству NFT (от большего к меньшему)
            collections.sort { $0.nftsCount > $1.nftsCount }
        }
        
        // Обновляем таблицу после сортировки
        view?.reloadTable()
    }
}
