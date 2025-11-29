import UIKit

final class CartViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let categoriesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isScrollEnabled = true
        tableView.rowHeight = 140
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let totalOfCartView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondary
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let totalNft: UILabel = {
        let label = UILabel()
        label.font = .bodyRegular15
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalCost: UILabel = {
        let label = UILabel()
        label.font = .titleMedium
        label.textColor = .semanticGreen
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let goToPayButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .backgroundSecondary
        button.setTitle("К оплате", for: .normal)
        button.titleLabel?.font = .titleMedium
        button.setTitleColor(.whiteAdaptive, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Setup UI Methods
    
    private func setupViews() {
        view.addSubview(categoriesTableView)
        view.addSubview(totalOfCartView)
        totalOfCartView.addSubview(totalNft)
        totalOfCartView.addSubview(totalCost)
        totalOfCartView.addSubview(goToPayButton)
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
            
            goToPayButton.centerYAnchor.constraint(equalTo: totalOfCartView.centerYAnchor),
            goToPayButton.trailingAnchor.constraint(equalTo: totalOfCartView.trailingAnchor, constant: -16)
        ])
    }
    
    
}
