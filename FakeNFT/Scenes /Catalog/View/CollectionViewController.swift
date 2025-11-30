//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Илья on 29.11.2025.
//

import UIKit
import Kingfisher

final class CollectionViewController: UIViewController {

    let scrollView = UIScrollView()
    let topImage = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let authorLabel = UILabel()
    private var data = mockNFTs
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "MyCell")
        return collectionView
    }()
   
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var presenter: CollectionPresenterProtocol?
    
    let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
           self.servicesAssembly = servicesAssembly
           super.init(nibName: nil, bundle: nil)
       }
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
      }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Убрать текст "Назад", оставить только стрелку "<"
        navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        scrollView.contentInsetAdjustmentBehavior = .never
        setupTableView()
        
        // Настраиваем отступ снизу для таббара
        setupScrollViewContentInset()
        
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Обновляем отступ при изменении layout
        setupScrollViewContentInset()
    }
    
    private func setupScrollViewContentInset() {
        // Используем safeAreaInsets для автоматического учета таббара и других безопасных областей
        let bottomInset = view.safeAreaInsets.bottom
        
        // Устанавливаем contentInset для scrollView, чтобы контент не перекрывался таббаром
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }

    private func setupTableView() {
        setupScrollView()
        setupTopImage()
        setupLabels()
        setupAuthor()
        setupDescription()
        
        setupCollectionView()
        setupConstraints()
    
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    private func setupTopImage() {
        scrollView.addSubview(topImage)
        topImage.translatesAutoresizingMaskIntoConstraints = false
        
        topImage.contentMode = .scaleAspectFill
        topImage.clipsToBounds = true
        topImage.layer.cornerRadius = 12
      //  topImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // верхние углы
        
        NSLayoutConstraint.activate([
            topImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            topImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            topImage.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            topImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            topImage.heightAnchor.constraint(equalToConstant: 310)
        ])
    }
    private func setupLabels() {
        scrollView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topImage.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
           // titleLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -28)
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    private func setupAuthor() {
        scrollView.addSubview(authorLabel)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false

        authorLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)

        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            //titleLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
            authorLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    private func setupDescription() {
        scrollView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)

        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 0),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            descriptionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    private func setupCollectionView() {
        scrollView.addSubview(collectionView)
        
        // Настройка layout для отступов между ячейками
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
        }
        
        // Рассчитываем высоту на основе количества ячеек (10 ячеек в 3 колонки = 4 ряда)
        let screenWidth = UIScreen.main.bounds.width
        let sideInsets: CGFloat = 32
        let spacingBetweenCells: CGFloat = 8 * 2
        let totalSpacing = sideInsets + spacingBetweenCells
        let cellWidth = (screenWidth - totalSpacing) / 3
        let numberOfRows = ceil(CGFloat(10) / 3.0) // 10 ячеек / 3 колонки = 4 ряда
        let rowSpacing: CGFloat = 9
        let initialHeight = (numberOfRows * cellWidth) + ((numberOfRows - 1) * rowSpacing)
        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: initialHeight)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            collectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            collectionViewHeightConstraint!,
            // Привязываем bottom к contentLayoutGuide для правильной работы scrollView
            collectionView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    private func setupConstraints() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension CollectionViewController: CollectionViewProtocol {
    func displayCollection(title: String, description: String, author: String, coverURL: URL) {
        titleLabel.text = title
        descriptionLabel.text = description
        authorLabel.text = author
        
        // Загрузка изображения из URL с помощью Kingfisher
        topImage.kf.setImage(with: coverURL)
    }
    
    func reloadNFTs() {
        collectionView.reloadData()
        // Пересчитываем высоту collectionView после загрузки данных
        DispatchQueue.main.async { [weak self] in
            self?.updateCollectionViewHeight()
        }
    }
    
    private func updateCollectionViewHeight() {
        collectionView.layoutIfNeeded()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        print("🔵 CollectionView contentSize height: \(height)")
        print("🔵 CollectionView bounds: \(collectionView.bounds)")
        collectionViewHeightConstraint?.constant = height > 0 ? height : 500 // Увеличил для теста
        view.layoutIfNeeded()
    }
}
extension CollectionViewController: LoadingView { }

extension CollectionViewController: UICollectionViewDataSource {
    // MARK: - DataSource
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            data.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
            cell.configure(with: data[indexPath.item])
            return cell
        }
}
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            // Используем ширину view минус отступы по бокам (16 + 16 = 32)
            let screenWidth = view.bounds.width > 0 ? view.bounds.width : UIScreen.main.bounds.width
            let sideInsets: CGFloat = 32 // 16 с каждой стороны
            let spacingBetweenCells: CGFloat = 8 * 2 // между 3 ячейками 2 промежутка по 8
            let totalSpacing = sideInsets + spacingBetweenCells // 32 + 16 = 48
            
            let width = (screenWidth - totalSpacing) / 3
            print("🔵 sizeForItemAt indexPath: \(indexPath), size: \(CGSize(width: width, height: width))")

            return CGSize(width: width, height: 192) // квадрат
        }
}
