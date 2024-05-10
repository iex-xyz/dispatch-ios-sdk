import UIKit
import SwiftUI
import Combine

class CheckoutCoordinator: BaseCoordinator {
    private let router: Router
    private let apiClient: GraphQLClient
    private let analyticsClient: AnalyticsClient
    private let checkoutId: String
    private let config: DispatchConfig

    var shouldDismissFlow: (() -> Void)?

    lazy private(set) var viewModel: CheckoutViewModel = .init(id: checkoutId, apiClient: apiClient, analyticsClient: analyticsClient)
    
    private lazy var rightBarButtonController: UIHostingController<CloseButton> = {
        let controller = UIHostingController<CloseButton>(rootView: CloseButton { [weak self] in
            self?.analyticsClient.send(event: .checkoutDismissed_Checkout)
            self?.shouldDismissFlow?()
        })
        
        controller.view.backgroundColor = .clear
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()

    private lazy var navigationTitleController: UIHostingController<CheckoutNavigationTitle> = {
        let controller = UIHostingController<CheckoutNavigationTitle>(rootView: CheckoutNavigationTitle(viewModel: viewModel, tapHandler: { [weak self] checkout in
            self?.showSecureCheckout(for: checkout)
        }))
        controller.view.backgroundColor = .clear
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()

    private lazy var leftBarButtonController: UIHostingController<CheckoutLogoImageView> = {
        let controller = UIHostingController<CheckoutLogoImageView>(rootView: CheckoutLogoImageView(viewModel: viewModel))
        
        controller.view.backgroundColor = .clear
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()

    private var cancellables: Set<AnyCancellable> = .init()
    
    init(
        router: Router,
        apiClient: GraphQLClient,
        analyticsClient: AnalyticsClient,
        checkoutId: String,
        config: DispatchConfig,
        shouldDismiss: (() -> Void)? = nil
    ) {
        self.router = router
        self.apiClient = apiClient
        self.analyticsClient = analyticsClient
        self.checkoutId = checkoutId
        self.config = config
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
            ._onCloseButtonTapped
            .sink { [weak self] in
                self?.analyticsClient.send(event: .checkoutDismissed_Checkout)
                self?.router.dismissSelf(completion: { [weak self] in
                    self?.router.popToRootModule(animated: false)
                })
            }
            .store(in: &cancellables)
        
        viewModel
            ._onAttributeTapped
            .sink { [weak self] (attribute, variations, selectedVariant, quantity) in
                self?.showVariantPicker(
                    for: attribute,
                    variations: variations,
                    selectedVariation: selectedVariant,
                    quantity: quantity
                )
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
                self?.analyticsClient.send(event: .trustModalOpened_Checkout)
                self?.showSecureCheckout(for: checkout)
        }
        .store(in: &cancellables)
        
        viewModel
            ._onMoreProductInfoButtonTapped
            .sink { [weak self] checkout in
                self?.analyticsClient.send(event: .productDetailsOpened_Checkout)
                self?.showProductOverview(for: checkout)
        }
        .store(in: &cancellables)
        
        viewModel
            ._onPaymentCTATapped
            .sink { [weak self] (checkout, paymentType) in
                self?.analyticsClient.send(event: .checkoutRequested_Checkout)
                switch paymentType {
                case .creditCard:
                    self?.showPayWithCreditCard(for: checkout)
                case .applePay:
                    self?.showPayWithApplePay(for: checkout)
                default:
                    print("[WARNING] Invalid payment type handler")
                    return
                }
        }
        .store(in: &cancellables)

        let viewController = UIHostingController<CheckoutView>.init(
            rootView: .init(viewModel: viewModel)
        )
        
        if !config.hideRootCloseButton {
            viewController.navigationItem.rightBarButtonItem = .init(customView: rightBarButtonController.view)
        }
        viewController.navigationItem.leftBarButtonItem = .init(customView: leftBarButtonController.view)
        viewController.navigationItem.titleView = navigationTitleController.view

        viewModel
            .$checkout
            .sink { [weak self] checkout in
                viewController.navigationItem.titleView = nil
                viewController.navigationItem.titleView = self?.navigationTitleController.view
            }
            .store(in: &cancellables)

        viewController.navigationItem.setHidesBackButton(true, animated: false)
        let emptyView = UIView(frame: .zero)
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(customView: emptyView)

        router.setRootModule(viewController, animated: false)
        router.presentSelf(completion: nil)
        analyticsClient.send(event: .view_Leadgen)
    }
    
    override func start(with route: DispatchRoute) {
        print("[WARNING] Invalid deep link coordinator. Cannot handle deep link route")
        start()
    }
    
    private func showVariantPicker(for attribute: Attribute, variations: [Variation], selectedVariation: Variation, quantity: Int) {
        let viewModel = VariantPickerViewModel(
            attribute: attribute,
            variations: variations,
            selectedVariation: selectedVariation,
            analyticsClient: analyticsClient,
            quantity: quantity
        )
        let viewController = UIHostingController<VariantPickerView>(
            rootView: VariantPickerView(
                viewModel: viewModel,
                columns: variations.count > 4 ? .double : .single
            )
        )
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 16
        }
        
        viewModel
            .$selectedVariation
            .sink(receiveValue: { [weak self] variation in
                self?.viewModel.selectedVariation = variation
            })
            .store(in: &cancellables)

        router.present(viewController, animated: true, completion: { [weak self] in
            self?.viewModel.selectedVariation = viewModel.selectedVariation
        })
    }
    
    private func showPaymentOptionsPicker(for checkout: Checkout) {
        let viewController = UIHostingController(
            rootView: PaymentOptionsPickerView(paymentMethods: viewModel.enabledPaymentMethods,
                                               onPaymentMethodSelected: { [weak self] paymentMethod in
                self?.viewModel.selectedPaymentMethod = paymentMethod
                self?.analyticsClient.send(event: .paymentMethodSelected_Checkout(paymentMethod: paymentMethod.rawValue))
            })
        )
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 16
        }
        router.present(viewController, animated: true, completion: {
            //
        })
    }
    
    private func showSecureCheckout(for checkout: Checkout) {
        let viewController = UIHostingController(
            rootView: SecureCheckoutOverview(checkout: checkout)
        )
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 16
            sheet.prefersGrabberVisible = true
        }
        viewController.navigationItem.leftBarButtonItem = .init(customView: leftBarButtonController.view)
        router.present(viewController, animated: true, completion: { [weak self] in
            self?.analyticsClient.send(event: .trustModalDismissed_Checkout)
        })
        
        analyticsClient.send(event: .trustModalOpened_Checkout)
    }
    
