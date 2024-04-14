import Foundation

protocol GraphQLRequest {
    associatedtype Output: Decodable
    associatedtype Input: Encodable
    
    var operationString: String { get }
    var input: Input { get }
    
    func parseResponse(data: Data) -> Result<Output, Error>
}

extension GraphQLRequest {
    func parseResponse(data: Data) -> Result<Output, Error> {
        do {
            let result = try JSONDecoder().decode(GraphQLResult<Output>.self, from: data)
            if let object = result.object {
                return .success(object)
            } else {
                let errorDescription = result.errorMessages.joined(separator: "\n")
                return .failure(NSError(domain: "GraphQL Error", code: 1, userInfo: [NSLocalizedDescriptionKey: errorDescription]))
            }
        } catch {
            return .failure(error)
        }
    }
}
