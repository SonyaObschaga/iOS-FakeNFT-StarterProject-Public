import UIKit

final class CatalogViewController: UIViewController {
    
    let servicesAssembly: ServicesAssembly
    private let sortButton = UIButton()
    
    init(servicesAssembly: ServicesAssembly) {
           self.servicesAssembly = servicesAssembly
           super.init(nibName: nil, bundle: nil)
       }
    
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
      }
    
    private let tableView = UITableView()
    
    internal lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var presenter: CatalogPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSortButton()
        setupTableView()
        presenter.viewDidLoad()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            
            tableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Constraints для индикатора загрузки (по центру таблицы)
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CollectionCell.self, forCellReuseIdentifier: CollectionCell.reuseIdentifier)
        
        // Настройка отступов между ячейками через separator
        tableView.separatorStyle = .none  // Убираем стандартный separator
        tableView.backgroundColor = .clear  // Прозрачный фон для видности отступов
    }
    
    private func setupSortButton() {
           sortButton.translatesAutoresizingMaskIntoConstraints = false
           //sortButton.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
           // или ваша кастомная картинка:
           sortButton.setImage(UIImage(named: "sort"), for: .normal)
           sortButton.tintColor = .label
           sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
           
           view.addSubview(sortButton)
       }
    
    @objc private func sortButtonTapped() {
        // 1. Создаём Alert Controller с Action Sheet стилем
        let alertController = UIAlertController(
            title: "Сортировка",
            message: nil,  // или nil для без сообщения
            preferredStyle: .actionSheet
        )
        
        // 2. Добавляем варианты сортировки
        let sortByNameAction = UIAlertAction(
            title: "По названию",
            style: .default
        ) { [weak self] _ in
            self?.presenter.sortCollections(by: .byName)
        }
        
        let sortByCountAction = UIAlertAction(
            title: "По количеству NFT",
            style: .default
        ) { [weak self] _ in
            self?.presenter.sortCollections(by: .byNFTCount)
        }
        
        // 3. Добавляем кнопку отмены
        let cancelAction = UIAlertAction(
            title: "Закрыть",
            style: .cancel
        )
        
        // 4. Добавляем actions в alert controller
        alertController.addAction(sortByNameAction)
        alertController.addAction(sortByCountAction)
        alertController.addAction(cancelAction)
        
        // 5. Для iPad нужно указать источник (popover)
        if let popover = alertController.popoverPresentationController {
            popover.sourceView = sortButton
            popover.sourceRect = sortButton.bounds
        }
        
        // 6. Показываем меню
        present(alertController, animated: true)
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfCollections()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CollectionCell.reuseIdentifier,
                for: indexPath) as? CollectionCell else {
            return UITableViewCell()
        }
        let collection = presenter.collection(at: indexPath.row)
        // Для первой ячейки (row == 0) нет отступа сверху, для остальных - 8pt
        cell.configure(with: collection, topSpacing: indexPath.row == 0 ? 0 : 8)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectCollection(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Вариант 2: Отступ между ячейками через высоту footer секции (альтернативный способ)
    // Но это работает только между секциями, не между ячейками в одной секции
    // func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //     return section == 0 ? 0 : 8  // Отступ только между секциями
    // }
}

// MARK: - LoadingView
extension CatalogViewController: LoadingView {
    // Методы showLoading() и hideLoading() уже реализованы в протоколе LoadingView
    // Они автоматически работают с activityIndicator
}


//final class CatalogViewController: UIViewController {
//
//    let servicesAssembly: ServicesAssembly
//    let testNftButton = UIButton()
//
//    init(servicesAssembly: ServicesAssembly) {
//        self.servicesAssembly = servicesAssembly
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .systemBackground
//
//        view.addSubview(testNftButton)
//        testNftButton.constraintCenters(to: view)
//        testNftButton.setTitle(Constants.openNftTitle, for: .normal)
//        testNftButton.addTarget(self, action: #selector(showNft), for: .touchUpInside)
//        testNftButton.setTitleColor(.systemBlue, for: .normal)
//    }
//
//    @objc
//    func showNft() {
//        let assembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
//        let nftInput = NftDetailInput(id: Constants.testNftId)
//        let nftViewController = assembly.build(with: nftInput)
//        present(nftViewController, animated: true)
//    }
//}
//
//private enum Constants {
//    static let openNftTitle = NSLocalizedString("Catalog.openNft", comment: "")
//    static let testNftId = "7773e33c-ec15-4230-a102-92426a3a6d5a"
//}
