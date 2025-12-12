//
//  NFTCardViewController.swift
//  FakeNFT
//
//  Created by Илья on 07.12.2025.
//

import Kingfisher
import SafariServices
import UIKit

final class NFTCardViewController: UIViewController, UIGestureRecognizerDelegate
{

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = true
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let nameRatingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let priceAndBuyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceHorizontal = true
        collectionView.alwaysBounceVertical = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            NftImageCollectionViewCell.self,
            forCellWithReuseIdentifier: "NftImageCell"
        )
        return collectionView
    }()

    private let pageControl: LinePageControl = {
        let pageControl = LinePageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(
            .defaultLow,
            for: .horizontal
        )
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private let ratingView: UIImageView = {
        let rv = UIImageView()
        rv.contentMode = .scaleAspectFit
        rv.clipsToBounds = true
        rv.translatesAutoresizingMaskIntoConstraints = false
        return rv
    }()

    private let collectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        label.text = "Цена"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить в корзину", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        return tableView
    }()

    private let sellerWebsiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Перейти на сайт продавца", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.backgroundColor = .white
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var nftCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            CollectionCell.self,
            forCellWithReuseIdentifier: "CollectionCell"
        )
        return collectionView
    }()

    private var nftItems: [NFTItem] = []

    private var tableViewHeightConstraint: NSLayoutConstraint?

    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    var presenter: NFTCardPresenterProtocol?
    private var imageURLs: [URL] = []
    private var currencies: [Currency] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(
            image: UIImage(resource: .backChevron),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        backButton.tintColor = .label
        navigationItem.leftBarButtonItem = backButton

        view.backgroundColor = .systemBackground
        setupUI()
        setupGestureRecognizers()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            CurrencyCell.self,
            forCellReuseIdentifier: CurrencyCell.reuseIdentifier
        )
        sellerWebsiteButton.addTarget(
            self,
            action: #selector(openSellerWebsite),
            for: .touchUpInside
        )
        buyButton.addTarget(
            self,
            action: #selector(buyButtonTapped),
            for: .touchUpInside
        )
        presenter?.viewDidLoad()
    }

    @objc private func buyButtonTapped() {
        presenter?.didTapBuyButton()
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)
        contentView.addSubview(nameRatingView)
        nameRatingView.addSubview(titleLabel)
        nameRatingView.addSubview(ratingView)
        nameRatingView.addSubview(collectionLabel)

        contentView.addSubview(priceAndBuyView)
        priceAndBuyView.addSubview(priceTitleLabel)
        priceAndBuyView.addSubview(priceLabel)
        priceAndBuyView.addSubview(buyButton)

        contentView.addSubview(tableView)
        contentView.addSubview(sellerWebsiteButton)
        contentView.addSubview(nftCollectionView)

        view.addSubview(activityIndicator)

        collectionView.layer.cornerRadius = 40
        collectionView.layer.maskedCorners = [
            .layerMinXMaxYCorner, .layerMaxXMaxYCorner,
        ]
        collectionView.clipsToBounds = true

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.topAnchor
            ),
            contentView.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor
            ),
            contentView.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor
            ),
            contentView.widthAnchor.constraint(
                equalTo: scrollView.frameLayoutGuide.widthAnchor
            ),
            contentView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor
            ),

            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            collectionView.widthAnchor.constraint(
                equalTo: contentView.widthAnchor
            ),
            collectionView.heightAnchor.constraint(
                equalTo: collectionView.widthAnchor
            ),

            pageControl.topAnchor.constraint(
                equalTo: collectionView.bottomAnchor,
                constant: 12
            ),
            pageControl.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),
            pageControl.heightAnchor.constraint(equalToConstant: 4),
            pageControl.widthAnchor.constraint(
                equalTo: contentView.widthAnchor,
                constant: -32
            ),

            nameRatingView.topAnchor.constraint(
                equalTo: pageControl.bottomAnchor,
                constant: 16
            ),
            nameRatingView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            nameRatingView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            nameRatingView.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.topAnchor.constraint(equalTo: nameRatingView.topAnchor),
            titleLabel.leadingAnchor.constraint(
                equalTo: nameRatingView.leadingAnchor
            ),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            titleLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: ratingView.leadingAnchor,
                constant: -8
            ),

            ratingView.topAnchor.constraint(
                equalTo: nameRatingView.topAnchor,
                constant: 8
            ),
            ratingView.bottomAnchor.constraint(
                equalTo: nameRatingView.bottomAnchor,
                constant: -8
            ),
            ratingView.leadingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor,
                constant: 8
            ),
            ratingView.heightAnchor.constraint(equalToConstant: 12),
            ratingView.widthAnchor.constraint(equalToConstant: 68),

            collectionLabel.topAnchor.constraint(
                equalTo: nameRatingView.topAnchor,
                constant: 3
            ),
            collectionLabel.bottomAnchor.constraint(
                equalTo: nameRatingView.bottomAnchor,
                constant: -3
            ),
            collectionLabel.leadingAnchor.constraint(
                equalTo: ratingView.trailingAnchor,
                constant: 10
            ),
            collectionLabel.trailingAnchor.constraint(
                equalTo: nameRatingView.trailingAnchor
            ),

            priceAndBuyView.topAnchor.constraint(
                equalTo: nameRatingView.bottomAnchor,
                constant: 24
            ),
            priceAndBuyView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            priceAndBuyView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            priceAndBuyView.heightAnchor.constraint(equalToConstant: 44),

            priceTitleLabel.topAnchor.constraint(
                equalTo: priceAndBuyView.topAnchor
            ),
            priceTitleLabel.leadingAnchor.constraint(
                equalTo: priceAndBuyView.leadingAnchor
            ),
            priceTitleLabel.heightAnchor.constraint(equalToConstant: 20),

            priceLabel.topAnchor.constraint(
                equalTo: priceTitleLabel.bottomAnchor,
                constant: 2
            ),
            priceLabel.leadingAnchor.constraint(
                equalTo: priceAndBuyView.leadingAnchor
            ),
            priceLabel.widthAnchor.constraint(equalToConstant: 100),

            buyButton.topAnchor.constraint(equalTo: priceTitleLabel.topAnchor),
            buyButton.trailingAnchor.constraint(
                equalTo: priceAndBuyView.trailingAnchor
            ),
            buyButton.widthAnchor.constraint(equalToConstant: 240),
            buyButton.heightAnchor.constraint(equalToConstant: 44),

            tableView.topAnchor.constraint(
                equalTo: priceAndBuyView.bottomAnchor,
                constant: 24
            ),
            tableView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            tableView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),

            sellerWebsiteButton.topAnchor.constraint(
                equalTo: tableView.bottomAnchor,
                constant: 16
            ),
            sellerWebsiteButton.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            sellerWebsiteButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            sellerWebsiteButton.heightAnchor.constraint(equalToConstant: 40),

            nftCollectionView.topAnchor.constraint(
                equalTo: sellerWebsiteButton.bottomAnchor,
                constant: 36
            ),
            nftCollectionView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            nftCollectionView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            nftCollectionView.heightAnchor.constraint(equalToConstant: 192),

            contentView.bottomAnchor.constraint(
                greaterThanOrEqualTo: nftCollectionView.bottomAnchor
            ),

            activityIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            activityIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),
        ])

        tableViewHeightConstraint = tableView.heightAnchor.constraint(
            equalToConstant: 518
        )
        tableViewHeightConstraint?.isActive = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()

        let fixedHeight: CGFloat = 74 * 7
        tableViewHeightConstraint?.constant = fixedHeight

        let bottomInset = view.safeAreaInsets.bottom
        scrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: bottomInset,
            right: 0
        )
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    private func setupGestureRecognizers() {
        scrollView.delegate = self
        collectionView.isUserInteractionEnabled = true
    }

    @objc private func openSellerWebsite() {
        if let url = URL(string: AppURLs.practicumIOSDeveloper) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
    }
}

