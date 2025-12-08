import UIKit
import Kingfisher

// MARK: - UserCardViewController
final class UserCardViewController: UIViewController {
    
    // MARK: - Property
    private var presenter: UserCardPresenterProtocol
    
    // MARK: - UI Elements
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
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
    
    private lazy var collectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .ypBlackLight
        button.backgroundColor = .systemBackground
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.isUserInteractionEnabled = false
        
        let titleLabel = UILabel()
        titleLabel.text = "Коллекция NFT (112)"
        titleLabel.font = .bodyBold
        titleLabel.textColor = .ypBlackLight
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "backward")?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = .ypBlackLight
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            iconImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: iconImageView.leadingAnchor, constant: -8)
        ])
        
        button.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: button.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
        
        button.addTarget(self, action: #selector(collectionButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    // MARK: - Initialization
    init(presenter: UserCardPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - Actions
    @objc private func backwardButtonTapped() {
        presenter.backwardButtonTapped()
    }
    
    @objc private func webViewButtonTapped() {
        presenter.webViewButtonTapped()
    }
    
    @objc private func collectionButtonTapped() {
        presenter.collectionButtonTapped()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupVerticalStackView()
        setupWebViewButton()
        setupNavigationBar()
        setupCollectionButton()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "backward"),
            style: .plain,
            target: self,
            action: #selector(backwardButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .ypBlackLight
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
    
    private func setupCollectionButton() {
        view.addSubview(collectionButton)
        
        NSLayoutConstraint.activate([
            collectionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionButton.heightAnchor.constraint(equalToConstant: 44)
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

// MARK: - UserCardViewProtocol
extension UserCardViewController: UserCardViewProtocol {
    func displayUser(_ user: User) {
        nameLabel.text = user.name
        descriptionLabel.text = "\(user.score)"
        
        if let avatarURLString = user.avatar, let avatarURL = URL(string: avatarURLString) {
            avatarImageView.kf.setImage(with: avatarURL, placeholder: UIImage(systemName: "person.crop.circle.fill"))
        } else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
        }
    }
}
