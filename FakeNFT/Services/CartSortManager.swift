import Foundation

enum CartSortOption: String, CaseIterable {
    case price
    case rating
    case name
    
    var displayTitle: String {
        switch self {
        case .price: return "По цене"
        case .rating: return "По рейтингу"
        case .name: return "По названию"
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
