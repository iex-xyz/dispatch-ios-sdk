import Foundation

struct GetDistributionRequest: GraphQLRequest {
    enum Response: Codable {
        case leadgen(Leadgen)
        case checkout(Checkout)
        case content(Content)
    }

    typealias Output = Response
    typealias Input = [String: AnyEncodable]
    
    var operationString: String {
        """
        query {
            getDistribution(
              id: \"\(id)\",
            )
        }
        """
    }
    
    var input: Input
    let id: String
    
    init(id: String) {
        self.id = id
        self.input = [:]
    }
}


extension GetDistributionRequest.Response {
    private enum CodingKeys: String, CodingKey {
        case type
    }
    
    private enum TypeValue: String, Codable {
        case leadgen = "Leadgen"
        case checkout = "Checkout"
        case content = "Content"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(TypeValue.self, forKey: .type)
        
        switch type {
        case .leadgen:
            let leadgen = try Leadgen(from: decoder)
            self = .leadgen(leadgen)
        case .checkout:
            let checkout = try Checkout(from: decoder)
            self = .checkout(checkout)
        case .content:
            // NOTE: For now the iOS SDK will treat 'Content' and 'Checkout' type as the same flow
            let checkout = try Checkout(from: decoder)
            self = .checkout(checkout)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case let .leadgen(leadgen):
            try container.encode(TypeValue.leadgen, forKey: .type)
            try leadgen.encode(to: encoder)
        case let .checkout(checkout):
            try container.encode(TypeValue.checkout, forKey: .type)
            try checkout.encode(to: encoder)
        case let .content(content):
            try container.encode(TypeValue.content, forKey: .type)
            try content.encode(to: encoder)
        }
    }
}
