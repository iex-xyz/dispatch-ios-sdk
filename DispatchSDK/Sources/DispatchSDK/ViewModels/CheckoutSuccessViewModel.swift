import SwiftUI
import Combine

class CheckoutSuccessViewModel: ObservableObject {
    let checkout: Checkout
    let orderNumber: String
    let shippingAddress: Address
    let billingInfo: BillingInfo?
    
    let _onMainCTATapped = PassthroughSubject<Void, Never>()

    
    init(checkout: Checkout, orderNumber: String, shippingAddress: Address, billingInfo: BillingInfo?) {
        self.checkout = checkout
        self.orderNumber = orderNumber
        self.shippingAddress = shippingAddress
        self.billingInfo = billingInfo
    }
    
    func onMainCtaButtonTapped() {
        _onMainCTATapped.send()
    }
}
