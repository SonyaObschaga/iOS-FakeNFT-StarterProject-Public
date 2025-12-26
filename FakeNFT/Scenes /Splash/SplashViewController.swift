//
//  SplashViewController.swift
//  FakeNFT
//
//  Created by Илья on 30.11.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.isHidden = true
        return indicator
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .splash)
        imageView.tintColor = .label
        return imageView
    }()
    
    var onFinish: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startAnimation()
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundPrimary
        
        view.addSubview(logoImageView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 75),
            logoImageView.heightAnchor.constraint(equalToConstant: 77.68),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(
                equalTo: logoImageView.bottomAnchor,
                constant: 32
            )
        ])
    }
    
    private func startAnimation() {
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

extension SplashViewController: LoadingView {

}
