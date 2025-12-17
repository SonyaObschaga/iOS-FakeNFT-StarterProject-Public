import UIKit

protocol DeleteConfirmationDelegate: AnyObject {
    func didConfirmDelete()
}

final class DeleteConfirmationViewController: UIViewController {
    
    weak var delegate: DeleteConfirmationDelegate?
    
    private let nftImage: UIImage?
    
    private lazy var confirmDeleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить", for: .normal)
        button.backgroundColor = .blackAdaptive
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .bodyRegular17
        button.setTitleColor(.semanticRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вернуться", for: .normal)
        button.backgroundColor = .blackAdaptive
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .bodyRegular17
        button.setTitleColor(.whiteAdaptive, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Вы уверены, что хотите\nудалить объект из корзины?"
        label.textColor = .blackAdaptive
        label.font = .bodyRegular13
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var blurBackground: UIVisualEffectView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        blur.translatesAutoresizingMaskIntoConstraints = false
        return blur
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(image: UIImage?) {
        self.nftImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        imageView.image = nftImage
        
        setupViews()
        setupConstraints()
        setupTargets()
    }
    
    private func setupViews() {
        view.addSubview(blurBackground)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(confirmDeleteButton)
        buttonsStackView.addArrangedSubview(cancelButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            blurBackground.topAnchor.constraint(equalTo: view.topAnchor),
            blurBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 108),
            imageView.heightAnchor.constraint(equalToConstant: 108),
            imageView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -54),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsStackView.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 14),
            buttonsStackView.widthAnchor.constraint(equalToConstant: 262),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupTargets() {
        confirmDeleteButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }
    
    @objc private func confirmTapped() {
        delegate?.didConfirmDelete()
        dismiss(animated: true)
    }
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
}
