import UIKit

// MARK: - UserCollectionViewController
final class UserCollectionViewController: UIViewController {
    
    // MARK: - Properties
    private var presenter: UserCollectionPresenterProtocol
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(UserCollectionViewCell.self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    init(presenter: UserCollectionPresenterProtocol) {
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
    
    // MARK: - Action
    @objc private func backwardButtonTapped() {
        presenter.backwardButtonTapped()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupCollectionView()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Коллекция NFT"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .backChevron),
            style: .plain,
            target: self,
            action: #selector(backwardButtonTapped)
        )
        
        navigationItem.leftBarButtonItem?.tintColor = .label
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Private Methods
    private func showErrorAlert(message: String, retryHandler: (() -> Void)?) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        if let retryHandler = retryHandler {
            alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
                retryHandler()
            })
        }
        present(alert, animated: true)
    }
}

// MARK: - UserCollectionViewProtocol
extension UserCollectionViewController: UserCollectionViewProtocol {
    func displayUserCollection(_ items: [UserCollectionNftItem]) {
        collectionView.reloadData()
    }
    
    func showError(message: String, retryHandler: (() -> Void)?) {
        showErrorAlert(message: message, retryHandler: retryHandler)
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func updateItem(at index: Int, with item: UserCollectionNftItem) {
        let indexPath = IndexPath(item: index, section: 0)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? UserCollectionViewCell {
            cell.configure(
                imageURL: item.imageURL,
                name: item.name,
                rating: item.rating,
                price: item.price,
                isLiked: item.isLiked,
                isInCart: item.isInCart,
                id: item.id,
                indexPath: indexPath,
                presenter: presenter
            )
        } else {
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

// MARK: - UICollectionViewDelegate
extension UserCollectionViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension UserCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UserCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let item = presenter.item(at: indexPath.item)
        
        cell.configure(
            imageURL: item.imageURL,
            name: item.name,
            rating: item.rating,
            price: item.price,
            isLiked: item.isLiked,
            isInCart: item.isInCart,
            id: item.id,
            indexPath: indexPath,
            presenter: presenter
        )
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultLayout = CGSize(width: 108, height: 192)
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return defaultLayout
        }
        let totalWidth = collectionView.bounds.width
        guard totalWidth > 0 else {
            return defaultLayout
        }
        
        let insets = layout.sectionInset
        let spacing: CGFloat = 9
        let availableWidth = totalWidth - insets.left - insets.right
        let itemsPerRow: CGFloat = 3
        let totalSpacing = spacing * (itemsPerRow - 1)
        let itemWidth = floor((availableWidth - totalSpacing) / itemsPerRow)
        
        return CGSize(width: itemWidth, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}
