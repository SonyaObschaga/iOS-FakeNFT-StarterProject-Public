import UIKit
import Kingfisher

final class PaymentCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "PaymentCell"
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .secondary
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var currencyImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .baseBlack
        image.layer.cornerRadius = 6
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var currencyFullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyRegular13
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currencyShortNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyRegular13
        label.textColor = .semanticGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    private func setupViews() {
        contentView.addSubview(cardView)
        cardView.addSubview(currencyImage)
        cardView.addSubview(currencyFullNameLabel)
        cardView.addSubview(currencyShortNameLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3.5),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3.5),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3.5),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3.5),
            
            currencyImage.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            currencyImage.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            currencyImage.widthAnchor.constraint(equalToConstant: 36),
            currencyImage.heightAnchor.constraint(equalToConstant: 36),
            
            currencyFullNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 5),
            currencyFullNameLabel.leadingAnchor.constraint(equalTo: currencyImage.trailingAnchor, constant: 4),
            
            currencyShortNameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 23),
            currencyShortNameLabel.leadingAnchor.constraint(equalTo: currencyImage.trailingAnchor, constant: 4),
        ])
    }
    
    func configureCell(with currency: PaymentCurrency) {
        guard let url = URL(string: currency.imageURLString) else { return }
        
        currencyImage.kf.setImage(with: url)
        
        currencyFullNameLabel.text = currency.title
        currencyShortNameLabel.text = currency.name
    }
    
    func setSelectedState(_ selected: Bool) {
        cardView.layer.borderColor = selected ? UIColor.blackAdaptive.cgColor : UIColor.clear.cgColor
        cardView.layer.borderWidth = selected ? 1 : 0
    }
}
