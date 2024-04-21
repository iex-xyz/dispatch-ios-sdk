import SwiftUI
import Combine

class CheckoutSuccessViewModel: ObservableObject {
    let checkout: Checkout
    let orderNumber: String
    let shippingAddress: String
    let payment: String // TODO: We need a model to hold the full payment preview
    
    let _onMainCTATapped = PassthroughSubject<Void, Never>()

    
    init(checkout: Checkout, orderNumber: String, shippingAddress: String, payment: String) {
        self.checkout = checkout
        self.orderNumber = orderNumber
        self.shippingAddress = shippingAddress
        self.payment = payment
    }
    
    func onMainCtaButtonTapped() {
        _onMainCTATapped.send()
    }
}
