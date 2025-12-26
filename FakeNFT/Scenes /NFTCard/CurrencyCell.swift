//
//  currenciesCell.swift
//  FakeNFT
//
//  Created by Илья on 07.12.2025.
//

import Kingfisher
import UIKit

final class CurrencyCell: UITableViewCell {
    static let reuseIdentifier = "currenciesCell"

    private let logoView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 6
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceUsdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceBtcLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.textColor = UIColor(named: "GreenPrice") ?? .systemGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let namePriceView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .backgroundSecondary
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        setupSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        contentView.addSubview(logoView)
        contentView.addSubview(namePriceView)
        namePriceView.addSubview(titleLabel)
        namePriceView.addSubview(priceUsdLabel)
        contentView.addSubview(priceBtcLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 16
            ),
            logoView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            logoView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -16
            ),
            logoView.widthAnchor.constraint(equalToConstant: 32),

            namePriceView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 16
            ),
            namePriceView.leadingAnchor.constraint(
                equalTo: logoView.trailingAnchor,
                constant: 10
            ),
            namePriceView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -16
            ),
            namePriceView.widthAnchor.constraint(equalToConstant: 81),

            titleLabel.topAnchor.constraint(equalTo: namePriceView.topAnchor),
            titleLabel.leadingAnchor.constraint(
                equalTo: namePriceView.leadingAnchor
            ),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),

            priceUsdLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 2
            ),
            priceUsdLabel.leadingAnchor.constraint(
                equalTo: namePriceView.leadingAnchor
            ),
            priceUsdLabel.bottomAnchor.constraint(
                equalTo: namePriceView.bottomAnchor
            ),
            priceUsdLabel.heightAnchor.constraint(equalToConstant: 20),

            priceBtcLabel.topAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: 27
            ),
            priceBtcLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            priceBtcLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -27
            ),
            priceBtcLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }

    func configure(
        with imageURL: URL,
        name: String,
        priceUsd: String,
        priceBtc: String
    ) {
        logoView.kf.setImage(with: imageURL)
        titleLabel.text = name
        priceUsdLabel.text = priceUsd
        priceBtcLabel.text = priceBtc
    }
}
