//
//  SplashViewController.swift
//  FakeNFT
//
//  Created by Илья on 07.12.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // ✅ Можно использовать логотип из Assets или системную иконку
        imageView.image = UIImage(systemName: "photo.artframe") // Заменить на свой логотип
        imageView.tintColor = .label
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var onFinish: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startAnimation()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(logoImageView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(
                equalTo: logoImageView.bottomAnchor,
                constant: 32
            )
        ])
    }
    
    private func startAnimation() {
        activityIndicator.startAnimating()
        
        // ✅ Анимация появления логотипа
        logoImageView.alpha = 0
        logoImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(
            withDuration: 0.6,
            delay: 0.1,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.8,
            options: .curveEaseOut
        ) {
            self.logoImageView.alpha = 1
            self.logoImageView.transform = .identity
        }
        
        // ✅ Показывать splash минимум 2 секунды, затем переходить
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.finishSplash()
        }
    }
    
    private func finishSplash() {
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.view.alpha = 0
            },
            completion: { _ in
                self.onFinish?()
            }
        )
    }
}
