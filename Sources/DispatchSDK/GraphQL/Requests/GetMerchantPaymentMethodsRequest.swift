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


struct GetMerchantPaymentMethodsRequest: GraphQLRequest {
    typealias Output = PaymentConfiguration
    typealias Input = RequestInput
    
    struct RequestInput: Encodable {
        fileprivate let merchantId: String
    }

    var operationString: String {
        """
        query {
               getMerchantPaymentMethods(
                merchantId: \"\(input.merchantId)\",
               ) {
                pspPublishableKey
                pspAccountId
                googlePaymentId
                merchantPaymentMethods
                applicationPaymentMethods
                googlePayEnabled
                applePayEnabled
                cardEnabled

             }
          }
        """
    }

    var input: Input

    init(merchantId: String) {
        self.input = .init(merchantId: merchantId)
    }
}
