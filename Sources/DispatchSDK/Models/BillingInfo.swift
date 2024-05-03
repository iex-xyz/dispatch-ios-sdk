import Foundation

struct BillingInfo {
    let cardPreview: String
    let cardType: CreditCardType
}


extension BillingInfo {
    static func mock() -> BillingInfo {
        return BillingInfo(cardPreview: "4242", cardType: .visa)
    }
}
