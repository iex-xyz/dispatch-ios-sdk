import Foundation
extension String {
    func escapedForGraphQL() -> String {
        return self
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\\/", with: "\\\\/")
    }
}

struct UpdateOrderShippingRequest: GraphQLRequest {
    enum UpdateShippingType: String, Codable {
        case shipping = "ADDRESS_SHIPPING"
        case billing = "ADDRESS_BILLING"
        case shippingAndBilling = "ADDRESS_SHIPPING_AND_BILLING"
    }

    struct RequestParams: Codable {
        let orderId: String
        let firstName: String
        let lastName: String
        let address1: String
        let address2: String
        let city: String
        let state: String
        let zip: String
        let phoneNumber: String
        let country: String
        let email: String?
        
        let updateType: UpdateShippingType
    }

    typealias Output = InitiateOrder
    typealias Input = [String: AnyEncodable]
    
    var operationString: String {
        """
        mutation {
               updateOrderInformation(
                 orderId: \"\(params.orderId)\",
                 updateType: \(params.updateType.rawValue),
                   address1: \"\(params.address1.escapedForGraphQL())\",
                   address2: \"\(params.address2)\",
                   city: \"\(params.city)\",
                   country: \"\(params.country)\",
                   firstName: \"\(params.firstName)\",
                   lastName: \"\(params.lastName)\",
                   phone: \"\(params.phoneNumber)\",
                   province: \"\(params.state)\",
                   zip: \"\(params.zip)\",
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

