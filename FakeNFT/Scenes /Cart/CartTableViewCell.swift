import UIKit

class CartTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CartCell"
    
    private let cellView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor(resource: .white)
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(resource: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingOfNftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let costTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(resource: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let costOfNftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(resource: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deleteNftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .deletFromCart), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
