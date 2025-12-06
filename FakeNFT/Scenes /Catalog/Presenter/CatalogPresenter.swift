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

final class CatalogPresenter {

    private var collections: [NFTCollection] = []

    weak var view: CatalogViewProtocol?

    private let collectionsService: CollectionsService

    init(collectionsService: CollectionsService) {
        self.collectionsService = collectionsService
    }

    func viewDidLoad() {
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
        print("Selected collection: \(selected.id)")
        view?.showCollectionDetails(collectionId: selected.id)
    }

    private var currentSortOption: SortOption {
        get {
            let savedValue =
                UserDefaults.standard.string(
                    forKey: UserDefaultsKeys.catalogSortOption
                ) ?? ""
            return SortOption(rawValue: savedValue) ?? .default
        }
        set {
            UserDefaults.standard.set(
                newValue.rawValue,
                forKey: UserDefaultsKeys.catalogSortOption
            )
        }
    }

    private var originalCollections: [NFTCollection] = []

    private func loadCollections() {
        view?.showLoading()

        collectionsService.loadCollections { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let collections):
                self.originalCollections = collections
                self.collections = collections
                self.applySort(by: self.currentSortOption, shouldReload: false)

                DispatchQueue.main.async {
                    self.view?.hideLoading()
                    self.view?.reloadTable()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.hideLoading()
                    print("Error loading collections: \(error)")
                }
            }
        }
    }

    private func applySavedSortOption() {
        sortCollections(by: currentSortOption)
    }

    private func applySort(by option: SortOption, shouldReload: Bool) {
        switch option {
        case .default:
            collections = originalCollections
        case .byName:
            collections.sort { $0.title < $1.title }
        case .byNFTCount:
            collections.sort { $0.nftsCount > $1.nftsCount }
        }

        if shouldReload {
            view?.reloadTable()
        }
    }

    func sortCollections(by option: SortOption) {
        currentSortOption = option
        applySort(by: option, shouldReload: true)
    }
}

extension CatalogPresenter: CatalogPresenterProtocol {

}
