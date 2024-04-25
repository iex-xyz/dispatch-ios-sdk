import UIKit
import SwiftUI
import Combine

class CheckoutCoordinator: BaseCoordinator {
    let router: Router
    let apiClient: GraphQLClient
    var shouldDismissFlow: (() -> Void)?
    let viewModel = CheckoutViewModel()

    private var cancellables: Set<AnyCancellable> = .init()
    
    init(
        router: Router,
        apiClient: GraphQLClient,
        shouldDismiss: (() -> Void)? = nil
    ) {
        self.router = router
        self.apiClient = apiClient
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
        
        viewModel
            ._onMorePaymentMethodsButtonTapped
            .sink { [weak self] checkout in
                self?.showPaymentOptionsPicker(for: checkout)
        }
        .store(in: &cancellables)
        
        viewModel
            ._onLockButtonTapped
            .sink { [weak self] checkout in
                self?.showSecureCheckout(for: checkout)
        }
        .store(in: &cancellables)
        viewModel
            ._onPaymentCTATapped
            .sink { [weak self] (checkout, paymentType) in
                switch paymentType {
                case .creditCard:
                    self?.showPayWithCreditCard(for: checkout)
                case .applePay:
                    self?.showPayWithCreditCard(for: checkout)
                default:
                    print("[WARNING] Invalid payment type handler")
                    return
                }
        }
        .store(in: &cancellables)

        let viewController = UIHostingController<CheckoutView>.init(
            rootView: .init(viewModel: viewModel)
        )

        router.setRootModule(viewController)
        router.presentSelf(completion: nil)
    }
    
    private func showVariantPicker(for viewModel: AttributeViewModel) {
        let viewController = UIHostingController<VariantPickerView>(rootView: VariantPickerView(viewModel: viewModel, columns: .double))
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 16
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
    
    private func showPaymentOptionsPicker(for checkout: Checkout) {
        let viewController = UIHostingController(
            rootView: PaymentOptionsPickerView(onPaymentMethodSelected: { [weak self] paymentType in
                self?.viewModel.selectedPaymentMethod = paymentType
            })
        )
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 16
        }
        router.present(viewController, animated: true, completion: {
            print("Sheet Dismissed")
        })
    }
    
    private func showSecureCheckout(for checkout: Checkout) {
        let viewController = UIHostingController(
            rootView: SecureCheckoutOverview(checkout: checkout)
        )
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 16
        }
        router.present(viewController, animated: true, completion: {
            print("Sheet Dismissed")
        })

    }
    
    private func showPayWithApplePay(for checkout: Checkout) {
        let viewModel = ApplePayViewModel(order: .mock(), merchantId: checkout.merchantId)
        let coordinator = ApplePayCoordinator(
            router: router,
            apiClient: apiClient,
            orderId: "invalid",
            viewModel: viewModel,
            didCancel: {
                // TODO:
            }
        )
        
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func showPayWithCreditCard(for checkout: Checkout) {
        let viewModel: InitiateCreditCardCheckoutViewModel = InitiateCreditCardCheckoutViewModel(
            checkout: checkout,
            variantId: viewModel.selectedVariant?.id,
            apiClient: apiClient
        )
        let coordinator = CreditCardCoordinator(
            router: router,
            apiClient: apiClient,
            orderId: "invalid",
            viewModel: viewModel
        ) {
            // TODO:
        }
        
        addDependency(coordinator)
        coordinator.start()
    }
}
