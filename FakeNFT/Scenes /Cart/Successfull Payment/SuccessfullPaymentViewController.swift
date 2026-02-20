import UIKit

final class SuccessfullPaymentViewController: UIViewController {
    
    //MARK: - Public Properties
    
    var onClose: (() -> Void)?
    
    // MARK: - UI Properties
    
    private lazy var succesfulPaymentImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .successPayment))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Payment.success", comment: "")
        label.font = .titleLarge
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backToCartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blackAdaptive
        button.layer.cornerRadius = 16
        button.setTitle(NSLocalizedString("Payment.backToCart", comment: ""), for: .normal)
        button.titleLabel?.font = .titleMedium
        button.setTitleColor(.whiteAdaptive, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundPrimary
        
        setupViews()
        setupConstraints()
        setupTargets()
    }
    
    // MARK: - Setup UI Methods
    
    private func setupViews() {
        view.addSubview(succesfulPaymentImage)
        view.addSubview(titleLabel)
        view.addSubview(backToCartButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            succesfulPaymentImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 152),
            succesfulPaymentImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            succesfulPaymentImage.widthAnchor.constraint(equalToConstant: 278),
            succesfulPaymentImage.heightAnchor.constraint(equalToConstant: 278),
            
            titleLabel.topAnchor.constraint(equalTo: succesfulPaymentImage.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            
            backToCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            backToCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backToCartButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupTargets() {
        backToCartButton.addTarget(self, action: #selector(backToCart), for: .touchUpInside)
    }
    
    @objc
    private func backToCart() {
        dismiss(animated: true) {
            self.onClose?()
        }
    }
}
