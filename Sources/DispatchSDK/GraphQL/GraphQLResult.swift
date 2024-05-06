import Foundation

public struct GraphQLResult<T: Decodable>: Decodable {
    public let object: T?
    public let errorMessages: [String]
    
    public enum CodingKeys: String, CodingKey {
        case data
        case errors
    }
    
    public struct Error: Decodable {
        public var errorCode: String
        public let errorMessage: String
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let errorCode = try? container.decode(String.self, forKey: .errorCode) {
                self.errorCode = errorCode
            } else if let intErrorCode = try? container.decode(Int.self, forKey: .errorCode) {
                self.errorCode = String(intErrorCode)
            } else {
                self.errorCode = "Unknown"
            }
            
            self.errorMessage = try container.decode(String.self, forKey: .errorMessage)
        }
        
        enum CodingKeys: String, CodingKey {
            case errorCode
            case errorMessage
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dataDict = try container.decodeIfPresent([String: T].self, forKey: .data)
        self.object = dataDict?.values.first
        
        var errorMessages: [String] = []
        
        let errors = try container.decodeIfPresent([Error].self, forKey: .errors)
        if let errors = errors {
            errorMessages.append(contentsOf: errors.map { $0.errorMessage })
        }
        
        self.errorMessages = errorMessages
    }
}

