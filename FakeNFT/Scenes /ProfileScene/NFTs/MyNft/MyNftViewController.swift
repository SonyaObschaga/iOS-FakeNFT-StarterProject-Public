//
//  MyNftViewController.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 23/11/25.
//

import UIKit

final class MyNftViewController: UIViewController {

    internal var _nfts : [NFTModel]? // = FakeNFTService.shared.profile.nfts
    internal var nfts: [NFTModel] {
        guard let nftsArray = _nfts else {
            fatalError("Undefined NFTs array for MyNftViewController")
        }
        return nftsArray
    }
    
    private var presenter: NFTPresenterProtocol!
    func configure (_ presenter: NFTPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupView()
    }

    //MARK: - Layout variables
    private lazy var backButton: UIButton = {
        let imageButton = UIImage(resource: .backChevron)
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        return button
    }()
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlackDay
        label.text = "Мои NFT"
        
        return label
    }()
    private lazy var filtersButton: UIButton = {
        let imageButton = UIImage(named: "Sort")
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(sort), for: .touchUpInside)
        
        return button
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(MyNftTableViewCell.self, forCellReuseIdentifier: "myNftTableViewCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypWhiteDay
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        tableView.rowHeight = 140
        
        return tableView
    }()
    private lazy var emptyNftsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .ypBlackDay
        label.text = "У Вас ещё нет NFT"
        
        return label
    }()
}

//MARK: - UITableViewDataSource
extension MyNftViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "myNftTableViewCell",
            for: indexPath
        ) as? MyNftTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(nft: nfts[indexPath.row])
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension MyNftViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCell(cellIndex: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - Private functions
private extension MyNftViewController{
    func setupView() {
        view.backgroundColor = .ypWhiteDay
        
        let showHideElements = nfts.isEmpty
        emptyNftsLabel.isHidden = !showHideElements
        filtersButton.isHidden = showHideElements
        headerLabel.isHidden = showHideElements
        tableView.isHidden = showHideElements
        
        addSubViews()
        configureConstraints()
    }
    
    func addSubViews() {
        view.addSubview(emptyNftsLabel)
        view.addSubview(backButton)
        view.addSubview(filtersButton)
        view.addSubview(headerLabel)
        view.addSubview(tableView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            emptyNftsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyNftsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            
            filtersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            filtersButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
    
            headerLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func selectCell(cellIndex: Int) {

    }
    
    func showSortAlert() {
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(title: "По цене",
                                      style: .default) { _ in

        })
        alert.addAction(UIAlertAction(
            title: "По рейтингу",
            style: .default
        ) { _ in
        })
        alert.addAction(UIAlertAction(
            title: "По названию",
            style: .default
        ) { _ in
        })
        alert.addAction(UIAlertAction(
            title: "Закрыть",
            style: .cancel
        ) { _ in
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    func back() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    func sort() {
        showSortAlert()
    }
}
