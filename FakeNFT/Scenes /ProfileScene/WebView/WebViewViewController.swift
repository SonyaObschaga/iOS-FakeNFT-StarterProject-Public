//
//  WebViewViewController.swift
//  FakeNFT
//
//  Created by Damir Salakhetdinov on 23/11/25.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    //MARK: - Layout variables
    private lazy var backButton: UIButton = {
        let imageButton = UIImage(resource: .backChevron)
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(imageButton, for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        return button
    }()
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
    
    //MARK: - Lyfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: "https://practicum.yandex.ru/") {
            webView.load(URLRequest(url: url))
        }
        
        setupView()
    }
}

//MARK: - Privtae functions
extension WebViewViewController {
    func setupView() {
        view.backgroundColor = .ypWhiteDay
        
        addSubViews()
        configureConstraints()
    }
    
    func addSubViews() {
        view.addSubview(backButton)
        view.addSubview(webView)
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 9),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc
    func back() {
        navigationController?.popToRootViewController(animated: true)
    }
}
