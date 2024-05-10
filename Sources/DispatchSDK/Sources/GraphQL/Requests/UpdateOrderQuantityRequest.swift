import Foundation

struct UpdateOrderQuantityRequest: GraphQLRequest {
    struct Response: Codable {
        let id: String
        let status: String
    }
    
    struct RequestParams: Codable {
        let orderId: String
        let productId: String
        let quantity: Int
    }

    typealias Output = Response
    typealias Input = [String: AnyEncodable]
    
    var operationString: String {
        """
        mutation {
               updateOrderInformation(
               orderId: \"\(params.orderId)\",
               updateType: QUANTITY,
               productId: \"\(params.productId)"
               productQuantity: \(params.quantity)
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
    let params: RequestParams
    
    init(params: RequestParams) {
        self.params = params
        self.input = [:]
    }
}

