import UIKit
import Kingfisher

final class FavoriteNftsCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "favoriteNftsCell"
    
    private var nftId: String = ""
    
    private var presenter: NFTPresenterProtocol?
    
    // MARK: - Layout variables
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let imageButton = UIImage(named: "Like Button Off")
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(changeLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var ratingImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Rating_3"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlackDay
        return label
    }()
    
    private lazy var costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .ypBlackDay
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Configuration
    
    func configureCell(likedNFT: NFTModel) {
        backgroundColor = .ypWhiteDay
        self.presenter = presenter
        self.nftId = nft.id
        nameLabel.text = likedNFT.nftName
        costLabel.text = "\(likedNFT.price) ETH"
        ratingImageView.image = UIImage(named: "Rating_\(likedNFT.rating ?? 1)")
        
        let likeImage = likedNFT.isLiked
        ? UIImage(named: "Like Button On")
        : UIImage(named: "Like Button Off")
        likeButton.setImage(likeImage, for: .normal)
        
        nftImageView.kf.indicatorType = .activity
        
        if let url = URL(string: likedNFT.images[0]) {
            nftImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder")
            ) { [weak self] _ in
                self?.setNeedsLayout()
            }
        }
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nftImageView.image = nil
        nameLabel.text = nil
        costLabel.text = nil
        
        nftImageView.kf.cancelDownloadTask()
    }
}

// MARK: - Private setup functions

private extension FavoriteNftsCollectionViewCell {
    
    func setupUI() {
        contentView.addSubview(nftImageView)
        contentView.addSubview(likeButton)
        likeButton.addTarget(self, action: #selector(changeLike), for: .touchUpInside)
        contentView.addSubview(ratingImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(costLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 80),
            
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            
            ratingImageView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            ratingImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: ratingImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: ratingImageView.topAnchor, constant: -4),
            
            costLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 8),
            costLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            costLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            costLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    @objc
    func changeLike() {
        presenter?.toggleLike(nftId: nftId)
    }
}
