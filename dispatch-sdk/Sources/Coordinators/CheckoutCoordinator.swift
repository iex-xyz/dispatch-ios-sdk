import UIKit
import SwiftUI
import Combine

class CheckoutCoordinator: BaseCoordinator {
    let router: Router
    var shouldDismissFlow: (() -> Void)?
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(router: Router, shouldDismiss: (() -> Void)? = nil) {
        self.router = router
        self.shouldDismissFlow = shouldDismiss
    }
    
    override func start() {
        let viewModel = CheckoutViewModel()

        viewModel
            ._onSecureCheckoutButtonTapped
            .sink { [weak self] checkout in
                self?.showSecureCheckout(for: checkout)
        }
        .store(in: &cancellables)
        
        viewModel
            ._onAttributeTapped
            .sink { [weak self] viewModel in
                self?.showVariantPicker(for: viewModel)
        }
        .store(in: &cancellables)

        let viewController = CheckoutViewController(viewModel: viewModel)
        router.setRootModule(viewController)
        router.presentSelf(completion: nil)
    }
    
    func showVariantPicker(for viewModel: AttributeViewModel) {
        let viewController = VariantPickerViewController(viewModel: viewModel)
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }

        router.present(viewController, animated: true, completion: {
            print("Sheet Dismissed")
        })

    }
    
    func showSecureCheckout(for checkout: Checkout) {
        let viewController = UIHostingController(
            rootView: SecureCheckoutOverview(
                theme: checkout.theme
            )
        )
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        router.present(viewController, animated: true, completion: {
            print("Sheet Dismissed")
        })

    }
}
