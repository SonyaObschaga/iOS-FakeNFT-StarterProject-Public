import UIKit

// MARK: - UserCardViewController
final class UserCardViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: UserCardPresenterProtocol!
    
    // MARK: - UI Elements
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
    
    private lazy var webViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .ypBlackLight
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.titleLabel?.font = .caption1
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(webViewButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    @objc private func webViewButtonTapped() {
        presenter.webViewButtonTapped()
    }
    
    // MARK: - SetupUI
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "backward"),
            style: .plain,
            target: self,
            action: #selector(backwardButtonTapped)
        )
        
        navigationItem.leftBarButtonItem?.tintColor = .ypBlackLight
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupVerticalStackView()
        setupWebViewButton()
        setupNavigationBar()
    }
    
    private func setupWebViewButton() {
        view.addSubview(webViewButton)
        
        NSLayoutConstraint.activate([
            webViewButton.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 28),
            webViewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            webViewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            webViewButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupVerticalStackView() {
        view.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
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
