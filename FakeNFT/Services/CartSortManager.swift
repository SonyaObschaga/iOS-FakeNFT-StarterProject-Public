import Foundation

enum CartSortOption: String, CaseIterable {
    case price
    case rating
    case name
    
    var displayTitle: String {
        switch self {
        case .price: return NSLocalizedString("MyNFTs.sortByPrice", comment: "")
        case .rating: return NSLocalizedString("MyNFTs.sortByRating", comment: "")
        case .name: return NSLocalizedString("MyNFTs.sortByName", comment: "")
        }
    }
}

final class CartSortPreferenceManager {
    
    private let key = "cart_sort_option"
    
    func save(_ option: CartSortOption) {
        UserDefaults.standard.set(option.rawValue, forKey: key)
    }
    
    func load() -> CartSortOption {
        let raw = UserDefaults.standard.string(forKey: key)
        return CartSortOption(rawValue: raw ?? "") ?? .price
    }
}
