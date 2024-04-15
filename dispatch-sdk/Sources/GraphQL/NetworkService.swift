import Foundation

enum NetworkError: Error {
    case invalidResponse
    case serverError(statusCode: Int)
}
/*
public protocol NetworkService {
    func performRequest<T>(_ urlRequest: URLRequest) async throws -> Result<T, Error> where T : Decodable
}

class RealNetworkService: NetworkService {
    func performRequest<T>(_ urlRequest: URLRequest) async throws -> Result<T, Error> where T : Decodable {
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }

        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
*/

protocol NetworkService {
    func performRequest(_ urlRequest: URLRequest) async throws -> Data
}

class RealNetworkService: NetworkService {
    func performRequest(_ urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        return data
    }
}
