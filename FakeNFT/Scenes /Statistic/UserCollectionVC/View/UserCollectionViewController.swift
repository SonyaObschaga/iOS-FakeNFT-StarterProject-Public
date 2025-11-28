import UIKit

// MARK: - UserCollectionViewController
final class UserCollectionViewController: UIViewController {
    
    // MARK: - Property
    private var presenter: UserCollectionPresenterProtocol
    
    // MARK: - UI Elements
    
    
    // MARK: - Initialization
    init(presenter: UserCollectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    // MARK: - SetupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
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
}

// MARK: - UserCollectionViewProtocol
extension UserCollectionViewController: UserCollectionViewProtocol {
    func displayUserCollection() {
        //
    }
}
