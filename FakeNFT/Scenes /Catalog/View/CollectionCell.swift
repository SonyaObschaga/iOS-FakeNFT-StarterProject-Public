//
//  MyCell.swift
//  FakeNFT
//
//  Created by Илья on 29.11.2025.
//

import UIKit
import Kingfisher

final class CollectionCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cartImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let favoriteImageView: UIImageView = {
        let fiv = UIImageView()
        fiv.contentMode = .scaleAspectFill
        fiv.clipsToBounds = true
        fiv.layer.cornerRadius = 8
        fiv.translatesAutoresizingMaskIntoConstraints = false
        return fiv
    }()
    
    private let ratingView: UIImageView = {
        let rv = UIImageView()
        rv.contentMode = .scaleAspectFill
        rv.clipsToBounds = true
        rv.translatesAutoresizingMaskIntoConstraints = false
        return rv
    }()
    
   
    private let titlePriceStack: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let verticalStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        sv.alignment = .leading
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    var onFavoriteTap: (() -> Void)?
    var onCartTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(favoriteImageView)
        contentView.addSubview(ratingView)
        contentView.addSubview(verticalStack)
        contentView.addSubview(cartImageView)
        
        titlePriceStack.addSubview(titleLabel)
        titlePriceStack.addSubview(priceLabel)
        verticalStack.addArrangedSubview(titlePriceStack)
      
        favoriteImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteTapped))
        favoriteImageView.addGestureRecognizer(tapGesture)
        
        cartImageView.isUserInteractionEnabled = true
                let cartTapGesture = UITapGestureRecognizer(target: self, action: #selector(cartTapped))
                cartImageView.addGestureRecognizer(cartTapGesture)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor), // квадрат
            favoriteImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            favoriteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 40),
            favoriteImageView.heightAnchor.constraint(equalToConstant: 40),
            ratingView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 12),
            verticalStack.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 4),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStack.trailingAnchor.constraint(lessThanOrEqualTo: cartImageView.leadingAnchor, constant: -8),
            verticalStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            
            titlePriceStack.widthAnchor.constraint(equalToConstant: 68),
            titlePriceStack.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: titlePriceStack.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: titlePriceStack.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titlePriceStack.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 22),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: titlePriceStack.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: titlePriceStack.trailingAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 12),
            priceLabel.bottomAnchor.constraint(equalTo: titlePriceStack.bottomAnchor, constant: -1),
            
            cartImageView.topAnchor.constraint(equalTo: verticalStack.topAnchor),
            cartImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartImageView.widthAnchor.constraint(equalToConstant: 40),
            cartImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func favoriteTapped() {
            onFavoriteTap?()
        }
    
    @objc private func cartTapped() {
            onCartTap?()
        }
    // MARK: - Configure
    func configure(with model: NFTItem) {
        imageView.kf.setImage(with: model.imageURL)
        
        titleLabel.text = model.title
        
        favoriteImageView.image = model.isFavorite
            ? UIImage(resource: .likeButtonOn)
            : UIImage(resource: .likeButtonOff)
        
        ratingView.image = ratingImage(for: Int(model.rating))
        priceLabel.text = "\(model.price) ETH"
        
        cartImageView.image = model.isInCart
            ? UIImage(resource: .deleteFromCart)
            : UIImage(resource: .addToCart)
    }
    
    private func ratingImage(for rating: Int) -> UIImage? {
        switch rating {
        case 0: return UIImage(resource: .rating0)
        case 1: return UIImage(resource: .rating1)
        case 2: return UIImage(resource: .rating2)
        case 3: return UIImage(resource: .rating3)
        case 4: return UIImage(resource: .rating4)
        case 5: return UIImage(resource: .rating5)
        default: return UIImage(resource: .rating0)
        }
    }
}

