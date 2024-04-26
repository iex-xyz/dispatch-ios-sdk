import Foundation
import PassKit

class ApplePayViewModel: ObservableObject {
    let currencyCode: String
    let countryCode: String
    let supportedNetworks: [PKPaymentNetwork]
    let merchantId: String
    let paymentSummaryItems: [PKPaymentSummaryItem]
    let merchentCapabilities: PKMerchantCapability
    
    init(order: Order, merchantId: String) {
        self.currencyCode = "USD"
        self.countryCode = "US"
        self.merchantId = merchantId
        self.supportedNetworks = [.visa, .masterCard, .amex]
        self.paymentSummaryItems = [
            .init(
                label: "Total",
                amount: .init(floatLiteral: Double(order.totalCost)),
                type: .final
            )
        ]
        self.merchentCapabilities = .credit
        
    }
    
    func generateRequest() -> PKPaymentRequest {
        let shipping = PKShippingMethod(
            label: "Ground",
            amount: .init(decimal: 0.00)
        )
        
        shipping.identifier = UUID().uuidString
        let request = PKPaymentRequest()
        request.currencyCode = self.currencyCode
        request.countryCode = self.countryCode
        request.supportedNetworks = self.supportedNetworks
        request.merchantIdentifier = self.merchantId
        request.paymentSummaryItems = self.paymentSummaryItems
        request.merchantCapabilities = self.merchentCapabilities
        request.shippingMethods = [
            shipping
        ]
        return request
    }
}
