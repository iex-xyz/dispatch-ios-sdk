import UIKit
import SwiftUI
import Combine

@available(iOS 15.0, *)
class CreditCardCheckoutViewModel: ObservableObject {
    let checkout: Checkout
    @Published var hasAgreedToTerms: Bool = false
    @Published var email: String = ""
    
    let _onContinueButtonTapped = PassthroughSubject<Void, Never>()

    init(checkout: Checkout) {
        self.checkout = checkout
    }
    
    func onContinueButtonTapped() {
        _onContinueButtonTapped.send()
    }
}
