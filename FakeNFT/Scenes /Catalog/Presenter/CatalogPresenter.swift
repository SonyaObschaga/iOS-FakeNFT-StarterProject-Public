//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Илья on 22.11.2025.
//

import Foundation

protocol CatalogPresenterProtocol {
    func viewDidLoad()
    func numberOfCollections() -> Int
    func collection(at index: Int) -> NFTCollection
    func didSelectCollection(at index: Int)
    func sortCollections(by option: SortOption)
}

final class CatalogPresenter: CatalogPresenterProtocol {

    private var collections: [NFTCollection] = []
    
    weak var view: CatalogViewProtocol?
    
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
            return SortOption(rawValue: savedValue) ?? .default  // По умолчанию - без сортировки
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaultsKeys.catalogSortOption)
        }
    }
    
    // Сохраняем оригинальный порядок данных из JSON
    private var originalCollections: [NFTCollection] = []
    
    private func loadCollections() {
        DispatchQueue.main.async {
            self.view?.showLoading()
        }
        
        collectionsService.loadCollections { [weak self] result in
            switch result {
            case .success(let collections):
                // Сохраняем оригинальный порядок
                self?.originalCollections = collections
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
        
        // Применяем сортировку или возвращаем оригинальный порядок
        switch option {
        case .default:
            // Без сортировки - возвращаем оригинальный порядок из JSON
            collections = originalCollections
            
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
