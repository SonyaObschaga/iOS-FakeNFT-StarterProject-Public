import UIKit

// MARK: - User
struct User {
    let name: String
    let score: Int
    let position: Int
}

// MARK: - Constants
enum StatisticConstants {
    static let topInset: CGFloat = 20
    static let leadingInset: CGFloat = 16
    static let trailingInset: CGFloat = -16
    static let bottomInset: CGFloat = -20
}

// MARK: - StatisticViewController
final class StatisticViewController: UIViewController {
    
    // MARK: - Properties
    let servicesAssembly: ServicesAssembly
    var users: [User] = [
        User(name: "Иван", score: 100, position: 1),
        User(name: "Мария", score: 85, position: 3),
        User(name: "Петр", score: 92, position: 2),
        User(name: "Иван", score: 100, position: 1),
        User(name: "Мария", score: 85, position: 3),
        User(name: "Петр", score: 92, position: 2),
        User(name: "Иван", score: 100, position: 1),
        User(name: "Мария", score: 85, position: 3),
        User(name: "Петр", score: 92, position: 2),
        User(name: "Иван", score: 100, position: 1),
        User(name: "Мария", score: 85, position: 3),
        User(name: "Петр", score: 92, position: 2)
    ]
    
    // MARK: - UI Elements
    private let tableView = UITableView()
    
    // MARK: - Initialization
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: StatisticTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: StatisticConstants.topInset),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: StatisticConstants.leadingInset),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: StatisticConstants.trailingInset),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: StatisticConstants.bottomInset)
        ])
    }
}

extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticTableViewCell.reuseIdentifier) as? StatisticTableViewCell else {
            return UITableViewCell()
        }
        
        let user = users[indexPath.row]
        cell.configure(with: user)
        return cell
    }
}

extension StatisticViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
