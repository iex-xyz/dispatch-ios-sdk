import Foundation

struct CompleteOrderRequest: GraphQLRequest {
    typealias Output = InitiateOrder
    typealias Input = OrderInput
    
    struct Response: Codable {
        let id: String
        let status: String
    }
    
    struct OrderInput: Encodable {
        fileprivate let orderId: String
        fileprivate let tokenizedPayment: String
    }

    var operationString: String {
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
            orderId: orderId,
            tokenizedPayment: tokenizedPayment
        )
    }
}
