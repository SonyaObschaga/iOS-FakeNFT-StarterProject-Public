//
//  MyCell.swift
//  FakeNFT
//
//  Created by Илья on 29.11.2025.
//
struct NFTMock {
    let title: String
    let imageURL: URL
    let favorite: Bool
    let rating: Double
    let price: Double
    let id: String
    let isInCart: Bool
}

let mockNFTs: [NFTMock] = [
    .init(title: "NFT 1", imageURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/1.png")!, favorite: true, rating: 5, price: 2.75, id: "2tfg", isInCart: true),
    .init(title: "NFT 1", imageURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/1.png")!, favorite: true, rating: 4, price: 3.75, id: "2tgg", isInCart: true),
    .init(title: "NFT 1", imageURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/1.png")!, favorite: false, rating: 3, price: 4.75, id: "2tff", isInCart: false),
    .init(title: "NFT 1", imageURL: URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Ellsa/1.png")!, favorite: false, rating: 2, price: 6.75, id: "2tfq", isInCart: false),
]

import UIKit
import Kingfisher

final class MyCell: UICollectionViewCell {
    
    // Картинка
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // Текст
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // избранное
    private let favoriteImageView: UIImageView = {
        let fiv = UIImageView()
        fiv.contentMode = .scaleAspectFill
        fiv.clipsToBounds = true
        fiv.layer.cornerRadius = 8
        fiv.translatesAutoresizingMaskIntoConstraints = false
        return fiv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteImageView)
        
        NSLayoutConstraint.activate([
            // Картинка сверху
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor), // квадрат
            
            // избранное
            favoriteImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            favoriteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 40),
            favoriteImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Текст под картинкой
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Configure
    func configure(with model: NFTMock) {
        imageView.kf.setImage(with: model.imageURL)
        titleLabel.text = model.title
        favoriteImageView.image = UIImage(resource: "Like Button On")
        
    }
}

