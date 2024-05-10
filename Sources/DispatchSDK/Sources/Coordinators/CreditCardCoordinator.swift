import UIKit
import SwiftUI
import Combine

struct RightNavigationButtons: View {
    let leftButtonHandler: () -> Void
    let rightButtonHandler: () -> Void

    var body: some View {
        HStack {
            Button(action: {
                
            }) {
                Image(systemName: "chevron.left")
            }
            Button(action: {
                
            }) {
                Image(systemName: "chevron.right")
            }
        }
    }
}

class CreditCardCoordinator: BaseCoordinator {
    private let router: Router
    private let apiClient: GraphQLClient
    private let analyticsClient: AnalyticsClient
    private var order: InitiateOrder?
    private let config: DispatchConfig
    private let paymentMethods: [PaymentMethods]
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let viewModel: InitiateCreditCardCheckoutViewModel
    private let didComplete: (InitiateOrder, Address?, BillingInfo?) -> Void
    private let didCancel: () -> Void
    
    private lazy var rightBarButtonController: UIHostingController<RightNavigationButtons> = {
        let controller = UIHostingController<RightNavigationButtons>(rootView: RightNavigationButtons(leftButtonHandler: {
            //
        }, rightButtonHandler: {
            //
        }))
        
        controller.view.backgroundColor = .clear
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    private lazy var navigationTitleController: UIHostingController<MerchantSecurityTag> = {
        let controller = UIHostingController<MerchantSecurityTag>(rootView: MerchantSecurityTag(domain: viewModel.checkout.product.pdpDomain ?? "", tapHandler: {}))
        controller.view.backgroundColor = .clear
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()

    private lazy var closeButtonController: UIHostingController<CloseButton> = {
        let controller = UIHostingController<CloseButton>(rootView: CloseButton { [weak self] in
            self?.router.dismissCheckout(completion: nil)
        })
        
        controller.view.backgroundColor = .clear
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    init(
        router: Router,
        apiClient: GraphQLClient,
        analyticsClient: AnalyticsClient,
        viewModel: InitiateCreditCardCheckoutViewModel,
        paymentMethods: [PaymentMethods],
        config: DispatchConfig,
        didCancel: @escaping () -> Void,
        didComplete: @escaping (InitiateOrder, Address?, BillingInfo?) -> Void
    ) {
        self.router = router
        self.apiClient = apiClient
        self.analyticsClient = analyticsClient
        self.viewModel = viewModel
        self.config = config
        self.paymentMethods = paymentMethods
        self.didCancel = didCancel
        self.didComplete = didComplete
        super.init()
    }
    
    override func start() {
        showEmailCaptureForm()
    }
    
    override func start(with route: DispatchRoute) {
        print("[WARNING] Invalid deep link coordinator. Cannot handle deep link route")
        start()
    }
    
    @objc private func handleBackButton() {
        router.popModule()
    }
    
    private func showEmailCaptureForm() {
        let viewController = UIHostingController<ContactInformationForm>(
            rootView: ContactInformationForm(viewModel: viewModel)
        )

        viewController.navigationItem.rightBarButtonItem = .init(customView: closeButtonController.view)
        viewController.navigationItem.titleView = navigationTitleController.view

        viewModel
            ._onOrderInitiated
            .sink { [weak self] order, email in
                self?.order = order
                self?.analyticsClient.send(event: .customerIdentifierCollected_Checkout)
                self?.showShippingAddressForm(
                    for: order,
                    variant: self?.viewModel.variant,
                    email: email
                )
            }
            .store(in: &cancellables)

        router.presentCheckout(viewController, completion: nil)
    }
    
    private func showShippingAddressForm(
        for order: InitiateOrder,
        variant: Variation?,
        email: String
    ) {
        let addressLookupService: AddressLookupService = MapKitAddressLookupService()
        let viewModel = ShippingAddressViewModel(
            addressLookupService: addressLookupService,
            apiClient: apiClient,
            order: order
        )
        let viewController: UIHostingController<ShippingAddressFormContainer> = .init(
            rootView: ShippingAddressFormContainer(viewModel: viewModel)
        )

        viewController.navigationItem.rightBarButtonItem = .init(customView: closeButtonController.view)
        viewController.navigationItem.titleView = navigationTitleController.view

        viewModel
            ._onOrderUpdated
            .sink {
                [weak self] order,
                address, phone in
                self?.analyticsClient.send(event: .shippingAddressCollected_Checkout)
                self?.showShippingMethods(
                    for: order,
                    variant: variant,
                    email: email,
                    phone: phone,
                    address: address
                )
            }
            .store(in: &cancellables)
        
        router.push(viewController, animated: true)
    }
    
    private func showShippingMethods(
        for order: InitiateOrder,
        variant: Variation?,
        email: String,
        phone: String,
        address: Address
    ) {
        let viewModel = ShippingMethodViewModel(apiClient: apiClient, orderId: order.id)
        let viewController = UIHostingController<ShippingMethodsView>(
            rootView: ShippingMethodsView(
                viewModel: viewModel
            )
        )

        viewController.navigationItem.rightBarButtonItem = .init(customView: closeButtonController.view)
        viewController.navigationItem.titleView = navigationTitleController.view

        viewModel
            ._onShippingMethodTapped
            .sink { [weak self] shippingMethod in
                self?.showBillingForm(
                    for: order,
                    variant: variant,
                    email: email,
                    shippingAddress: address, 
                    phone: phone,
                    shippingMethod: shippingMethod
                )
            }
            .store(in: &cancellables)
        
        router.push(viewController)
    }
    
    private func showBillingForm(
        for order: InitiateOrder,
        variant: Variation?,
        email: String,
        shippingAddress: Address,
        phone: String,
        shippingMethod: ShippingMethod
    ) {
        let viewModel = CreditCardInputViewModel(
            addressLookupService: MapKitAddressLookupService(),
            apiClient: apiClient,
            order: order
        )
        let viewController = UIHostingController(
            rootView: CreditCardForm(
                viewModel: viewModel
            )
        )

        viewController.navigationItem.rightBarButtonItem = .init(customView: closeButtonController.view)
        viewController.navigationItem.titleView = navigationTitleController.view

        viewModel
            ._onPaymentTokenGenerated
            .sink {
                [weak self] (paymentToken,
                billingAddress, billingInfo) in
                self?.showOrderPreview(
                    for: order,
                    email: email,
                    variant: variant,
                    phone: phone,
                    shippingAddress: shippingAddress,
                    shippingMethod: shippingMethod,
                    billingAddress: billingAddress,
                    billingInfo: billingInfo,
                    paymentToken: paymentToken
                )
            }
            .store(in: &cancellables)
        
        router.push(viewController)
    }
    
    private func showOrderPreview(
        for order: InitiateOrder,
        email: String,
        variant: Variation?,
        phone: String,
        shippingAddress: Address,
        shippingMethod: ShippingMethod,
        billingAddress: Address,
        billingInfo: BillingInfo,
        paymentToken: String
    ) {
        let viewModel = CheckoutOverviewViewModel(
            apiClient: apiClient,
            analyticsClient: analyticsClient,
            checkout: viewModel.checkout,
            order: order,
            email: viewModel.email,
            variant: variant,
            phone: phone,
            shippingAddress: shippingAddress,
            billingAddress: billingAddress,
            billingInfo: billingInfo,
            shippingMethod: shippingMethod,
            paymentMethods: paymentMethods,
            tokenizedPayment: paymentToken
        )
        
        let viewController = UIHostingController<CheckoutOverviewView>(
            rootView: CheckoutOverviewView(viewModel: viewModel)
        )
        
        viewModel
            ._onOrderComplete
            .sink { [weak self] order in
                self?.didComplete(order, shippingAddress, billingInfo)
            }
            .store(in: &cancellables)
        
        router.push(viewController)
    }
    
    private func showTermsOfSale(for checkout: Checkout) {
        guard
            let url = URL(string: checkout.merchantTermsUrl),
            UIApplication.shared.canOpenURL(url)
        else {
            return
        }
            
        UIApplication.shared.open(url)
    }
    
}
