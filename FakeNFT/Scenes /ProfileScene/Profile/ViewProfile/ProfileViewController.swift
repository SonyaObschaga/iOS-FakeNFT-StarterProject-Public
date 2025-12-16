//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 23/11/25.
//

import UIKit
import SafariServices

final class ProfileViewController: UIViewController, LoadingView, ErrorView {

    var originalBackgroundColor: UIColor = .black
    
    var tableCells: [ProfileCellModel] = []

    private var presenter: ProfilePresenterProtocol!
    func configure (_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
        
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        hideControls()
        self.showLoading()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    
    //MARK: - Layout variables
    private lazy var editButton: UIButton = {
        let imageButton = UIImage(resource: .edit)
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        
        return button
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "person"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        
        return imageView
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .ypBlackDay
        
        return label
    }()

    lazy var bioTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 13, weight: .regular)
        textView.textColor = .ypBlackDay
        textView.isEditable = false

        return textView
    }()
    
    lazy var urlButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitleColor(.ypBlueUniversal, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(openWebView), for: .touchUpInside)

        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(
            ProfileTableViewCell.self,
            forCellReuseIdentifier: ProfileTableViewCell.reuseIdentifier
        )
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypWhiteDay
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsMultipleSelection = false
        tableView.rowHeight = 54
        
        return tableView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        
        // Center the activity indicator
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return indicator
    }()
    
}

//MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableCells[indexPath.row].action()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(
            name: tableCells[indexPath.row].name,
            count: tableCells[indexPath.row].count
        )
        
        return cell
    }
}

//MARK: - Private functions
// private
extension ProfileViewController {
    func setupView() {
        view.backgroundColor = .ypWhiteDay
        navigationController?.navigationBar.isHidden = true
        
        addSubViews()
        configureConstraints()
        fillTableCells(nftsCount: 0, likesCount: 0)
        
    }
    
    func addSubViews() {
        view.addSubview(editButton)
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(bioTextView)
        view.addSubview(urlButton)
        view.addSubview(tableView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            bioTextView.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioTextView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            bioTextView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            bioTextView.heightAnchor.constraint(equalToConstant: 75),
            
            urlButton.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            urlButton.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 8),
            urlButton.heightAnchor.constraint(equalToConstant: 28),
            
            tableView.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: urlButton.bottomAnchor, constant: 40),
            tableView.heightAnchor.constraint(equalToConstant: 162)
        ])
    }
    
    private func myNftViewController() -> MyNftViewController {
        let myNftViewController = MyNftViewController()
        let nftPresenter = NFTPresenter(servicesAssembly: self.presenter.servicesAssembly, isFavoritesPresenter: false)
        myNftViewController.configure(nftPresenter)
        myNftViewController.hidesBottomBarWhenPushed = true
        
        return myNftViewController
    }
    private func likedNftViewController() -> FavoriteNftsViewController {
        let myNftViewController = FavoriteNftsViewController()
        let nftPresenter = NFTPresenter(servicesAssembly: self.presenter.servicesAssembly, isFavoritesPresenter: true)
        myNftViewController.configure(nftPresenter)
        myNftViewController.hidesBottomBarWhenPushed = true
        
        return myNftViewController
    }
    
    func fillTableCells(nftsCount: Int, likesCount: Int) {
        
        tableCells.append(
            ProfileCellModel(
                name: "Мои NFT",
                count: 0,
                action: { [weak self] in
                    guard let self = self else { return }
                    self.navigationController?.pushViewController(
                        myNftViewController(),
                        animated: true
                    )
                })
        )
        tableCells.append(
            ProfileCellModel(
                name: "Избранные NFT",
                count: 0,
                action: { [weak self] in
                    guard let self = self else { return }
                    self.navigationController?.pushViewController(
                        likedNftViewController(),
                        animated: true
                    )
                })
        )
        tableCells.append(
            ProfileCellModel(
                name: "О разработчике",
                count: nil,
                action: { [weak self] in
                    guard let self = self else { return }
                    self.openWebView()
                })
        )
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc
    func editProfile() {
        let vc = EditProfileViewController()
        
        let profilePresenter =
        ProfilePresenter(servicesAssembly:presenter.servicesAssembly)
        vc.configure(profilePresenter)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc
    func openWebView() {
        if let url = URL(string: "https://practicum.yandex.ru/") {
            presentSafariViewController(with: url)
        }
    }
    
    private func presentSafariViewController(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
