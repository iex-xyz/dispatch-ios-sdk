import Foundation

struct CompleteOrderRequest: GraphQLRequest {
    typealias Output = InitiateOrder
    typealias Input = OrderInput
    
    struct Response: Codable {
        let id: String
        let status: String
    }
    
    struct OrderInput: Encodable {
        fileprivate let applePayEncryptedPaymentData: String?
        fileprivate let orderId: String
        fileprivate let tokenizedPayment: String
    }
    
    var operationString: String {
        if let applePayEncryptedPaymentData = input.applePayEncryptedPaymentData {
            applePayOperationString(applePayData: applePayEncryptedPaymentData)
        } else {
            nonApplePayOperationString
        }
    }

    func applePayOperationString(applePayData: String) -> String {
        """
        mutation {
            completeOrder(
              applePayEncryptedPaymentData: \"\(applePayData)\",
              orderId: \"\(input.orderId)\",
              tokenizedPayment: \"\"
            ) {
                id
                status
                totalCost
                productCost
                shippingCost
                taxCost
          }
        }
        """
    }
    
    var nonApplePayOperationString: String {
        """
        mutation {
            completeOrder(
              orderId: \"\(input.orderId)\",
              tokenizedPayment: \"\(input.tokenizedPayment)\"
            ) {
                id
                status
                totalCost
                productCost
                shippingCost
                taxCost
          }
        }
        """
    }

    var input: Input

    init(
        orderId: String,
        tokenizedPayment: String
    ) {
        self.input = .init(
            applePayEncryptedPaymentData: nil,
            orderId: orderId,
            tokenizedPayment: tokenizedPayment
        )
    }
    
    init(orderId: String, applePayEncryptedPaymentData: String) {
        self.input = .init(
            applePayEncryptedPaymentData: applePayEncryptedPaymentData,
            orderId: orderId,
            tokenizedPayment: ""
        )
    }
}
