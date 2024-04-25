import Foundation

struct InitiateOrderRequest: GraphQLRequest {
    typealias Output = InitiateOrder
    typealias Input = OrderInput
    
    struct Response: Codable {
        let initiateOrder: InitiateOrder
    }
    
    struct OrderInput: Encodable {
        let email: String
        let productId: String
        let variantId: String
    }

    var operationString: String {
        """
        query {
            initiateOrder(
              emailAddress: \"\(input.email)\",
              productId: \"\(input.productId)\",
              variantId: \"\(input.variantId)\"
            ) {
                id
                status
          }
        }
        """
    }

    var input: Input

    init(email: String, productId: String, variantId: String) {
        self.input = .init(email: email, productId: productId, variantId: variantId)
    }
}
