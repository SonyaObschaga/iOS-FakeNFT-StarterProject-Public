// MARK: - Models
// MARK: User
struct User {
    let id: String
    let name: String
    let score: Int
    let website: String?
    let avatar: String?
    let description: String?
    let nfts: [String]
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
    var isLiked: Bool
    let id: String
}
