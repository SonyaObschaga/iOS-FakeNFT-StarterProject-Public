import UIKit

// MARK: - StatisticTableViewCell
class StatisticTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "100"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .ypBlackLight
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Alex"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .ypBlackLight
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "112"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .ypBlackLight
        return label
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 28
        imageView.tintColor = .ypBlackLight
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImage, nameLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [stackView, scoreLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 16
        stack.backgroundColor = .ypLightGrayLight
        stack.layer.cornerRadius = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        selectionStyle = .none
        setupLayout()
        numberLabel.setContentHuggingPriority(.required, for: .horizontal)
        numberLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        mainStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        mainStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupLayout() {
        contentView.addSubview(numberLabel)
        contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            numberLabel.trailingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: -8),
            numberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            profileImage.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 16),
            scoreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    func configure(with user: User) {
        nameLabel.text = user.name
        scoreLabel.text = "\(user.score)"
    }
}
