import Foundation
import Combine

class CheckoutOverviewViewModel: ObservableObject {
    enum OrderCheckoutState {
        case idle
        case loading
        case complete(InitiateOrder)
        case failed(Error)
        
        var isEnabled: Bool {
            switch self {
            case .idle, .failed, .complete: return true
            case .loading: return false
            }
        }
        
        var isLoading: Bool {
            switch self {
            case .idle, .failed, .complete: return false
            case .loading: return true
            }
        }
    }
    
    @Published var state: OrderCheckoutState = .idle
    
    let apiClient: GraphQLClient
    let checkout: Checkout
    let email: String
    let variant: Variation?
    let phone: String
    let shippingAddress: Address
    let billingAddress: Address?
    let billingInfo: BillingInfo
    let shippingMethod: ShippingMethod
    let tokenizedPayment: String
    let order: InitiateOrder
    
    let _onShippingMethodTapped = PassthroughSubject<(ShippingMethod), Never>()
    let _onShippingAddressTapped = PassthroughSubject<(Address), Never>()
    let _onPaymentDetailsTapped = PassthroughSubject<(Address), Never>()
    let _onEmailTapped = PassthroughSubject<(String), Never>()
    let _onPhoneTapped = PassthroughSubject<(String), Never>()

    let _onOrderComplete = PassthroughSubject<(InitiateOrder), Never>()

    init(
        apiClient: GraphQLClient,
        checkout: Checkout,
        order: InitiateOrder,
        email: String,
        variant: Variation?,
        phone: String,
        shippingAddress: Address,
        billingAddress: Address?,
        billingInfo: BillingInfo,
        shippingMethod: ShippingMethod,
        tokenizedPayment: String
    ) {
        self.apiClient = apiClient
        self.checkout = checkout
        self.order = order
        self.email = email
        self.variant = variant
        self.phone = phone
        self.shippingAddress = shippingAddress
        self.billingAddress = billingAddress
        self.billingInfo = billingInfo
        self.shippingMethod = shippingMethod
        self.tokenizedPayment = tokenizedPayment
    }
    
    func onPayButtonTapped() {
        self.state = .loading
        Task {
            do {
                let order = try await completeOrder()
                DispatchQueue.main.async {
                    self.state = .complete(order)
                    self._onOrderComplete.send(order)
                }
            } catch {
                // TODO: Error handling
                print("[DispatchSDK] Unable to complete order", error)
                DispatchQueue.main.async {
                    self.state = .failed(error)
                }
            }
        }
    }
    
    func onMorePaymentOptionsButtonTapped() {
        
    }
    
    func onVariantButtonTapped() {
        
    }
    
    func onEmailButtonTapped() {
        _onEmailTapped.send(email)
    }
    
    func onPhoneButtonTapped() {
        _onPhoneTapped.send(phone)
    }
    
    func onShippingAddressButtonTapped() {
//        _onShippingMethodTapped.send(shippingAddress)
    }
    
    func onShippingMethodButtonTapped() {
        _onShippingMethodTapped.send(shippingMethod)
    }
    
    func onPaymentDetailsButtonTapped() {
//        _onPaymentDetailsTapped.send()
    }
    
    func onCloseButtonTapped() {
        // TODO:
    }
    
    private func completeOrder() async throws -> InitiateOrder {
        let request = CompleteOrderRequest(orderId: order.id, tokenizedPayment: tokenizedPayment)
        return try await apiClient.performOperation(request)
        
        
    }
}
