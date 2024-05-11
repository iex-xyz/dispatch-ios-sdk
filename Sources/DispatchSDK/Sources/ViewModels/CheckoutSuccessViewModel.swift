import SwiftUI
import Combine

@available(iOS 15.0, *)
class CheckoutSuccessViewModel: ObservableObject {
    let checkout: Checkout
    let orderNumber: String
    let shippingAddress: Address?
    let billingInfo: BillingInfo?
    
    let continueCTA: String
    let hideOrderCompletionCTA: Bool

    
    let _onMainCTATapped = PassthroughSubject<Void, Never>()

    
    init(
        checkout: Checkout,
        orderNumber: String,
        shippingAddress: Address?,
        billingInfo: BillingInfo?,
        continueCTA: String,
        hideOrderCompletionCTA: Bool
    ) {
        self.checkout = checkout
        self.orderNumber = orderNumber
        self.shippingAddress = shippingAddress
        self.billingInfo = billingInfo
        self.continueCTA = continueCTA
        self.hideOrderCompletionCTA = hideOrderCompletionCTA
    }
    
    func onMainCtaButtonTapped() {
        _onMainCTATapped.send()
    }
}
