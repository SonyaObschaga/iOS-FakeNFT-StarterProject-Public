import UIKit

// MARK: - StatisticTableViewCell
class StatisticTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "100"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        label.backgroundColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "kekjvefiv"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        label.backgroundColor = .red
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 28
        imageView.tintColor = .black
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
        stack.backgroundColor = .green
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [stackView, scoreLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 16
        stack.backgroundColor = .lightGray
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
    
    private func setupUI() {
        setupLayout()
    }
    
    private func setupLayout() {
        contentView.addSubview(mainStackView)
        contentView.addSubview(numberLabel)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            numberLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            numberLabel.trailingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            numberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.trailingAnchor.constraint(equalTo: scoreLabel.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
        ])
    }
    
    func configure(with user: User) {
        nameLabel.text = user.name
        scoreLabel.text = "\(user.score)"
    }
}
