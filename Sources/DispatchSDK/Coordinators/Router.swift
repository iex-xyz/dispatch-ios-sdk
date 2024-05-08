import UIKit

protocol Presentable {
  func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
  
  func toPresent() -> UIViewController? {
    return self
  }
}

protocol Router: Presentable {
    var isAtRoot: Bool { get }

    func presentCheckout(_ root: Presentable, completion: (() -> Void)?)
    func dismissCheckout(completion: (() -> Void)?)

    func presentSelf(completion: (() -> Void)?)
    func dismissSelf(completion: (() -> Void)?)

    func present(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)

    func push(_ module: Presentable?)
    func push(_ module: Presentable?, hideBottomBar: Bool)
    func push(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)
    func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?)
    
    func popModule()
    func popModule(animated: Bool)
    
    func dismissModule()
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    
    func setRootModule(_ module: Presentable?, animated: Bool)
    func setRootModule(_ module: Presentable?, hideBar: Bool, animated: Bool)
    func setCheckoutRootModule(_ module: Presentable?, animated: Bool)
    func setCheckoutRootModule(_ module: Presentable?, hideBar: Bool, animated: Bool)
    
    func popToRootModule(animated: Bool)
}
