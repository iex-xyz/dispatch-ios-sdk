import Foundation

struct GetShippingMethodsForOrderRequest: GraphQLRequest {
    struct Response: Codable {
        let id: String
        let availableShippingMethods: [ShippingMethod]
    }
    
    typealias Output = Response
    typealias Input = [String: AnyEncodable]
    
    var operationString: String {
        """
        query {
              getShippingMethodsForOrder(
                orderId: \"\(orderId)\",
              ) {
               id
               availableShippingMethods {
                id
                title
                handle
                price
                phoneRequired
                estimatedTimeInTransit
               }
            }
         }
        """
    }
    
    var input: Input
    let orderId: String
    
    init(orderId: String) {
        self.orderId = orderId
        self.input = [:]
    }
}

