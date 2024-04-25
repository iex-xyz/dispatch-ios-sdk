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
        self.paymentSummaryItems = []//order.lineItems.map {
            //            PKPaymentSummaryItem(label: $0.productId, amount: NSNumber
//        }
        self.merchentCapabilities = .credit
        
    }
    
    func generateRequest() -> PKPaymentRequest {
        let request = PKPaymentRequest()
        request.currencyCode = self.currencyCode
        request.countryCode = self.countryCode
        request.supportedNetworks = self.supportedNetworks
        request.merchantIdentifier = self.merchantId
        request.paymentSummaryItems = self.paymentSummaryItems
        request.merchantCapabilities = self.merchentCapabilities
        return request
    }
}
