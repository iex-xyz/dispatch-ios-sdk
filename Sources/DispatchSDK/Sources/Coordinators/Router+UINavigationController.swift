import UIKit
import SwiftUI

@available(iOS 15.0, *)
final class RouterImp: NSObject, Router {
    private var rootController: UINavigationController?
    private var checkoutController: UINavigationController?
    private var completions: [UIViewController : () -> Void]
    
    init(rootController: UINavigationController, checkoutController: UINavigationController) {
        self.rootController = rootController
        self.checkoutController = checkoutController
        self.completions = [:]
        super.init()
        self.rootController?.delegate = self
        
//        self.rootController?.navigationBar.isTranslucent = false
//        self.checkoutController?.navigationBar.isTranslucent = false
    }
    
    var isAtRoot: Bool {
        guard let rootController else {
            return false
        }
        
        return rootController.viewControllers.count <= 1
    }
    
    func toPresent() -> UIViewController? {
        return rootController
    }
    
    func presentCheckout(_ root: Presentable, completion: (() -> Void)?) {
        guard let checkoutController, let rootViewController = root.toPresent() else {
            return
        }
        
        checkoutController.setViewControllers([rootViewController], animated: false)
        checkoutController.modalPresentationStyle = .overFullScreen
        
        rootController?
            .present(
                checkoutController,
                animated: true,
                completion: completion
            )
    }
    
    func dismissCheckout(completion: (() -> Void)?) {
        checkoutController?.dismiss(animated: true, completion: completion)
    }
    
    func presentSelf(completion: (() -> Void)?) {
        guard let rootController else {
            return
        }
        
        if let sheet = rootController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.preferredCornerRadius = 16
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            rootController.isModalInPresentation = true
        }

        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController?
            .present(
                rootController,
                animated: true,
                completion: completion
            )
    }
    
    func dismissSelf(completion: (() -> Void)?) {
        rootController?.dismiss(animated: true, completion: completion)
    }
    
    func present(
        _ module: Presentable?,
        animated: Bool,
        completion: (() -> Void)?
    ) {
        guard let controller = module?.toPresent() else { return }
        controller.presentationController?.delegate = self
        
        if let completion = completion {
            completions[controller] = completion
        }

        rootController?.present(controller, animated: animated, completion: nil)
    }
    
    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        rootController?.dismiss(animated: animated, completion: completion)
    }
    
    func push(_ module: Presentable?)  {
        push(module, animated: true)
    }
    
    func push(_ module: Presentable?, hideBottomBar: Bool)  {
        push(module, animated: true, hideBottomBar: hideBottomBar, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool)  {
        push(module, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        push(module, animated: animated, hideBottomBar: false, completion: completion)
    }
    
    func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?) {
        guard
            let controller = module?.toPresent(),
            (controller is UINavigationController == false)
        else { assertionFailure("Deprecated push UINavigationController."); return }
        
        if let completion = completion {
            completions[controller] = completion
        }
        controller.hidesBottomBarWhenPushed = hideBottomBar
        checkoutController?.pushViewController(controller, animated: animated)
    }
    
    func popModule()  {
        popModule(animated: true)
    }
    
    func popModule(animated: Bool)  {
        if let controller = checkoutController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func setRootModule(_ module: Presentable?, animated: Bool) {
        setRootModule(module, hideBar: false, animated: animated)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        rootController?.setViewControllers([controller], animated: animated)
        rootController?.isNavigationBarHidden = hideBar
    }
    
    func popToRootModule(animated: Bool) {
        if let controllers = checkoutController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }
    
    func setCheckoutRootModule(_ module: Presentable?, animated: Bool) {
        setCheckoutRootModule(module, hideBar: false, animated: animated)
    }
    
    func setCheckoutRootModule(_ module: Presentable?, hideBar: Bool, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        checkoutController?.setViewControllers([controller], animated: animated)
        checkoutController?.isNavigationBarHidden = hideBar
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}

@available(iOS 15.0, *)
extension RouterImp: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        runCompletion(for: presentationController.presentedViewController)
    }
}

@available(iOS 15.0, *)
extension RouterImp: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(poppedViewController) else {
             return
        }

        runCompletion(for: poppedViewController)
    }
}
