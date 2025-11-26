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
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .ypBlackLight
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .ypBlackLight
        return label
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
}

extension UserCardViewController: UserCardViewProtocol {
    func displayUser(_ user: User) {
        nameLabel.text = user.name
        descriptionLabel.text = user.name // поменять
    }
}
