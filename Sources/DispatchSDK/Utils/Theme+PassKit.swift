import PassKit

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
