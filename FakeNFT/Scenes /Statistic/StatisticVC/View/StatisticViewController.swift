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
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: CellConstants.sortMenuImageName), for: .normal)
        button.addTarget(self, action: #selector(didTapSortButton), for: .touchUpInside)
        button.tintColor = .primary
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
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
        setupLoadingIndicator()
    }
    
    private func setupSortButton() {
        view.addSubview(sortButton)
        
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: StatisticConstants.sortButtonTopInset),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: StatisticConstants.sortButtonTrailingInset),
            sortButton.widthAnchor.constraint(equalToConstant: StatisticConstants.sortButtonSize),
            sortButton.heightAnchor.constraint(equalToConstant: StatisticConstants.sortButtonSize)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: StatisticConstants.sortButtonTableViewSpacing),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: StatisticConstants.leadingInset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: StatisticConstants.trailingInset),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: StatisticConstants.bottomInset)
        ])
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
    
    // MARK: - Private Method
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

// MARK: - StatisticViewProtocol
extension StatisticViewController: StatisticViewProtocol {
    func displayUsers(_ users: [User]) {
        tableView.reloadData()
    }
    
    func showError(message: String, retryHandler: (() -> Void)?) {
        showErrorAlert(message: message, retryHandler: retryHandler)
    }
    
    func showSortOptions() {
        let alertController = UIAlertController(
            title: CellConstants.sortAlertTitle,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        for option in SortStatisticOption.allCases {
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
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
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
