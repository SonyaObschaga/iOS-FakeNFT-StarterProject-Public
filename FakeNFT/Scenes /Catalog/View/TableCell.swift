import Kingfisher
//
//  CatalogCell.swift
//  FakeNFT
//
//  Created by Илья on 22.11.2025.
//
import UIKit

final class TableCell: UITableViewCell {

    static let reuseIdentifier = "CollectionCell"

    private let coverImageView = UIImageView()
    private let titleLabel = UILabel()
    private let nftsCountLabel = UILabel()
    private var loadedImage: UIImage?
    private let stack = UIStackView()
    private var topConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .backgroundPrimary
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.layer.cornerRadius = 12
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.layer.masksToBounds = true

        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center

        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        nftsCountLabel.font = .systemFont(ofSize: 17, weight: .bold)

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(nftsCountLabel)

        contentView.addSubview(coverImageView)
        contentView.addSubview(stack)

    }

    func setupConstraints() {
        topConstraint = coverImageView.topAnchor.constraint(
            equalTo: contentView.topAnchor
        )

        guard let topConstraint = topConstraint else {
            assertionFailure("topConstraint must be initialized")
            return
        }

        NSLayoutConstraint.activate([
            topConstraint,
            coverImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            coverImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            coverImageView.heightAnchor.constraint(equalToConstant: 140),

            stack.topAnchor.constraint(
                equalTo: coverImageView.bottomAnchor,
                constant: 4
            ),
            stack.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            stack.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: -16
            ),
            stack.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor,
                constant: -13
            ),
        ])
    }

    func configure(with collection: NFTCollection, topSpacing: CGFloat = 0) {
        guard let topConstraint = topConstraint else { return }
        topConstraint.constant = topSpacing

        titleLabel.text = collection.title
        nftsCountLabel.text = "(\(collection.nftsCount))"
        coverImageView.kf.setImage(with: collection.coverURL) {
            [weak self] result in
            guard let self, case .success(let value) = result else { return }
            DispatchQueue.main.async {
                self.loadedImage = value.image
                self.setupImageLayer()
            }
        }
    }

    private func setupImageLayer() {
        guard let image = loadedImage, coverImageView.bounds.width > 0 else {
            return
        }

        coverImageView.layer.contents = image.cgImage
        coverImageView.layer.contentsGravity = .resizeAspectFill

        let scale =
            image.size.width != 0
            ? coverImageView.bounds.width / image.size.width : 1
        let scaledHeight = image.size.height * scale

        if scaledHeight > coverImageView.bounds.height {
            let visibleHeight = coverImageView.bounds.height / scaledHeight
            coverImageView.layer.contentsRect = CGRect(
                x: 0,
                y: 0,
                width: 1,
                height: visibleHeight
            )
        } else {
            coverImageView.layer.contentsRect = CGRect(
                x: 0,
                y: 0,
                width: 1,
                height: 1
            )
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if loadedImage != nil {
            setupImageLayer()
        }
    }
}
