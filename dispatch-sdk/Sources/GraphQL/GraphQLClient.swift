import Foundation

class GraphQLClient {
    private let networkService: NetworkService
    private let url: URL
    
    init(networkService: NetworkService, url: URL) {
        self.networkService = networkService
        self.url = url
    }
    
    func performOperation<Request: GraphQLRequest>(_ request: Request) async throws -> Request.Output {
        let urlRequest = try request.getURLRequest(url: url)
        let data = try await networkService.performRequest(urlRequest)
        return try request.parseResponse(data: data)
    }
}
