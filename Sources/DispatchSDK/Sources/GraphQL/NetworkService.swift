import Foundation

enum NetworkError: Error {
    case invalidResponse
    case serverError(statusCode: Int)
}

@available(iOS 15.0, *)
protocol NetworkService {
    func performRequest(_ urlRequest: URLRequest) async throws -> Data
    func updateDistribution(_ distributionId: String)
}

@available(iOS 15.0, *)
class RealNetworkService: NetworkService {
    
    private let applicationId: String
    private var distributionId: String

    init(applicationId: String, distributionId: String) {
        self.applicationId = applicationId
        self.distributionId = distributionId
    }

    func updateDistribution(_ distributionId: String) {
        self.distributionId = distributionId
    }
    
    func performRequest(_ urlRequest: URLRequest) async throws -> Data {
        var request = urlRequest
        request.setValue(applicationId, forHTTPHeaderField: "x-application-id")
        request.setValue(distributionId, forHTTPHeaderField: "x-source-id")
        request.setValue("IOS", forHTTPHeaderField: "x-application-context")

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        return data
    }
}

// TODO: Add mock data support
@available(iOS 15.0, *)
class PreviewNetworkService: NetworkService {
    func performRequest(_ urlRequest: URLRequest) async throws -> Data {
        throw NetworkError.serverError(statusCode: 400)
    }
}

@available(iOS 13.0.0, *)
class EmptyNetworkService: NetworkService {
    @available(iOS 13.0.0, *)
    func performRequest(_ urlRequest: URLRequest) async throws -> Data {
        throw NetworkError.serverError(statusCode: 400)
    }
}
