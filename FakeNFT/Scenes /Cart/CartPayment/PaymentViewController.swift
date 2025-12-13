import UIKit
import ProgressHUD

final class PaymentViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var presenter: PaymentPresenter?
    
    // MARK: - UI Elements
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .backChevron), for: .normal)
        button.tintColor = .blackAdaptive
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите способ оплаты"
        label.font = .titleMedium
        label.textAlignment = .center
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.register(PaymentCollectionViewCell.self, forCellWithReuseIdentifier: PaymentCollectionViewCell.reuseIdentifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.backgroundColor = .backgroundSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var privacyPolitcyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        label.font = .bodyRegular13
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var privacyPolitcyLinkLabel: UILabel = {
        let label = UILabel()
        label.text = "Пользовательского соглашения"
        label.font = .bodyRegular13
        label.textColor = .semanticBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var proceedPaymentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackAdaptive
        button.layer.cornerRadius = 16
        button.setTitle("Оплатить", for: .normal)
        button.titleLabel?.font = .titleMedium
        button.setTitleColor(.whiteAdaptive, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = PaymentPresenter(view: self)
        
        view.backgroundColor = .backgroundPrimary
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = false
        
        setupViews()
        setupConstraints()
        setupTargets()
    }
    
    // MARK: - Setup UI Methods
    
    private func setupViews() {
        view.addSubview(backButton)
        view.addSubview(headerLabel)
        view.addSubview(collectionView)
        view.addSubview(bottomView)
        bottomView.addSubview(privacyPolitcyTitleLabel)
        bottomView.addSubview(privacyPolitcyLinkLabel)
        bottomView.addSubview(proceedPaymentButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 11),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            
            collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 26.5),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 186),
            
            privacyPolitcyTitleLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            privacyPolitcyTitleLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            
            privacyPolitcyLinkLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 34),
            privacyPolitcyLinkLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            
            proceedPaymentButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 76),
            proceedPaymentButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            proceedPaymentButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            proceedPaymentButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupTargets() {
        backButton.addTarget(self, action: #selector(backToCart), for: .touchUpInside)
        proceedPaymentButton.addTarget(self, action: #selector(proceedPaymentButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func backToCart() {
        dismiss(animated: true)
    }
    
    @objc
    private func proceedPaymentButtonTapped() {
        presenter?.proceedPayment()
    }
}

extension PaymentViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentCollectionViewCell.reuseIdentifier, for: indexPath) as? PaymentCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let currency = presenter?.model(at: indexPath) else { return cell }
        cell.configureCell(with: currency)
        
        let isSelected = currency.id == presenter?.selected?.id
        cell.setSelectedState(isSelected)
        
        return cell
    }
}

extension PaymentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.select(at: indexPath)
    }
}

extension PaymentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.width / 2) - 16
        return CGSize(width: size, height: 53)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
}

extension PaymentViewController: PaymentView {
    
    func showLoading() {
        ProgressHUD.show()
    }
    
    func hideLoading() {
        ProgressHUD.dismiss()
    }
    
    func showSuccess() {
        let vc = SuccessfullPaymentViewController()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    func showPaymentError() {
        let alert = UIAlertController(title: "Не удалось произвести оплату", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Отмена", style: .default))

        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { [weak self] _ in
            self?.showSuccess()
        }))

        present(alert, animated: true)
    }
    
    func reload() {
        collectionView.reloadData()
    }
    
    func reloadItems(oldIndex: Int?, newIndex: Int) {
        var indexPaths = [IndexPath(item: newIndex, section: 0)]
        if let oldIndex {
            indexPaths.append(IndexPath(item: oldIndex, section: 0))
        }
        collectionView.reloadItems(at: indexPaths)
    }
}
