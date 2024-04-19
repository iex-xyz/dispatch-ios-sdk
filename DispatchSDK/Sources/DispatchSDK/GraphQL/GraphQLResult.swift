import Foundation

public struct GraphQLResult<T: Decodable>: Decodable {
    public let object: T?
    public let errorMessages: [String]
    
    public enum CodingKeys: String, CodingKey {
        case data
        case errors
    }
    
    public struct Error: Decodable {
        public let message: String
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dataDict = try container.decodeIfPresent([String: T].self, forKey: .data)
        self.object = dataDict?.values.first
        
        var errorMessages: [String] = []
        
        let errors = try container.decodeIfPresent([Error].self, forKey: .errors)
        if let errors = errors {
            errorMessages.append(contentsOf: errors.map { $0.message })
        }
        
        self.errorMessages = errorMessages
    }
}

