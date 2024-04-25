import Foundation
import Combine

class CheckoutOverviewViewModel: ObservableObject {
    let apiClient: GraphQLClient
    let checkout: Checkout
    let orderId: String
    let email: String
    let variant: Variation?
    let phone: String
    let shippingAddress: Address // TODO: Model address
    let billingAddress: Address? // TODO: Model address
    // TODO: Billing details
    let shippingMethod: ShippingMethod
    let tokenizedPayment: String
    
    // TODO: How should we model the cost breakdown?
    let subtotal: String
    let tax: String
    let delivery: String
    
    let _onShippingMethodTapped = PassthroughSubject<(ShippingMethod), Never>()
    let _onShippingAddressTapped = PassthroughSubject<(Address), Never>()
    let _onPaymentDetailsTapped = PassthroughSubject<(Address), Never>()
    let _onEmailTapped = PassthroughSubject<(String), Never>()
    let _onPhoneTapped = PassthroughSubject<(String), Never>()

    let _onOrderComplete = PassthroughSubject<(Void), Never>()

    init(
        apiClient: GraphQLClient,
        checkout: Checkout,
        orderId: String,
        email: String,
        variant: Variation?,
        phone: String,
        shippingAddress: Address,
        billingAddress: Address?,
        shippingMethod: ShippingMethod,
        subtotal: String,
        tax: String,
        delivery: String,
        tokenizedPayment: String
    ) {
        self.apiClient = apiClient
        self.checkout = checkout
        self.orderId = orderId
        self.email = email
        self.variant = variant
        self.phone = phone
        self.shippingAddress = shippingAddress
        self.billingAddress = billingAddress
        self.shippingMethod = shippingMethod
        self.subtotal = subtotal
        self.tax = tax
        self.delivery = delivery
        self.tokenizedPayment = tokenizedPayment
    }
    
    func onPayButtonTapped() {
        Task {
            do {
                try await completeOrder()
            } catch {
                // TODO: Error handling
                print("Unable to complete order", error)
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
        // TODO:
//        _onShippingMethodTapped.send(shippingAddress)
    }
    
    func onShippingMethodButtonTapped() {
        _onShippingMethodTapped.send(shippingMethod)
    }
    
    func onPaymentDetailsButtonTapped() {
//         TODO:
//        _onPaymentDetailsTapped.send()
    }
    
    func onCloseButtonTapped() {
        // TODO:
    }
    
    private func completeOrder() async throws {
        let request = CompleteOrderRequest(orderId: orderId, tokenizedPayment: tokenizedPayment)
        _ = try await apiClient.performOperation(request)
        DispatchQueue.main.async {
            // TODO: What do we need to pass to the next screen?
            self._onOrderComplete.send()
        }
    }
}
