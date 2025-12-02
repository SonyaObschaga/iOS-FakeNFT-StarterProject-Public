import UIKit

// MARK: - StatisticViewController
final class StatisticViewController: UIViewController {
    
    // MARK: - Property
    private let presenter: StatisticPresenterProtocol
    
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: StatisticTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "sortMenu"), for: .normal)
        button.addTarget(self, action: #selector(didTapSortButton), for: .touchUpInside)
        button.tintColor = .ypBlackLight
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(presenter: StatisticPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter.viewDidLoad()
    }
    
    // MARK: - Action
    @objc private func didTapSortButton() {
        presenter.didTapSortButton()
    }
    // MARK: - SetupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupSortButton()
        setupTableView()
    }
    
    private func setupSortButton() {
        view.addSubview(sortButton)
        
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: StatisticConstants.leadingInset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: StatisticConstants.trailingInset),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: StatisticConstants.bottomInset)
        ])
    }
    
    
    // MARK: - Private Methods
    private func showErrorAlert(message: String, retryHandler: (() -> Void)?) {
        let alert = UIAlertController(
            title: NSLocalizedString("Tab.statistic", comment: ""),
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Error.alert.cancel", comment: ""), style: .cancel))
        
        if let retryHandler = retryHandler {
            alert.addAction(UIAlertAction(title: NSLocalizedString("Error.repeat", comment: ""), style: .default) { _ in
                retryHandler()
            })
        }
        present(alert, animated: true)
    }
}

// MARK: - StatisticProtocol
extension StatisticViewController: StatisticViewProtocol {
    func displayUsers(_ users: [User]) {
        tableView.reloadData()
    }
    
    func showError(message: String, retryHandler: (() -> Void)?) {
        showErrorAlert(message: message, retryHandler: retryHandler)
    }
    func showLoading() {
    }
    
    func hideLoading() {
    }
    
    func showSortOptions() {
        let alertController = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        for option in SortOption.allCases {
            let action = UIAlertAction(
                title: option.rawValue,
                style: option.isCancel ? .cancel : .default
            ) { [weak self] _ in
                if !option.isCancel {
                    self?.presenter.didSelectSortOption(option)
                }
            }
            
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? StatisticTableViewCell else {
            return UITableViewCell()
        }
        
        let user = presenter.user(at: indexPath.row)
        cell.configure(with: user, position: indexPath.row + 1)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension StatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectUser(at: indexPath.row)
    }
}
