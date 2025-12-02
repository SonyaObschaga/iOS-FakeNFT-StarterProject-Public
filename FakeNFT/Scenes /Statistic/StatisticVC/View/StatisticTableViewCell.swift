import UIKit

// MARK: - StatisticTableViewCell
final class StatisticTableViewCell: UITableViewCell {
    
    // MARK: - Static property
    static var reuseIdentifier: String { "StatisticCell" }
    
    // MARK: - UI Elements
    private let positionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textAlignment = .center
        label.textColor = .ypBlackLight
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .ypBlackLight
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .headline3
        label.textColor = .ypBlackLight
        return label
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = CellConstants.profileImageCornerRadius
        imageView.tintColor = .ypBlackLight
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.heightAnchor.constraint(equalToConstant: CellConstants.profileImageSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: CellConstants.profileImageSize).isActive = true
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImage, nameLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = CellConstants.stackViewSpacing
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [stackView, scoreLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = CellConstants.mainStackSpacing
        return stack
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypLightGrayLight
        view.layer.cornerRadius = CellConstants.containerCornerRadius
        return view
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        selectionStyle = .none
        setupLayout()
        positionLabel.setContentHuggingPriority(.required, for: .horizontal)
        positionLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        mainStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        mainStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupLayout() {
        addSubviews()
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CellConstants.containerTopBottomInset),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -CellConstants.containerTopBottomInset),
            
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mainStackView.heightAnchor.constraint(equalToConstant: CellConstants.mainStackHeight),
            
            positionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            positionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            positionLabel.trailingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: CellConstants.positionLabelTrailingInset),
            positionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            profileImage.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: CellConstants.profileImageLeadingInset),
            scoreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: CellConstants.scoreLabelTrailingInset),
        ])
    }
    
    private func addSubviews() {
        [containerView, positionLabel, mainStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    // MARK: - Configuration
    func configure(with user: User, position: Int) {
        nameLabel.text = user.name
        scoreLabel.text = "\(user.score)"
        positionLabel.text = "\(position)"
    }
}
