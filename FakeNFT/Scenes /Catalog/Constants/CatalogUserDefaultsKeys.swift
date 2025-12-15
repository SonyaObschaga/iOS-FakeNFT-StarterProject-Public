//
//  CatalogUserDefaultsKeys.swift.swift
//  FakeNFT
//
//  Created by Илья on 24.11.2025.
//

internal enum SortOption: String {
    case `default` = "default"
    case byName = "byName"
    case byNFTCount = "byNFTCount"
}

internal enum UserDefaultsKeys {
    static let catalogSortOption = "CatalogSortOption"
}
