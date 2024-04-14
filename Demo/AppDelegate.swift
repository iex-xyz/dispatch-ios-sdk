import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        // Create a view controller and embed it in a navigation controller
        let mainViewController = UIViewController(nibName: nil, bundle: nil)
        mainViewController.view.backgroundColor = .red
        navigationController = UINavigationController(rootViewController: mainViewController)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
