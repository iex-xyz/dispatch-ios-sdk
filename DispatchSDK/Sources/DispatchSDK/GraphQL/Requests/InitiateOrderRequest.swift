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
    }

    var operationString: String {
        var query = """
        query {
            initiateOrder(
              emailAddress: \"\(input.email)\",
              productId: \"\(input.productId)\"
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
          }
        }
        """
        )
        
        return query
    }

    var input: Input

    init(email: String, productId: String, variantId: String?) {
        self.input = .init(email: email, productId: productId, variantId: variantId)
    }
}
