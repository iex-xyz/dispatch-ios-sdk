import UIKit
import dispatch_sdk

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let mainViewController = UIViewController(nibName: nil, bundle: nil)
    private lazy var navigationController = UINavigationController(rootViewController: mainViewController)

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        mainViewController.view.backgroundColor = .blue
        
        window.rootViewController = navigationController
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        mainViewController.view.addGestureRecognizer(tap)
        self.window = window
        window.makeKeyAndVisible()
    }
    
    @objc private func handleTap() {
        DispatchSDK.shared.present()
    }
}
