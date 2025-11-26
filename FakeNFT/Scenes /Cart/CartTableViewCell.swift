import UIKit

class CartTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CartCell"
    
    private let cellView: UIView = {
        let container = UIView()
        container.backgroundColor = .backgroundPrimary
        container.layer.cornerRadius = 12
        container.clipsToBounds = true
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
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingOfNftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .rating0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let costTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let costOfNftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let deleteNftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .deleteFromCart), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setupViews() {
        contentView.addSubview(cellView)
        cellView.addSubview(nftImageView)
        cellView.addSubview(nftNameLabel)
        cellView.addSubview(ratingOfNftImageView)
        cellView.addSubview(costTitleLabel)
        cellView.addSubview(costOfNftLabel)
        cellView.addSubview(deleteNftButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            
            nftNameLabel.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 8),
            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            
            ratingOfNftImageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 34),
            ratingOfNftImageView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            
            costTitleLabel.topAnchor.constraint(equalTo: ratingOfNftImageView.bottomAnchor, constant: 12),
            costTitleLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            
            costOfNftLabel.topAnchor.constraint(equalTo: costTitleLabel.bottomAnchor, constant: 2),
            costOfNftLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            
            deleteNftButton.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            deleteNftButton.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            deleteNftButton.heightAnchor.constraint(equalToConstant: 40),
            deleteNftButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
}
