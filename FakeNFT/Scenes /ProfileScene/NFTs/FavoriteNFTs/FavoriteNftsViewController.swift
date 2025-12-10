//
//  FavoriteNftsViewController.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 23/11/25.
//

import UIKit

final class FavoriteNftsViewController: UIViewController, LoadingView {
 
    var likedNFTs : [NFTModel] = []

    private var presenter: NFTPresenterProtocol!
    func configure (_ presenter: NFTPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.showLoading()
//        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidLoad() // теперь safe — collectionView добавлен
    }

    //MARK: - Layout variables
    private lazy var backButton: UIButton = {
        let imageButton = UIImage(resource: .backChevron)
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        return button
    }()
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlackDay
        label.text = "Избранные NFT"
        
        return label
    }()
    private lazy var emptyNftsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlackDay
        label.text = "У Вас ещё нет избранных NFT"
        
        return label
    }()
    lazy var nftCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhiteDay
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        
        collectionView.register(
            FavoriteNftsCollectionViewCell.self,
            forCellWithReuseIdentifier: FavoriteNftsCollectionViewCell.reuseIdentifier
        )
        
        return collectionView
    }()
    
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        
        // Center the activity indicator
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return indicator
    }()
}

// MARK: - UICollectionViewDataSource
extension FavoriteNftsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedNFTs.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteNftsCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? FavoriteNftsCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell() }
        
        cell.configureCell(likedNFT: likedNFTs[indexPath.row], presenter: presenter)
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteNftsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width / ProfileSceneConstants.favoritesCollectionViewBoundsWidthDivider, height: ProfileSceneConstants.favoritesCollectionViewCellHeight)
    }
}

// MARK: - UICollectionViewDelegate
extension FavoriteNftsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension FavoriteNftsViewController {
    func toggleControlsVisibility() {
        let showHideElements = likedNFTs.isEmpty
        emptyNftsLabel.isHidden = !showHideElements
        nftCollectionView.isHidden = showHideElements
        headerLabel.isHidden = showHideElements
    }
    
    func setupView() {
        view.backgroundColor = .ypWhiteDay
        
        
        addSubViews()
        configureConstraints()
    }
    
    func addSubViews() {
        view.addSubview(emptyNftsLabel)
        view.addSubview(backButton)
        view.addSubview(headerLabel)
        view.addSubview(nftCollectionView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            emptyNftsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyNftsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            
            headerLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nftCollectionView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc
    func back() {
        navigationController?.popToRootViewController(animated: true)
    }
}