    func showProductOverview(for checkout: Checkout) {
        let viewModel = ProductOverviewViewModel(product: checkout.product)
        
        viewModel
            ._onCloseButtonTapped
            .sink { [weak self] _ in
                self?.router.dismissModule()
            }
            .store(in: &cancellables)
        
        let viewController = UIHostingController<ProductOverview>(
            rootView: ProductOverview(viewModel: viewModel)
        )
        
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.preferredCornerRadius = 16
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
        }
        
        router.present(viewController, animated: true) {
            //
        }
    }
    
    private func showPayWithApplePay(for checkout: Checkout) {
        let viewModel = ApplePayViewModel(
            content: checkout,
            quantity: viewModel.currentQuantity,
            selectedVariant: viewModel.selectedVariation,
            apiClient: apiClient,
            analyticsClient: analyticsClient
        )
        let coordinator = ApplePayCoordinator(
            router: router,
            apiClient: apiClient,
            analyticsClient: analyticsClient,
            viewModel: viewModel,
            config: config,
            didCancel: { },
            didComplete: { [weak self] order, address, billingInfo in
                self?.navigateToOrderCompleteCoordinator(
                    order: order,
                    checkout: checkout,
                    shippingAddress: address,
                    billingInfo: billingInfo
                )
            }
        )
        
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func showPayWithCreditCard(for checkout: Checkout) {
        let viewModel: InitiateCreditCardCheckoutViewModel = InitiateCreditCardCheckoutViewModel(
            checkout: checkout,
            variant: viewModel.selectedVariation,
            quantity: viewModel.currentQuantity,
            apiClient: apiClient
        )
        let coordinator = CreditCardCoordinator(
            router: router,
            apiClient: apiClient,
            analyticsClient: analyticsClient,
            viewModel: viewModel,
            paymentMethods: self.viewModel.enabledPaymentMethods,
            config: config,
            didCancel: {
                
            },
            didComplete: { [weak self] order, address, billingInfo in
                self?.navigateToOrderCompleteCoordinator(
                    order: order,
                    checkout: checkout,
                    shippingAddress: address,
                    billingInfo: billingInfo
                )
            }
        )
        addDependency(coordinator)
        coordinator.start()
    }
    
    
    private func navigateToOrderCompleteCoordinator(
        order: InitiateOrder,
        checkout: Checkout,
        shippingAddress: Address?,
        billingInfo: BillingInfo?
    ) {
        let viewModel = CheckoutSuccessViewModel(
            checkout: checkout,
            orderNumber: order.id,
            shippingAddress: shippingAddress,
            billingInfo: billingInfo,
            continueCTA: config.orderCompletionCTA, 
            hideOrderCompletionCTA: config.hideOrderCompletionCTA
        )
        let coordinator = CheckoutSuccessCoordinator(
            router: router,
            apiClient: apiClient,
            analyticsClient: analyticsClient,
            viewModel: viewModel
        )
        
        addDependency(coordinator)
        coordinator.start()
    }
}
