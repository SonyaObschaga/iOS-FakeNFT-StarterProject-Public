//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 23/11/25.
//

import UIKit

final class EditProfileViewController: UIViewController {
    //let profile = FakeNFTService.shared.profile
    private var presenter: ProfilePresenterProtocol!
    func configure (_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    private var newUrl: String = ""
 
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.viewDidLoad()
        //+
        nameTextField.addTarget(self, action: #selector(changed), for: .editingChanged)
        urlTextField.addTarget(self, action: #selector(changed), for: .editingChanged)
        descriptionTextField.delegate = self
        //-
    }

    //MARK: - Layout variables
    //+
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .ypBlackDay
        button.tintColor = .ypWhiteUniversal
        button.layer.cornerRadius = 16
        button.isHidden = true
        button.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        return button
    }()
    //-
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false

        let imageButton = UIImage(resource: .backChevron).withRenderingMode(.alwaysOriginal)
        button.setImage(imageButton, for: .normal)

        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        return button
    }()
    lazy var editPhotoButton: UIButton = {
        let imageButton = UIImage(resource: .joaquin).alpha(0.6)
 
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
    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .ypBlackDay
        label.text = "Имя"
        
        return label
    }()
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.setLeftPaddingPoints(16)
        textField.setRightPaddingPoints(16)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.returnKeyType = UIReturnKeyType.done
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .ypLightGreyDay
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        
        //textField.text = profile.name
        
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
    lazy var descriptionTextField: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.autocorrectionType = UITextAutocorrectionType.no
        textView.returnKeyType = UIReturnKeyType.done
        textView.layer.cornerRadius = 12
        textView.backgroundColor = .ypLightGreyDay
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        
        //textView.text = profile.description
        
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
    lazy var urlTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.setLeftPaddingPoints(16)
        textField.setRightPaddingPoints(16)
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.returnKeyType = UIReturnKeyType.done
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .ypLightGreyDay
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        
        //textField.text = profile.website
        
        return textField
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

//MARK: - Private functions
private extension EditProfileViewController {
    func setupView() {
        view.backgroundColor = .ypWhiteDay
        
        addSubViews()
        configureConstraints()
        addTapGestureToHideKeyboard()
    }
    
    func addSubViews() {
        //+
        view.addSubview(saveButton)
        //-
        view.addSubview(closeButton)
        view.addSubview(editPhotoButton)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextField)
        view.addSubview(urlLabel)
        view.addSubview(urlTextField)
        view.addSubview(activityIndicator)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            //+
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            //-
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            
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
    //+
    func showChangePhotoAlert() {
        let alert = UIAlertController(title: "Ссылка на фото", message: nil, preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "http://example.com/avatar.png"
            textField.keyboardType = .URL
            textField.text = "https://hips.hearstapps.com/hmg-prod/images/dog-puppy-on-garden-royalty-free-image-1586966191.jpg"
        }

        let cancel = UIAlertAction(title: "Отмена", style: .default)

        let save = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text,
                  let url = URL(string: text) else { return }

            self?.updateAvatarImage(from: url)
            self?.saveButton.isHidden = false
        }

        alert.addAction(cancel)
        alert.addAction(save)

        present(alert, animated: true)
    }
    
//    func updateAvatarImage(from url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url),
//               let image = UIImage(data: data) {
//                DispatchQueue.main.async {
//                    self?.editPhotoButton.setBackgroundImage(image, for: .normal)
//                    self?.editPhotoButton.setTitle("", for: .normal)
//                }
//            }
//        }
//    }
    
    func updateAvatarImage(from url: URL) {
        newUrl = url.absoluteString
        DispatchQueue.global().async { [weak self] in
            guard let self = self,
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }

            // Масштабируем изображение до 70x70
            let size = CGSize(width: 70, height: 70)
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            image.draw(in: CGRect(origin: .zero, size: size))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            DispatchQueue.main.async {
                self.editPhotoButton.setBackgroundImage(resizedImage, for: .normal)
                self.editPhotoButton.setTitle("", for: .normal)

                // Делаем кнопку круглой
                self.editPhotoButton.layer.cornerRadius = 35 // половина размера
                self.editPhotoButton.clipsToBounds = true
            }
        }
        
 
    }

    func removeAvatar() {
        let placeholder = UIImage(resource: .joaquin).alpha(0.6)
        editPhotoButton.setBackgroundImage(placeholder, for: .normal)
        editPhotoButton.setTitle("Сменить \n фото", for: .normal)
        saveButton.isHidden = false
    }
    
    @objc private func changed() {
        saveButton.isHidden = false
    }
    
    @objc
    func saveChanges() {
        //TODO: Update user profile data
        
        var profile = ProfileDto()
        if let name = nameTextField.text {
            profile.name = name
        }
        profile.description = descriptionTextField.text
        if let website = urlTextField.text {
            profile.website = website
        }
        if !newUrl.isEmpty {
            profile.avatar_url = newUrl
        }
        
        presenter.updateProfile(profile: profile)
        
        print("Profile info update started")
//        presenter.saveProfileChanges(
//            name: nameTextField.text,
//            description: descriptionTextField.text,
//            website: urlTextField.text
//        )
//        dismiss(animated: true)
    }

    //-

    @objc
    func close() {
        dismiss(animated: true)
    }
    
    @objc
    func changeAvatar() {
        //+
        let sheet = UIAlertController(
                title: "Фото профиля",
                message: nil,
                preferredStyle: .actionSheet
            )

            let edit = UIAlertAction(title: "Изменить фото", style: .default) { [weak self] _ in
                self?.showChangePhotoAlert()
            }

            let delete = UIAlertAction(title: "Удалить фото", style: .destructive) { [weak self] _ in
                self?.removeAvatar()
            }

            let cancel = UIAlertAction(title: "Отмена", style: .cancel)

            sheet.addAction(edit)
            sheet.addAction(delete)
            sheet.addAction(cancel)

            present(sheet, animated: true)
        //-
    }
}
//+
extension EditProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        saveButton.isHidden = false
    }
}
//-
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
