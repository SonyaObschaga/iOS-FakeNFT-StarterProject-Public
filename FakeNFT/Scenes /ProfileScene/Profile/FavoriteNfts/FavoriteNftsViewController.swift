//
//  FavoriteNftsViewController.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 23/11/25.
//

import UIKit

final class FavoriteNftsViewController: UIViewController {
    let profile = FakeNFTService.shared.profile
 
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
    private lazy var nftCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhiteDay
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        
        collectionView.register(
            FavoriteNftsCollectionViewCell.self,
            forCellWithReuseIdentifier: FavoriteNftsCollectionViewCell.cellName
        )
        
        return collectionView
    }()
    
    /* REMOVE
     //MARK: - Private variables
    private let nfts: [String] = [
        "Lilo", "Spring", "April",
        "Archie", "Pixi", "Melissa",
        "Lilo", "Spring", "April",
        "Archie", "Pixi", "Melissa"
    ]
    */
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

// MARK: - UICollectionViewDataSource
extension FavoriteNftsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profile.likedNFTs.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoriteNftsCollectionViewCell.cellName,
            for: indexPath
        ) as? FavoriteNftsCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell() }
        
        cell.configureCell(likedNFT: profile.likedNFTs[indexPath.row])
        
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
        return CGSize(width: collectionView.bounds.width / 2.2, height: 80)
    }
}

// MARK: - UICollectionViewDelegate
extension FavoriteNftsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - Privtae functions
private extension FavoriteNftsViewController {
    func setupView() {
        view.backgroundColor = .ypWhiteDay
        
        let showHideElements = profile.likedNFTs.isEmpty
        emptyNftsLabel.isHidden = !showHideElements
        nftCollectionView.isHidden = showHideElements
        headerLabel.isHidden = showHideElements
        
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
