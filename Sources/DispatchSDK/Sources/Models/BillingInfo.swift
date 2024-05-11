import Foundation

@available(iOS 15.0, *)
struct BillingInfo {
    let cardPreview: String
    let cardType: CreditCardType
}

@available(iOS 15.0, *)
extension BillingInfo {
    static func mock() -> BillingInfo {
        return BillingInfo(cardPreview: "4242", cardType: .visa)
    }
}
