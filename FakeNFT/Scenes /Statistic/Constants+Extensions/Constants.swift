import UIKit

enum CellConstants {
    // MARK: - Layout Constants
    static let containerTopBottomInset: CGFloat = 4
    static let containerCornerRadius: CGFloat = 12
    static let mainStackHeight: CGFloat = 80
    static let profileImageSize: CGFloat = 28
    static let profileImageCornerRadius: CGFloat = 14
    
    // MARK: - Spacing Constants
    static let horizontalSpacing: CGFloat = 16
    static let stackViewSpacing: CGFloat = 8
    static let mainStackSpacing: CGFloat = 16
    static let positionLabelTrailingInset: CGFloat = -16
    static let profileImageLeadingInset: CGFloat = 16
    static let scoreLabelTrailingInset: CGFloat = -16
    
    // MARK: - String Constants
    static let reuseIdentifier = "StatisticCell"
    static let profileImageSystemName = "person.crop.circle.fill"
    static let sortMenuImageName = "sortMenu"
    static let sortAlertTitle = "Сортировка"
}

// MARK: - Statistic Constants
enum StatisticConstants {
    static let topInset: CGFloat = 20
    static let leadingInset: CGFloat = 16
    static let trailingInset: CGFloat = -16
    static let bottomInset: CGFloat = -20
    
    // MARK: Sort Button Constants
    static let sortButtonTopInset: CGFloat = 2
    static let sortButtonTrailingInset: CGFloat = -9
    static let sortButtonSize: CGFloat = 42
    static let sortButtonTableViewSpacing: CGFloat = 20
}

// MARK: - UserCard Constants
enum UserCardConstants {
    
    // MARK: String Constants
    static let avatarImageSystemName = "person.crop.circle.fill"
    static let placeholderName = "Joaquin Phoenix"
    static let placeholderDescription = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT,и еще больше — на моём сайте. Открыт к коллаборациям."
    static let websiteButtonTitle = "Перейти на сайт пользователя"
    static let collectionButtonTitlePrefix = "Коллекция NFT"
    static let backwardImageName = "backward"
    static let initCoderError = "init(coder:) has not been implemented"
}