// MARK: - NFTCardViewProtocol
extension NFTCardViewController: NFTCardViewProtocol {
    func displayNFT(
        name: String,
        rating: Int,
        price: Double,
        collectionName: String
    ) {
        titleLabel.text = name
        ratingView.image = UIImage.ratingImage(for: rating)
        let firstWord =
            collectionName.components(separatedBy: " ").first ?? collectionName
        collectionLabel.text = firstWord
        priceLabel.text = String(format: "%.2f ETH", price)
    }

    func displayImages(_ imageURLs: [URL]) {
        self.imageURLs = imageURLs
        pageControl.numberOfItems = imageURLs.count
        collectionView.reloadData()
    }

    func showLoading() {
        activityIndicator.startAnimating()
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
    }

    func displayCurrencies(_ currencies: [Currency]) {
        self.currencies = currencies
        tableView.reloadData()
    }

    func displayNFTCollection(_ nftItems: [NFTItem]) {
        self.nftItems = nftItems
        nftCollectionView.reloadData()
    }
    func reloadNFTCollectionItem(at index: Int) {
        if index < nftItems.count, let updatedNFT = presenter?.nft(at: index) {
            nftItems[index] = updatedNFT
            let indexPath = IndexPath(item: index, section: 0)
            nftCollectionView.reloadItems(at: [indexPath])
        }
    }
    func updateBuyButtonState(isInCart: Bool) {
        if isInCart {
            buyButton.setTitle("Удалить из корзины", for: .normal)
            buyButton.backgroundColor = .systemRed
        } else {
            buyButton.setTitle("Добавить в корзину", for: .normal)
            buyButton.backgroundColor = .systemBlue
        }
    }
}

