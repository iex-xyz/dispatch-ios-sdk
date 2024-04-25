import Foundation

struct GetPaymentTokenRequest: GraphQLRequest {
    typealias Output = Response
    typealias Input = OrderInput
    
    struct Response: Codable {
        let paymentToken: String
    }
    
    struct OrderInput: Encodable {
        fileprivate let orderId: String
        fileprivate let cardNumber: String
        fileprivate let expirationMonth: String
        fileprivate let expirationYear: String
        fileprivate let cvc: String
        fileprivate let accountId: String?
    }

    var operationString: String {
        """
        query {
            getPaymentToken(
              orderId: \"\(input.orderId)\",
              cvc: \"\(input.cvc)\",
              number: \"\(input.cardNumber)\",
              expirationMonth: \"\(input.expirationMonth)\",
              expirationYear: \"\(input.expirationYear)\"
            ) {
                paymentToken
          }
        }
        """
    }

    var input: Input

    init(
        orderId: String,
        cardNumber: String,
        expirationMonth: String,
        expirationYear: String,
        cvc: String,
        accountId: String? = nil
    ) {
        self.input = .init(
            orderId: orderId,
            cardNumber: cardNumber,
            expirationMonth: expirationMonth,
            expirationYear: expirationYear,
            cvc: cvc,
            accountId: accountId
        )
    }
}
