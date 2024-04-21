import Foundation
import Combine

class CheckoutOverviewViewModel: ObservableObject {
    typealias Address = [String: String]
    let checkout: Checkout
    let orderId: String
    let email: String
    let variant: Variation
    let phone: String
    let shippingAddress: Address // TODO: Model address
    let billingAddress: Address? // TODO: Model address
    // TODO: Billing details
    let shippingMethod: ShippingMethod
    
    // TODO: How should we model the cost breakdown?
    let subtotal: String
    let tax: String
    let delivery: String
    
    let _onShippingMethodTapped = PassthroughSubject<(ShippingMethod), Never>()
    let _onShippingAddressTapped = PassthroughSubject<(Address), Never>()
    let _onPaymentDetailsTapped = PassthroughSubject<(Address), Never>()
    let _onEmailTapped = PassthroughSubject<(String), Never>()
    let _onPhoneTapped = PassthroughSubject<(String), Never>()

    init(
        checkout: Checkout,
        orderId: String,
        email: String,
        variant: Variation,
        phone: String,
        shippingAddress: [String : String],
        billingAddress: [String : String]?,
        shippingMethod: ShippingMethod,
        subtotal: String,
        tax: String,
        delivery: String
    ) {
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
    }

    
    func onPayButtonTapped() {
        
    }
    
    func onMorePaymentOptionsButtonTapped() {
        
    }
    
    func onVariantButtonTapped() {
        
    }
    
    func onEmailButtonTapped() {
        
    }
    
    func onPhoneButtonTapped() {
        
    }
    
    func onShippingAddressButtonTapped() {
        
    }
    
    func onShippingMethodButtonTapped() {
        
    }
    
    func onPaymentDetailsButtonTapped() {
        
    }
    
    func onCloseButtonTapped() {
        
    }
}
