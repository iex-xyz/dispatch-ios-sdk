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
            .sink { [weak self] order in
                self?.showShippingAddressForm(for: order)
            }
            .store(in: &cancellables)

        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 16
        }
        router.present(viewController, animated: true) { [weak self] in
            self?.didCancel()
        }
    }
    
    private func showShippingAddressForm(for order: InitiateOrder) {
        let addressLookupService: AddressLookupService = MapKitAddressLookupService()
        let viewModel = ShippingAddressViewModel(
            addressLookupService: addressLookupService,
            apiClient: apiClient,
            orderId: order.id
        )
        let viewController: UIHostingController<ShippingAddressFormContainer> = .init(
            rootView: ShippingAddressFormContainer(viewModel: viewModel)
        )
        
        viewModel
            ._onOrderUpdated
            .sink { [weak self] orderId in
                self?.showShippingMethods(for: orderId)
            }
            .store(in: &cancellables)
        
        router.dismissModule(animated: true) { [weak self] in
            self?.router.push(viewController, animated: true)
        }
    }
    
    private func showShippingMethods(for orderId: String) {
        let viewModel = ShippingMethodViewModel(apiClient: apiClient, orderId: orderId)
        let viewController = UIHostingController<ShippingMethodsView>(
            rootView: ShippingMethodsView(
                viewModel: viewModel
            )
        )
        
        viewModel
            ._onShippingMethodTapped
            .sink { [weak self] shippingMethod in
                print("Shipping method selected", shippingMethod)
                self?.showBillingForm(for: orderId)
            }
            .store(in: &cancellables)
        
        router.push(viewController)
    }
    
    private func showBillingForm(for orderId: String) {
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
            ._onOrderUpdated
            .sink { [weak self] orderId in
                self?.showOrderPreview(for: orderId)
            }
            .store(in: &cancellables)
        
        router.push(viewController)
    }
    
    private func showOrderPreview(for orderId: String) {
        // TODO: Where do we store all of this data while we go through the flow?
        let viewModel = CheckoutOverviewViewModel(
            checkout: viewModel.checkout,
            orderId: orderId,
            email: viewModel.email,
            variant: nil,
            phone: "",
            shippingAddress: [:],
            billingAddress: nil,
            shippingMethod: .random(),
            subtotal: "$subtotal",
            tax: "$tax",
            delivery: "$delivery"
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
