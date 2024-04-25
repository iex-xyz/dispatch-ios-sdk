import UIKit
import SwiftUI
import Combine

class CreditCardCoordinator: BaseCoordinator {
    private let router: Router
    private let apiClient: GraphQLClient
    private let orderId: String
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let viewModel: InitiateCreditCardCheckoutViewModel
    private let didCancel: () -> Void

    init(
        router: Router,
        apiClient: GraphQLClient,
        orderId: String,
        viewModel: InitiateCreditCardCheckoutViewModel,
        didCancel: @escaping () -> Void
    ) {
        self.router = router
        self.apiClient = apiClient
        self.orderId = orderId
        self.viewModel = viewModel
        self.didCancel = didCancel
        super.init()
    }
    
    override func start() {
        showEmailCaptureForm()
    }
    
    private func showEmailCaptureForm() {
        let viewController = UIHostingController<ContactInformationForm>(
            rootView: ContactInformationForm(viewModel: viewModel)
        )
        
        viewModel
            ._onOrderInitiated
            .sink { [weak self] order, email in
                self?.showShippingAddressForm(
                    for: order.id,
                    email: email
                )
            }
            .store(in: &cancellables)

        router.push(viewController, animated: true) { [weak self] in
            self?.didCancel()
        }
    }
    
    private func showShippingAddressForm(
        for orderId: String,
        email: String
    ) {
        let addressLookupService: AddressLookupService = MapKitAddressLookupService()
        let viewModel = ShippingAddressViewModel(
            addressLookupService: addressLookupService,
            apiClient: apiClient,
            orderId: orderId
        )
        let viewController: UIHostingController<ShippingAddressFormContainer> = .init(
            rootView: ShippingAddressFormContainer(viewModel: viewModel)
        )
        
        viewModel
            ._onOrderUpdated
            .sink {
                [weak self] orderId,
                address, phone in
                self?.showShippingMethods(
                    for: orderId,
                    email: email,
                    phone: phone,
                    address: address
                )
            }
            .store(in: &cancellables)
        
        router.push(viewController, animated: true)
    }
    
    private func showShippingMethods(
        for orderId: String,
        email: String,
        phone: String,
        address: Address
    ) {
        let viewModel = ShippingMethodViewModel(apiClient: apiClient, orderId: orderId)
        let viewController = UIHostingController<ShippingMethodsView>(
            rootView: ShippingMethodsView(
                viewModel: viewModel
            )
        )
        
        viewModel
            ._onShippingMethodTapped
            .sink { [weak self] shippingMethod in
                self?.showBillingForm(
                    for: orderId,
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
        for orderId: String,
        email: String,
        shippingAddress: Address,
        phone: String,
        shippingMethod: ShippingMethod
    ) {
        let viewModel = CreditCardInputViewModel(
            addressLookupService: MapKitAddressLookupService(),
            apiClient: apiClient,
            orderId: orderId
        )
        let viewController = UIHostingController(
            rootView: CreditCardForm(
                viewModel: viewModel
            )
        )
        
        viewModel
            ._onPaymentTokenGenerated
            .sink {
                [weak self] (paymentToken,
                billingAddress) in
                self?.showOrderPreview(
                    for: orderId,
                    email: email,
                    variant: nil,
                    phone: phone,
                    shippingAddress: shippingAddress,
                    shippingMethod: shippingMethod,
                    billingAddress: billingAddress,
                    billingDetails: "TODO",
                    paymentToken: paymentToken
                )
            }
            .store(in: &cancellables)
        
        router.push(viewController)
    }
    
    private func showOrderPreview(
        for orderId: String,
        email: String,
        variant: Variation?,
        phone: String,
        shippingAddress: Address,
        shippingMethod: ShippingMethod,
        billingAddress: Address,
        billingDetails: String,
        paymentToken: String
    ) {
        // TODO: Where do we store all of this data while we go through the flow?
        let viewModel = CheckoutOverviewViewModel(
            apiClient: apiClient,
            checkout: viewModel.checkout,
            orderId: orderId,
            email: viewModel.email,
            variant: variant,
            phone: phone,
            shippingAddress: shippingAddress,
            billingAddress: billingAddress,
            shippingMethod: shippingMethod,
            subtotal: "$subtotal",
            tax: "$tax",
            delivery: "$delivery",
            tokenizedPayment: paymentToken
        )
        
        let viewController = UIHostingController<CheckoutOverviewView>(
            rootView: CheckoutOverviewView(viewModel: viewModel)
        )
        
        viewModel
            ._onOrderComplete
            .sink { [weak self] in
                self?.navigateToOrderCompleteCoordinator()
            }
            .store(in: &cancellables)
        
        router.push(viewController)
    }
    
    // TODO:
    // Implement order success screen
    
    private func showTermsOfSale(for checkout: Checkout) {
        
    }
    
    private func navigateToOrderCompleteCoordinator() {
        let viewModel = CheckoutSuccessViewModel(
            checkout: viewModel.checkout,
            orderNumber: orderId,
            shippingAddress: "mock address",
            payment: "4242 [MOCK]"
        )
        let coordinator = CheckoutSuccessCoordinator(
            router: router,
            apiClient: apiClient,
            viewModel: viewModel
        )
        
        addDependency(coordinator)
        coordinator.start()
    }
}
