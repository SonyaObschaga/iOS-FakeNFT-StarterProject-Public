import UIKit

// MARK: - UserCardViewController
final class UserCardViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: UserCardPresenterProtocol!
    
    // MARK: - UI Elements
    private lazy var backwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .ypBlackLight
        button.setImage(UIImage(named: "backward"), for: .normal)
        button.addTarget(self, action: #selector(backwardButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Joaquin Phoenix"
        label.font = .headline3
        label.textColor = .ypBlackLight
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT,и еще больше — на моём сайте. Открыт к коллаборациям."
        label.font = .caption2
        label.textColor = .ypBlackLight
        label.numberOfLines = 4
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarImageView, nameLabel])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [stackView, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Actions
    @objc private func backwardButtonTapped() {
        presenter.backwardButtonTapped()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupBackwardButton()
        setupVerticalStackView()
    }
    
    private func setupBackwardButton() {
        view.addSubview(backwardButton)
        
        NSLayoutConstraint.activate([
            backwardButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            backwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backwardButton.widthAnchor.constraint(equalToConstant: 24),
            backwardButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupVerticalStackView() {
        view.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: backwardButton.bottomAnchor, constant: 29),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            stackView.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor),
            
            avatarImageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
}

extension UserCardViewController: UserCardViewProtocol {
    func displayUser(_ user: User) {
//        nameLabel.text = user.name
        nameLabel.text = "Test Name" // ← Временный текст для теста
        descriptionLabel.text = "Test Description" // поменять
    }
}
