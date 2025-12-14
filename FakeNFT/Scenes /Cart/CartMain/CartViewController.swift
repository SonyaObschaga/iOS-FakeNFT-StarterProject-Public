import UIKit
import ProgressHUD

final class CartViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let reuseIdentifier = "CartCell"
    private var presenter: CartPresenter?
    private var savedImageForDelete: UIImage?
    
    private var fetchedNftIds: [String] = []
    
    // MARK: - UI Elements
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .sort), for: .normal)
        button.tintColor = .blackAdaptive
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cartTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .backgroundPrimary
        tableView.rowHeight = 140
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var totalOfCartView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.backgroundColor = .backgroundSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var totalNft: UILabel = {
        let label = UILabel()
        label.font = .bodyRegular15
        label.textColor = .textPrimary
        label.text = "0 NFT"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var totalCost: UILabel = {
        let label = UILabel()
        label.font = .titleMedium
        label.textColor = .semanticGreen
        label.text = "0 ETH"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var goToPayButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .blackAdaptive
        button.setTitle("К оплате", for: .normal)
        button.titleLabel?.font = .titleMedium
        button.setTitleColor(.whiteAdaptive, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var emptyCartLabel: UILabel = {
        let label = UILabel()
        label.font = .titleMedium
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.text = "Корзина пуста"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundPrimary
        
        presenter = CartPresenter(view: self)
        
        setupViews()
        setupConstraints()
        presenter?.recalcTotal()
        setupTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    // MARK: - Setup UI Methods
    
    private func setupViews() {
        view.addSubview(sortButton)
        view.addSubview(cartTableView)
        view.addSubview(totalOfCartView)
        totalOfCartView.addSubview(totalNft)
        totalOfCartView.addSubview(totalCost)
        totalOfCartView.addSubview(goToPayButton)
        view.addSubview(emptyCartLabel)
        
        cartTableView.register(CartTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        cartTableView.dataSource = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sortButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            
            cartTableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            cartTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cartTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            cartTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            totalOfCartView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            totalOfCartView.heightAnchor.constraint(equalToConstant: 76),
            totalOfCartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            totalOfCartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            totalNft.topAnchor.constraint(equalTo: totalOfCartView.topAnchor, constant: 16),
            totalNft.leadingAnchor.constraint(equalTo: totalOfCartView.leadingAnchor, constant: 16),
            
            totalCost.bottomAnchor.constraint(equalTo: totalOfCartView.bottomAnchor, constant: -16),
            totalCost.leadingAnchor.constraint(equalTo: totalOfCartView.leadingAnchor, constant: 16),
            
            goToPayButton.topAnchor.constraint(equalTo: totalOfCartView.topAnchor, constant: 16),
            goToPayButton.bottomAnchor.constraint(equalTo: totalOfCartView.bottomAnchor, constant: -16),
            goToPayButton.trailingAnchor.constraint(equalTo: totalOfCartView.trailingAnchor, constant: -16),
            goToPayButton.widthAnchor.constraint(equalToConstant: 240),
            
            emptyCartLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyCartLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyCartLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTargets() {
        goToPayButton.addTarget(self, action: #selector(goToPayment), for: .touchUpInside)
        sortButton.addTarget(self, action: #selector(sortTapped), for: .touchUpInside)
    }
    
    private func updateEmptyState(isEmpty: Bool) {
        emptyCartLabel.isHidden = !isEmpty
        cartTableView.isHidden = isEmpty
        totalOfCartView.isHidden = isEmpty
        sortButton.isHidden = isEmpty
    }
    
    
    func showSortOptions() {
        let alert = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        let priceTitle = CartSortOption.price.displayTitle
        alert.addAction(UIAlertAction(title: priceTitle, style: .default, handler: { [weak presenter] _ in
            presenter?.applySort(option: .price)
        }))
        
        let ratingTitle = CartSortOption.rating.displayTitle
        alert.addAction(UIAlertAction(title: ratingTitle, style: .default, handler: { [weak presenter] _ in
            presenter?.applySort(option: .rating)
        }))
        
        let nameTitle = CartSortOption.name.displayTitle
        
        alert.addAction(UIAlertAction(title: nameTitle, style: .default, handler: { [weak presenter] _ in
            presenter?.applySort(option: .name)
        }))
        
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func updateCart(with nftIds: [String]) {
        fetchedNftIds = nftIds
        cartTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc
    private func goToPayment() {
        let paymentViewController = PaymentViewController()
        paymentViewController.modalPresentationStyle = .overFullScreen
        
        present(paymentViewController, animated: true)
    }
    
    @objc
    private func sortTapped() {
        presenter?.sortTapped()
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.rows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CartTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        guard let nft = presenter?.nft(at: indexPath) else { return UITableViewCell() }
        cell.configure(nftName: nft.name, nftImageURL: nft.images.first, rating: nft.rating, price: Float(nft.price))
        return cell
    }
}

extension CartViewController: CartCellDelegate {
    func didTapDelete(in cell: CartTableViewCell, with image: UIImage) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }
        presenter?.handleDeleteTap(at: indexPath)
        savedImageForDelete = image
    }
}

extension CartViewController: DeleteConfirmationDelegate {
    func didConfirmDelete(at indexPath: IndexPath) {
        presenter?.delete(at: indexPath)
    }
}

extension CartViewController: CartView {
    func reload() { cartTableView.reloadData() }
    
    func updateTotal(nftCount: Int, totalPrice: String) {
        totalNft.text = "\(nftCount) NFT"
        totalCost.text = "\(totalPrice) ETH"
        
        updateEmptyState(isEmpty: nftCount == 0)
    }
    
    func showDelete(at indexPath: IndexPath) {
        guard let image = savedImageForDelete else { return }
        
        let deleteConfirmationViewController = DeleteConfirmationViewController(image: image, indexPath: indexPath)
        deleteConfirmationViewController.modalPresentationStyle = .overFullScreen
        deleteConfirmationViewController.delegate = self
        present(deleteConfirmationViewController, animated: true)
    }
    
    func showLoading() {
        ProgressHUD.show()
    }
    
    func hideLoading() {
        ProgressHUD.dismiss()
    }
}
