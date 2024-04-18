import Foundation

class GraphQLClient {
    private let networkService: NetworkService
    private var environment: AppEnvironment
    
    init(networkService: NetworkService, environment: AppEnvironment) {
        self.networkService = networkService
        self.environment = environment
    }
    
    func performOperation<Request: GraphQLRequest>(_ request: Request) async throws -> Request.Output {
        let urlRequest = try request.getURLRequest(url: environment.baseURL)
        let data = try await networkService.performRequest(urlRequest)
        return try request.parseResponse(data: data)
    }
}
