import Foundation

public struct GraphQLOperation<Input: Encodable, Output: Decodable>: Encodable {
    public var input: Input
    public var operationString: String
    
    private let url = URL(string: "https://graphqlzero.almansi.me/api")!
    
    public enum CodingKeys: String, CodingKey {
        case variables
        case query
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(input, forKey: .variables)
        try container.encode(operationString, forKey: .query)
    }
    
    public func getURLRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(self)
    
        return request
    }
}
