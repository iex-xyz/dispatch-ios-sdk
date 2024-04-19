import UIKit
import SwiftUI
import Combine

class CheckoutCoordinator: BaseCoordinator {
    let router: Router
    var shouldDismissFlow: (() -> Void)?
    let viewModel = CheckoutViewModel()

    private var cancellables: Set<AnyCancellable> = .init()
    
    init(router: Router, shouldDismiss: (() -> Void)? = nil) {
        self.router = router
        self.shouldDismissFlow = shouldDismiss
    }
    
    override func start() {

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

        let viewController = UIHostingController<CheckoutView>.init(rootView: .init(viewModel: viewModel))
        router.setRootModule(viewController)
        router.presentSelf(completion: nil)
    }
    
    func showVariantPicker(for viewModel: AttributeViewModel) {
        let viewController = UIHostingController<VariantPickerView>(rootView: VariantPickerView(viewModel: viewModel, columns: .double))
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        // FIXME: Why doesn't this work
//        viewModel
//            .selectedVariant
//            .publisher
//            .compactMap { $0 }
//            .assign(to: &self.viewModel.$selectedVariant)

        router.present(viewController, animated: true, completion: { [weak self] in
            self?.viewModel.selectedVariant = viewModel.selectedVariant
        })

    }
    
    func showSecureCheckout(for checkout: Checkout) {
        let viewController = UIHostingController(
            rootView: SecureCheckoutOverview()
        )
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        router.present(viewController, animated: true, completion: {
            print("Sheet Dismissed")
        })

    }
}
