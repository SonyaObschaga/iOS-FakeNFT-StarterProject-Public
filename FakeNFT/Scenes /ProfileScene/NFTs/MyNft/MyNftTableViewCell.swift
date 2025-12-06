//
//  MyNftTableViewCell.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 23/11/25.
//

import UIKit

final class MyNftTableViewCell: UITableViewCell {
    
    private var presenter: NFTPresenterProtocol!
    func configure (_ presenter: NFTPresenterProtocol) {
        self.presenter = presenter
    }
    
    //MARK: - Layout variables
    private lazy var uiView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypWhiteDay
        
        return view
    }()
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        
        return imageView
    }()
    private lazy var likeButton: UIButton = {
        let imageButton = UIImage(named: "No active")
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.cornerRadius = 12
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(changeLike), for: .touchUpInside)
        
        return button
    }()
    private lazy var ratingImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "stars3"))
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlackDay

        return label
    }()
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypBlackDay
        label.text = "John Doe"
        return label
    }()
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypBlackDay
        label.text = "Цена"
        
        return label
    }()
    private lazy var costLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlackDay
        label.text = "1,78 ETH"
        
        return label
    }()
    
    //MARK: - Public functions
    func configureCell(nft: NFTModel) {
        backgroundColor = .ypWhiteDay
        selectionStyle = .none
        
        nameLabel.text = nft.nftName
        costLabel.text = "\(nft.price) ETH"
        authorLabel.text = "От \(nft.nftAuthor)"
        
        ratingImageView.image = UIImage(named: "Rating_\(nft.rating ?? 1)")
        if nft.isLiked {
            likeButton.setImage(UIImage(named: "Like Button On"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "Like Button Off"), for: .normal)
        }
        
        nftImageView.kf.indicatorType = .activity
        if let url = URL( string: nft.images[0]) {
            nftImageView.kf.setImage(with: url,
                                     placeholder: UIImage(named: "placeholder"))
            {
                [weak self] _ in self?.setNeedsLayout()
            }
        }
 
        addSubViews()
        configureConstraints()
    }
}

//MARK: - Private functions
private extension MyNftTableViewCell {
    func addSubViews() {
        contentView.addSubview(uiView)
        uiView.addSubview(nftImageView)
        uiView.addSubview(likeButton)
        uiView.addSubview(nameLabel)
        uiView.addSubview(ratingImageView)
        uiView.addSubview(authorLabel)
        uiView.addSubview(priceLabel)
        uiView.addSubview(costLabel)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            uiView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -39),
            uiView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            uiView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            nftImageView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
            nftImageView.topAnchor.constraint(equalTo: uiView.topAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),

            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -75),
            priceLabel.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
            priceLabel.topAnchor.constraint(equalTo: uiView.topAnchor, constant: 33),
            priceLabel.heightAnchor.constraint(equalToConstant: 18),
            
            costLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            costLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            costLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            costLabel.heightAnchor.constraint(equalToConstant: 22),
            
            ratingImageView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            ratingImageView.centerYAnchor.constraint(equalTo: uiView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: ratingImageView.topAnchor, constant: -4),
            
            authorLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            authorLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 4)
            
        ])
    }
    
    @objc
    func changeLike() {
        
    }
}
