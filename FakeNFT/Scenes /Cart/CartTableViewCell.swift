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
        imageView.layer.masksToBounds = true
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
        button.tintColor = .blackAdaptive
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = .backgroundPrimary
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    func configure(nftName: String, nftImageURL: String, rating: Int, price: Float) {
        nftNameLabel.text = nftName
        nftImageView.image = UIImage(resource: .NFT) //подтянуть изображение через Kingfisher
        let priceString = String(price).replacingOccurrences(of: ".", with: ",")
        costOfNftLabel.text = "\(priceString) ETH"
        setRatingStars(rating: rating)
    }
    
    func setRatingStars(rating: Int) {
        let boundedRating = max(1, min(rating, 5))
        let image: UIImage
            switch boundedRating {
            case 0: image = UIImage(resource: .rating0)
            case 1: image = UIImage(resource: .rating1)
            case 2: image = UIImage(resource: .rating2)
            case 3: image = UIImage(resource: .rating3)
            case 4: image = UIImage(resource: .rating4)
            case 5: image = UIImage(resource: .rating5)
            default: image = UIImage(resource: .rating0)
            }
        ratingOfNftImageView.image = image
    }
}
