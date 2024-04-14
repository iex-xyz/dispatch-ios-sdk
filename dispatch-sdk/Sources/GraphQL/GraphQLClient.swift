import Foundation

class GraphQLClient {
    private let networkService: NetworkService
    private let url = URL(string: "https://graphqlzero.almansi.me/api")!
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func performOperation<Request: GraphQLRequest>(
        _ request: Request,
        completion: @escaping (Result<Request.Output, Error>) -> Void) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let operationData = [
            "query": request.operationString,
            "variables": request.input
        ]
        
        do {
            let jsonData = try JSONEncoder().encode(operationData)
            urlRequest.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        networkService.performRequest(urlRequest) { result in
            switch result {
            case .success(let data):
                completion(request.parseResponse(data: data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
