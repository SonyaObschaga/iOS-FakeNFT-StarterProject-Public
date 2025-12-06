import UIKit

// MARK: - UserCollectionViewController
final class UserCollectionViewController: UIViewController {
    
    // MARK: - Properties
    private var presenter: UserCollectionPresenterProtocol
    private var nftItems: [UserCollectionNftItem] = [
        UserCollectionNftItem(
            imageURL: "https://img.freepik.com/premium-photo/close-up-portrait-cat_1048944-18104761.jpg?semt=ais_hybrid&w=740",
            name: "Archie",
            rating: 4,
            price: "1.5 ETH",
            isLiked: true
        ),
        UserCollectionNftItem(
            imageURL: "https://sun1-95.userapi.com/s/v1/ig2/cmVsTov3W88J_ZHVB-RYRBt5KbxFSLH-vPJ1jQiNxnNJgsmhxKmN0GUCgY89_nCMSL1U0psSZSRdgjVNzixMYiNB.jpg?quality=95&crop=0,0,1599,1599&as=32x32,48x48,72x72,108x108,160x160,240x240,360x360,480x480,540x540,640x640,720x720,1080x1080,1280x1280,1440x1440&ava=1&cs=100x100",
            name: "Archie",
            rating: 4,
            price: "1.5 ETH",
            isLiked: true
        ),
        UserCollectionNftItem(
            imageURL: "https://img.freepik.com/premium-photo/close-up-portrait-cat_1048944-18104761.jpg?semt=ais_hybrid&w=740",
            name: "Archie",
            rating: 4,
            price: "1.5 ETH",
            isLiked: true
        ),
        UserCollectionNftItem(
            imageURL: "https://sun1-95.userapi.com/s/v1/ig2/cmVsTov3W88J_ZHVB-RYRBt5KbxFSLH-vPJ1jQiNxnNJgsmhxKmN0GUCgY89_nCMSL1U0psSZSRdgjVNzixMYiNB.jpg?quality=95&crop=0,0,1599,1599&as=32x32,48x48,72x72,108x108,160x160,240x240,360x360,480x480,540x540,640x640,720x720,1080x1080,1280x1280,1440x1440&ava=1&cs=100x100",
            name: "Archie",
            rating: 4,
            price: "1.5 ETH",
            isLiked: true
        )
    ]
    
    // MARK: - UI Element
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
            image: UIImage(named: "backward"),
            style: .plain,
            target: self,
            action: #selector(backwardButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .primary
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UserCollectionViewProtocol
extension UserCollectionViewController: UserCollectionViewProtocol {
    func displayUserCollection() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension UserCollectionViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension UserCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        nftItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UserCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let item = nftItems[indexPath.item]
        
        cell.configure(
            imageURL: item.imageURL,
            name: item.name,
            rating: item.rating,
            price: item.price,
            isLiked: item.isLiked
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