// MARK: - UICollectionViewDataSource
extension NFTCardViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView === nftCollectionView {
            return nftItems.count
        }
        return imageURLs.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if collectionView === nftCollectionView {
            guard
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "CollectionCell",
                    for: indexPath
                ) as? CollectionCell
            else {
                return UICollectionViewCell()
            }
            let nftItem = nftItems[indexPath.item]
            cell.configure(with: nftItem)

            cell.onFavoriteTap = { [weak self] in
                self?.presenter?.didTapFavorite(at: indexPath.item)
            }

            cell.onCartTap = { [weak self] in
                self?.presenter?.didTapCart(at: indexPath.item)
            }
            return cell
        }

        guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "NftImageCell",
                    for: indexPath
                ) as? NftImageCollectionViewCell else {
                    assertionFailure("Failed to dequeue NftImageCollectionViewCell")
                    return UICollectionViewCell()
                }
                let cellModel = NftDetailCellModel(url: imageURLs[indexPath.item])
                cell.configure(with: cellModel)
                return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NFTCardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView === nftCollectionView {
            let screenWidth = collectionView.frame.width
            let sideInsets: CGFloat = 0
            let spacingBetweenCells: CGFloat = 8 * 2
            let totalSpacing = sideInsets + spacingBetweenCells
            let width = (screenWidth - totalSpacing) / 3
            return CGSize(width: width, height: 192)
        }

        let width =
            collectionView.frame.width > 0
            ? collectionView.frame.width : view.bounds.width
        let height =
            collectionView.frame.height > 0
            ? collectionView.frame.height : width
        return CGSize(width: width, height: height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView === collectionView else { return }
        let pageIndex = Int(
            scrollView.contentOffset.x / scrollView.frame.size.width
        )
        pageControl.selectedItem = pageIndex
    }
}

// MARK: - LoadingView
extension NFTCardViewController: LoadingView {}

// MARK: - UIScrollViewDelegate
extension NFTCardViewController: UIScrollViewDelegate {
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
}

// MARK: - UITableViewDataSource
extension NFTCardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return currencies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CurrencyCell.reuseIdentifier,
                for: indexPath
            ) as? CurrencyCell
        else {
            assertionFailure("Failed to dequeue CurrencyCell")
            return UITableViewCell()
        }

        let currency = currencies[indexPath.row]
        let currencyRateString =
            presenter?.currencyRateInUSD(for: currency) ?? "$0.00"
        let priceCurrencyString =
            presenter?.priceInCurrency(for: currency) ?? "0.00"

        cell.configure(
            with: currency.imageURL,
            name: "\(currency.title) (\(currency.name))",
            priceUsd: currencyRateString,
            priceBtc: priceCurrencyString
        )
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NFTCardViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 74
    }
}
