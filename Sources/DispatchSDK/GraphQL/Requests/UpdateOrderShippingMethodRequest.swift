import Foundation

struct UpdateOrderShippingMethodRequest: GraphQLRequest {
    struct Response: Codable {
        let id: String
        let status: String // TODO: Type with enum?
    }
    
    struct RequestParams: Codable {
        let orderId: String
        let shippingMethod: String
    }

    typealias Output = Response
    typealias Input = [String: AnyEncodable]
    
    var operationString: String {
        """
        mutation {
               
               updateOrderInformation(
               orderId: \"\(params.orderId)\",
               shippingMethod: \"\(params.shippingMethod)\",
               updateType: SHIPPING_METHOD
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

