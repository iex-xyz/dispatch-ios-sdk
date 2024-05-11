import PassKit

@available(iOS 15.0, *)
extension Theme {
    var paymentButtonStyle: PKPaymentButtonStyle {
        switch mode {
        case .dark:
            return .white
        case .light:
            return .black
        }
    }
}
