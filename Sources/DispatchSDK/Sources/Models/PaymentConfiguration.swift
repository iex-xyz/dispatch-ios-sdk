import Foundation

struct PaymentConfiguration: Equatable, Codable {
    let pspPublishableKey: String
    let pspAccountId: String
    let googlePaymentId: String
    let merchantPaymentMethods: [PaymentMethods]
    let applicationPaymentMethods: [PaymentMethods]
    let googlePayEnabled: Bool
    let applePayEnabled: Bool
    let cardEnabled: Bool
}

