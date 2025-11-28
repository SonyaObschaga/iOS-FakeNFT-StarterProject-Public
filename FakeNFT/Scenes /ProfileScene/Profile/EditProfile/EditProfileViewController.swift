//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 23/11/25.
//

import UIKit

final class EditProfileViewController: UIViewController {
    let profile = FakeNFTService.shared.profile
 
    //MARK: - Layout variables
    private lazy var closeButton: UIButton = {
        let imageButton = UIImage(named: "close")?.withRenderingMode(.alwaysOriginal)
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        return button
    }()
    private lazy var editPhotoButton: UIButton = {
        let imageButton = UIImage(named: "Image1")?.alpha(0.6)
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setBackgroundImage(imageButton, for: .normal)
        button.setTitle("Сменить \n фото", for: .normal)
        button.setTitleColor(.ypWhiteUniversal, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.frame.size.width = 70
        button.frame.size.height = 70
        button.layer.cornerRadius = 35
        button.layer.masksToBounds = false
        button.addTarget(self, action: #selector(changeAvatar), for: .touchUpInside)
        button.backgroundColor = .black
        
        return button
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .ypBlackDay
        label.text = "Имя"
        
        return label
    }()
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.setLeftPaddingPoints(16)
        textField.setRightPaddingPoints(16)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.returnKeyType = UIReturnKeyType.done
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .ypLightGreyDay
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        
        textField.text = profile.name
        
        return textField
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .ypBlackDay
        label.text = "Описание"
        
        return label
    }()
    private lazy var descriptionTextField: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.autocorrectionType = UITextAutocorrectionType.no
        textView.returnKeyType = UIReturnKeyType.done
        textView.layer.cornerRadius = 12
        textView.backgroundColor = .ypLightGreyDay
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        
        textView.text = profile.description
        
        return textView
    }()
    private lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .ypBlackDay
        label.text = "Сайт"
        
        return label
    }()
    private lazy var urlTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.setLeftPaddingPoints(16)
        textField.setRightPaddingPoints(16)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.returnKeyType = UIReturnKeyType.done
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .ypLightGreyDay
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        
        textField.text = profile.website
        
        return textField
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}

//MARK: - Private functions
private extension EditProfileViewController {
    func setupView() {
        view.backgroundColor = .ypWhiteDay
        
        addSubViews()
        configureConstraints()
        addTapGestureToHideKeyboard()
    }
    
    func addSubViews() {
        view.addSubview(closeButton)
        view.addSubview(editPhotoButton)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextField)
        view.addSubview(urlLabel)
        view.addSubview(urlTextField)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            editPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editPhotoButton.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 22),
            editPhotoButton.heightAnchor.constraint(equalToConstant: 70),
            editPhotoButton.widthAnchor.constraint(equalToConstant: 70),
            
            nameLabel.topAnchor.constraint(equalTo: editPhotoButton.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.widthAnchor.constraint(equalToConstant: 50),
            nameLabel.heightAnchor.constraint(equalToConstant: 28),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 117),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 28),
            
            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 132),

            urlLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 24),
            urlLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            urlLabel.widthAnchor.constraint(equalToConstant: 57),
            urlLabel.heightAnchor.constraint(equalToConstant: 28),

            urlTextField.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 8),
            urlTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            urlTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            urlTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc
    func close() {
        dismiss(animated: true)
    }
    
    @objc
    func changeAvatar() {
        
    }
}

private extension EditProfileViewController {
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func tapGesture() {
        descriptionTextField.resignFirstResponder()
    }
}
