import Foundation

struct GraphQLResult<T: Decodable>: Decodable {
    let object: T?
    let errorMessages: [String]
    
    enum CodingKeys: String, CodingKey {
        case data
        case errors
    }
    
    struct Error: Decodable {
        var errorCode: String
        let errorMessage: String
        
        init(from decoder: Decoder) throws {
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
    
    init(from decoder: Decoder) throws {
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

