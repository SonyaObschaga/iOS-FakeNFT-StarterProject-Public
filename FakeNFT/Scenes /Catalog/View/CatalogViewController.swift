import UIKit

final class CatalogViewController: UIViewController {
    
    let servicesAssembly: ServicesAssembly
    private let tableView = UITableView()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var presenter: CatalogPresenterProtocol?
    
    init(servicesAssembly: ServicesAssembly) {
           self.servicesAssembly = servicesAssembly
           super.init(nibName: nil, bundle: nil)
       }
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
      }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        presenter?.viewDidLoad()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.reuseIdentifier)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    
    private func setupNavigationBar() {
        // Создаем кнопку сортировки для navigation bar
        let sortButton = UIBarButtonItem(
            image: UIImage(resource: .sort),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        sortButton.tintColor = .label
        
        // Добавляем кнопку в правую часть navigation bar
        navigationItem.rightBarButtonItem = sortButton
    }
    
    @objc private func sortButtonTapped() {
        let alertController = UIAlertController(
            title: NSLocalizedString("sortAlertTitle", comment: "заголовок всплывающее меню сортировки"),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let sortByNameAction = UIAlertAction(
            title: NSLocalizedString("sortByNameTitle", comment: "сортировать по названию"),
            style: .default
        ) { [weak self] _ in
            self?.presenter?.sortCollections(by: .byName)
        }
        
        let sortByCountAction = UIAlertAction(
            title: NSLocalizedString("sortByNFTCountTitle", comment: "сортировать по количеству NFT"),
            style: .default
        ) { [weak self] _ in
            self?.presenter?.sortCollections(by: .byNFTCount)
        }
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("closeTitle", comment: "Закрыть"),
            style: .cancel
        )

        alertController.addAction(sortByNameAction)
        alertController.addAction(sortByCountAction)
        alertController.addAction(cancelAction)
        
        // Для iPad: указываем, откуда должно появиться меню
        if let popover = alertController.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(alertController, animated: true)
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfCollections() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TableCell.reuseIdentifier,
                for: indexPath) as? TableCell else {
            return UITableViewCell()
        }
        guard let collection = presenter?.collection(at: indexPath.row) else { return UITableViewCell()  }
        cell.configure(with: collection, topSpacing: indexPath.row == 0 ? 20 : 8)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectCollection(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - LoadingView
extension CatalogViewController: LoadingView {

}

// MARK: - CatalogViewProtocol
extension CatalogViewController: CatalogViewProtocol {
    func showCollectionDetails(collectionId: String) {
        print("🔵 showCollectionDetails called with id: \(collectionId)")
        print("🔵 navigationController: \(String(describing: navigationController))")
        
        let assembly = CollectionAssembly(servicesAssembly: servicesAssembly)
        let input = CollectionInput(collectionId: collectionId)
        let collectionVC = assembly.build(with: input)
        
        print("🔵 CollectionViewController created: \(collectionVC)")
        
        if let navController = navigationController {
            print("🔵 Pushing CollectionViewController to navigation stack")
            navController.pushViewController(collectionVC, animated: true)
        } else {
            print("🔴 ERROR: navigationController is nil!")
        }
    }
}

