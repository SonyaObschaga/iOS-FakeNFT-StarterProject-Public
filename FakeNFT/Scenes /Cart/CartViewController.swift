import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - MockData
    
    private let nftData: [TestNFTModel] = [TestNFTModel(name: "Atheen", rating: 5, price: 1.15),
                                           TestNFTModel(name: "Bulbasaur", rating: 3, price: 2.22),
                                           TestNFTModel(name: "Greena", rating: 1, price: 3.09)]
    
    
    // MARK: - Private Properties
    
    private let reuseIdentifier = "CartCell"
    
    // MARK: - UI Elements
    
    private let categoriesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .clear
        tableView.rowHeight = 140
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let totalOfCartView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.backgroundColor = .lightGrayAdaptive
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let totalNft: UILabel = {
        let label = UILabel()
        label.font = .bodyRegular15
        label.textColor = .textPrimary
        label.text = "0 NFT"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalCost: UILabel = {
        let label = UILabel()
        label.font = .titleMedium
        label.textColor = .semanticGreen
        label.text = "0 ETH"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let goToPayButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .blackAdaptive
        button.setTitle("К оплате", for: .normal)
        button.titleLabel?.font = .titleMedium
        button.setTitleColor(.whiteAdaptive, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundPrimary
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup UI Methods
    
    private func setupViews() {
        view.addSubview(categoriesTableView)
        view.addSubview(totalOfCartView)
        totalOfCartView.addSubview(totalNft)
        totalOfCartView.addSubview(totalCost)
        totalOfCartView.addSubview(goToPayButton)
        
        categoriesTableView.register(CartTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        categoriesTableView.dataSource = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            categoriesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
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
            goToPayButton.widthAnchor.constraint(equalToConstant: 240)
        ])
    }
    
    
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nftData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CartTableViewCell else { return UITableViewCell() }
        
        let nft = nftData[indexPath.row]
        cell.configure(nftName: nft.name, nftImageURL: "", rating: nft.rating, price: nft.price)
        return cell
    }
}
