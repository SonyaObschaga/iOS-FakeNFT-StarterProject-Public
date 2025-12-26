import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    let servicesAssembly = ServicesAssembly(
        networkClient: DefaultNetworkClient(),
        nftStorage: NftStorageImpl()
    )
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let splashViewController = SplashViewController()
        
        splashViewController.onFinish = { [weak self] in
            
            self?.showMainScreen()
        }
        
        window?.rootViewController = splashViewController
        window?.makeKeyAndVisible()
    }
    
    private func showMainScreen() {
        guard let window = window else { return }
        
        let tabBarController = TabBarController()
        tabBarController.servicesAssembly = servicesAssembly
        
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: {
                window.rootViewController = tabBarController
            },
            completion: nil
        )
    }
}
