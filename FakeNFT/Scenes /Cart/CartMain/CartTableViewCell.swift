import UIKit

protocol CartCellDelegate: AnyObject {
    func didTapDelete(in cell: CartTableViewCell, with image: UIImage)
}

final class CartTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CartCell"
    
    weak var delegate: CartCellDelegate?
    
    private lazy var cellView: UIView = {
        let container = UIView()
        container.backgroundColor = .backgroundPrimary
        container.layer.cornerRadius = 12
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nftNameLabel: UILabel = {
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
    
    private lazy var costTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var costOfNftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteNftButton: UIButton = {
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
        
        deleteNftButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        return nil
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
    
    func configure(nftName: String, nftImageURL: URL?, rating: Int, price: Float) {
        nftNameLabel.text = nftName
        
        nftImageView.kf.indicatorType = .activity
        nftImageView.kf.setImage(
            with: nftImageURL,
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        )
        
        let priceString = String(price).replacingOccurrences(of: ".", with: ",")
        costOfNftLabel.text = "\(priceString) ETH"
        setRatingStars(rating: rating)
    }
    
    private func setRatingStars(rating: Int) {
        let boundedRating = max(1, min(rating, 5))
        
        ratingOfNftImageView.image = switch boundedRating {
        case 1: UIImage(resource: .rating1)
        case 2: UIImage(resource: .rating2)
        case 3: UIImage(resource: .rating3)
        case 4: UIImage(resource: .rating4)
        case 5: UIImage(resource: .rating5)
        default: UIImage(resource: .rating0)
        }
    }
    
    
    @objc private func deleteTapped() {
        guard let nftImage = nftImageView.image else { return }
        delegate?.didTapDelete(in: self, with: nftImage)
    }
}
