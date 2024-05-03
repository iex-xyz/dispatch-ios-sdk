import Foundation

struct AnyEncodable: Encodable {
    private let encodable: Encodable

    init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}

struct GraphQLError: Error {
    var description: String {
        messages.joined(separator: "\n")
    }
    let messages: [String]
    
}

protocol GraphQLRequest {
    associatedtype Output: Decodable
    associatedtype Input: Encodable

    var operationString: String { get }
    var input: Input { get }

    func parseResponse(data: Data) throws -> Output
    func getURLRequest(url: URL) throws -> URLRequest
}

extension GraphQLRequest {
    func parseResponse(data: Data) throws -> Output {
        let result = try JSONDecoder().decode(GraphQLResult<Output>.self, from: data)
        if let object = result.object {
            return object
        } else {
            throw GraphQLError(messages: result.errorMessages)
        }
    }

    func getURLRequest(url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let operationData: [String: AnyEncodable] = [
            "query": AnyEncodable(operationString),
            "variables": AnyEncodable(input)
        ]
        print("Operation data: \(operationData)")
        request.httpBody = try JSONEncoder().encode(operationData)
        
        return request
    }
}
