import Foundation

struct GetApplePayPaymentTokenRequest: GraphQLRequest {
    typealias Output = Response
    typealias Input = OrderInput
    
    struct Response: Codable {
        let paymentToken: String
    }
    
    struct OrderInput: Encodable {
        let data: String
        let header: PaymentJson.Header
        let signature: String
        let version: String
        let orderId: String
        let accountId: String?
    }

    var operationString: String {
        """
          query tokenizeApplePayPayment(
              $data: String!
              $header: JSONObject!
              $signature: String!
              $version: String!
              $orderId: String!
              $stripeAccountId: String
            ) {
              tokenizeApplePayPayment(
                data: $data
                header: $header
                signature: $signature
                version: $version
                orderId: $orderId
                stripeAccountId: $stripeAccountId
              ) {
                paymentToken
              }
            }
    """
    }

    var variables: [String: Any] {
        var variables: [String: Any] = [
            "data": input.data,
            "header": input.header,
            "signature": input.signature,
            "version": input.version,
            "orderId": input.orderId,
            "stripeAccountId": ""
        ]
        
        if let accountId = input.accountId {
            variables["stripeAccountId"] = accountId
        }
        
        return variables
    }

    var input: Input

    init(input: Input) {
        self.input = input
    }
}
