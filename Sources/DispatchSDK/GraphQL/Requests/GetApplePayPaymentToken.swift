import Foundation

struct GetApplePayPaymentTokenRequest: GraphQLRequest {
    typealias Output = Response
    typealias Input = OrderInput
    
    struct Response: Codable {
        let paymentToken: String
    }
    
    struct OrderInput: Encodable {
        let data: String
        let header: String
        let signature: String
        let version: String
        let orderId: String
        let accountId: String?
    }

    var operationString: String {
        """
        query tokenizeApplePayPayment(
            data: \"\(input.data)\",
            header: \"\(input.header)\",
            signature: \"\(input.signature)\",
            version: \"\(input.version)\",
            orderId: \"\(input.orderId)\",
            \(input.accountId != nil ? "stripeAccountId: \"\(input.accountId ?? "")\"" : "")
          ) {
            paymentToken
          }
        """
    }

    var input: Input

    init(input: Input) {
        self.input = input
    }
}
