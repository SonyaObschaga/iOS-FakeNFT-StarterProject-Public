// MARK: - Models
// MARK: User
struct User {
    let name: String
    let score: Int
    let website: String?
    let avatar: String?
    let description: String?
}

// MARK: Sort Options
enum SortOption: String, CaseIterable {
    case name = "По имени"
    case rating = "По рейтингу"
    case cancel = "Закрыть"
    
    var isCancel: Bool {
        return self == .cancel
    }
}

// MARK: - UserCollectionNftItem
struct UserCollectionNftItem {
    let imageURL: String?
    let name: String
    let rating: Int
    let price: String
    let isLiked: Bool
}
