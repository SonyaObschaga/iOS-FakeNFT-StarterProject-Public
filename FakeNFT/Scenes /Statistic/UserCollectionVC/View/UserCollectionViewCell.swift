import UIKit
import Kingfisher

// MARK: - UserCollectionViewCell
final class UserCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - UI Elements
    private var starImageViews: [UIImageView] = []
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .ypBlackLight
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption3
        label.textColor = .ypBlackLight
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "cart"), for: .normal)
        button.tintColor = .ypBlackLight
        return button
    }()
    
    private lazy var namePriceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var cartButtonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [namePriceStackView, cartButton])
        stackView.axis = .horizontal
        return stackView
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStars()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        addSubviews()
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),
            
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            ratingStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            ratingStackView.widthAnchor.constraint(equalToConstant: 68),
            
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            
            cartButtonStackView.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 5),
            cartButtonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cartButtonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButtonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cartButtonStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func addSubviews() {
        [nftImageView, likeButton, ratingStackView, cartButtonStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setupStars() {
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.image = UIImage(named: "star")
            starImageView.tintColor = .ypLightGrayLight
            starImageView.contentMode = .scaleAspectFit
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            starImageViews.append(starImageView)
            ratingStackView.addArrangedSubview(starImageView)
        }
    }
    
    // MARK: - Configuration
    func configure(imageURL: String?, name: String, rating: Int, price: String, isLiked: Bool) {
        if let imageURLString = imageURL, let url = URL(string: imageURLString) {
            nftImageView.kf.setImage(with: url)
        }
        
        nameLabel.text = name
        priceLabel.text = price
        
        updateRating(rating)
        updateLikeButton(isLiked)
    }
    
    private func updateRating(_ rating: Int) {
        let normalizedRating = min(5, max(0, rating))
        
        for (index, starImageView) in starImageViews.enumerated() {
            if index < normalizedRating {
                starImageView.image = UIImage(named: "star")
                starImageView.tintColor = .systemYellow
            } else {
                starImageView.image = UIImage(named: "star")
                starImageView.tintColor = .ypLightGrayLight
            }
        }
    }
    
    private func updateLikeButton(_ isLiked: Bool) {
        if isLiked {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .systemRed
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .white
        }
    }
}
