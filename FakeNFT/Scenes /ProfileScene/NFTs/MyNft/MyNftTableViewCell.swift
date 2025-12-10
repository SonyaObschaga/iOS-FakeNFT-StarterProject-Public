import UIKit
import Kingfisher

final class MyNftTableViewCell: UITableViewCell {

    // MARK: - Reuse ID
    static let reuseIdentifier = "MyNftTableViewCell"

    private var presenter: NFTPresenterProtocol?
    
    private var nftId: String = ""

    // MARK: - Layout Views
    private lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypWhiteDay
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()

    private let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Like Button Off"), for: .normal)
        return button
    }()

    private let ratingImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlackDay
        return label
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        label.textColor = .ypBlackDay
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Цена"
        label.font = .systemFont(ofSize: 13)
        return label
    }()

    private let costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlackDay
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
        selectionStyle = .none
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
        selectionStyle = .none
        backgroundColor = .clear
    }

    // MARK: - Prepare for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.image = nil
        nameLabel.text = nil
        authorLabel.text = nil
        costLabel.text = nil
        likeButton.setImage(UIImage(named: "Like Button Off"), for: .normal)
        nftImageView.kf.cancelDownloadTask()
    }

    // MARK: - Configuration
    func configureCell(nft: NFTModel, presenter: NFTPresenterProtocol) {
        self.presenter = presenter
        self.nftId = nft.id
        nameLabel.text = nft.nftName
        costLabel.text = "\(nft.price) ETH"
        authorLabel.text = "От \(nft.nftAuthor)"

        ratingImageView.image = UIImage(named: "Rating_\(nft.rating ?? 1)")

        let likeImage = nft.isLiked ? "Like Button On" : "Like Button Off"
        likeButton.setImage(UIImage(named: likeImage), for: .normal)

        nftImageView.kf.indicatorType = .activity
        if let url = URL(string: nft.images.first ?? "") {
            nftImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
    }
}

private extension MyNftTableViewCell {

    func setupUI() {
        contentView.addSubview(cardView)
        cardView.addSubview(nftImageView)
        cardView.addSubview(likeButton)
        likeButton.addTarget(self, action: #selector(changeLike), for: .touchUpInside)
        cardView.addSubview(nameLabel)
        cardView.addSubview(authorLabel)
        cardView.addSubview(ratingImageView)
        cardView.addSubview(priceLabel)
        cardView.addSubview(costLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            nftImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            nftImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalTo: cardView.heightAnchor),

            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),

            ratingImageView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            ratingImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: ratingImageView.topAnchor, constant: -4),

            authorLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            authorLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 4),

            priceLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 33),
            priceLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            costLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            costLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor)
        ])
    }
    
    @objc
    func changeLike() {
        presenter?.toggleLike(nftId: nftId)
    }
}
