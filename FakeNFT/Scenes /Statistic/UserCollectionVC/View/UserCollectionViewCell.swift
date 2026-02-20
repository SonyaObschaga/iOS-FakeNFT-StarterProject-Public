import UIKit
import Kingfisher

// MARK: - UserCollectionViewCell
final class UserCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - Properties
    private var likeButtonIsSelected: Bool = false {
        didSet {
            updateLikeButton(likeButtonIsSelected)
        }
    }
    private var indexPath: IndexPath?
    private var presenter: UserCollectionPresenterProtocol?
    private var nftId: String?
    
    // MARK: - UI Elements
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
        
        button.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var ratingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .titleLarge
        label.textColor = .primary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .primary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .primary
        button.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)
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
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    // MARK: - Action
    @objc private func didTapLikeButton() {
        guard let indexPath = indexPath, let presenter = presenter else { return }
        presenter.toggleLikeStatus(at: indexPath.row)
    }
    
    @objc private func didTapCartButton() {
        guard let indexPath = indexPath, let presenter = presenter else { return }
        presenter.toggleCartStatus(at: indexPath.row)
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
            
            ratingImageView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingImageView.heightAnchor.constraint(equalToConstant: 12),
            ratingImageView.widthAnchor.constraint(equalToConstant: 68),
            
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            
            cartButtonStackView.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 5),
            cartButtonStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cartButtonStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButtonStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            cartButtonStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func addSubviews() {
        [nftImageView, likeButton, ratingImageView, cartButtonStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    // MARK: - Configuration
    func configure(
        imageURL: String?,
        name: String
        , rating: Int,
        price: String,
        isLiked: Bool,
        isInCart: Bool,
        id: String,
        indexPath: IndexPath,
        presenter: UserCollectionPresenterProtocol
    ) {
        self.indexPath = indexPath
        self.presenter = presenter
        self.nftId = id
        self.likeButtonIsSelected = isLiked
        
        if let imageURLString = imageURL, let url = URL(string: imageURLString) {
            nftImageView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [.transition(.fade(0.2))],
                completionHandler: { result in
                }
            )
        } else {
            nftImageView.image = nil
        }
        
        nameLabel.text = name
        priceLabel.text = price
        updateRating(rating)
        updateLikeButton(isLiked)
        updateCartButton(isInCart)
    }
    
    private func updateRating(_ rating: Int) {
        let normalizedRating = min(5, max(0, rating))
        ratingImageView.image = UIImage.ratingImage(for: normalizedRating)
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
    
    private func updateCartButton(_ isInCart: Bool) {
        if isInCart {
            cartButton.setImage(UIImage(resource: .deleteFromCart), for: .normal)
        } else {
            cartButton.setImage(UIImage(resource: .addToCart), for: .normal)
        }
    }
}
