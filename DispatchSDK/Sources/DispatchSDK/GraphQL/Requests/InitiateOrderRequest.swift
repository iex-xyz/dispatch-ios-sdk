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
        let variantId: String?
        let quantity: Int
    }

    var operationString: String {
        var query = """
        query {
            initiateOrder(
              emailAddress: \"\(input.email)\",
              productId: \"\(input.productId)\",
              quantity: \(input.quantity),
        """
        
        if let variantId = input.variantId {
            query.append("""
,
variantId: \"\(variantId)\"
""")
        }
        
        query.append(
        """
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
        )
        
        return query
    }

    var input: Input

    init(email: String, productId: String, variantId: String?, quantity: Int) {
        self.input = .init(email: email, productId: productId, variantId: variantId, quantity: quantity)
    }
}
