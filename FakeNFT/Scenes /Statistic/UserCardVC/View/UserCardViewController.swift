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
        label.text = UserCardConstants.placeholderName
        label.font = .titleLarge
        label.textColor = .primary
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = UserCardConstants.placeholderDescription
        label.font = .bodyRegular13
        label.textColor = .primary
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
        button.tintColor = .primary
        button.setTitle(UserCardConstants.websiteButtonTitle, for: .normal)
        button.titleLabel?.font = .caption1
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(webViewButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nftsCountLabel: UILabel = {
      let label = UILabel()
        label.font = .titleMedium
        label.textColor = .primary
        label.text = "Коллекция NFT 0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .primary
        button.backgroundColor = .systemBackground
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.isUserInteractionEnabled = false
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(resource: .backChevron).withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = .primary
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(nftsCountLabel)
        containerView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            nftsCountLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nftsCountLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            iconImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            nftsCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: iconImageView.leadingAnchor, constant: -8)
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
        assertionFailure(UserCardConstants.initCoderError)
        return nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
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
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .backChevron),
            style: .plain,
            target: self,
            action: #selector(backwardButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
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
        descriptionLabel.text = user.description
        nftsCountLabel.text = "Коллекция NFT (\(user.nfts.count))"
        
        let placeholderImage = UIImage(systemName: "person.crop.circle.fill")
        if let avatarURLString = user.avatar, let avatarURL = URL(string: avatarURLString) {
            avatarImageView.kf.setImage(with: avatarURL, placeholder: placeholderImage)
        } else {
            avatarImageView.image = placeholderImage
        }
    }
}
