import UIKit
import WebKit

// MARK: - WebViewController
final class WebViewController: UIViewController {
    
    // MARK: - Properties
    private let url: URL
    
    // MARK: - UI Elements
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .systemBlue
        return progressView
    }()
    
    // MARK: - Initialization
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadURL()
        setupProgressObserver()
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(progressView)
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2),
            
            webView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "backward"),
            style: .plain,
            target: self,
            action: #selector(backwardButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .ypBlackLight
    }
    
    private func loadURL() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func setupProgressObserver() {
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    // MARK: - Actions
    @objc private func backwardButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - KVO
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            progressView.isHidden = webView.estimatedProgress >= 1.0
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
    }
}
