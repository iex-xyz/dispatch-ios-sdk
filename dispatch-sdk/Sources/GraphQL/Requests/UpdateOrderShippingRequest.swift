import Foundation

struct UpdateOrderShippingRequest: GraphQLRequest {
    struct Response: Codable {
        let id: String
        let status: String // TODO: Type with enum?
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
        let phoneNumber: String // TODO: Unformatted?
        let country: String
    }

    typealias Output = Response
    typealias Input = [String: AnyEncodable]
    
    var operationString: String {
        """
        mutation {
               updateOrderInformation(
                 orderId: \"\(params.orderId)\",
                 updateType: ADDRESS_SHIPPING_AND_BILLING
                   address1: \"\(params.address1)\",
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

