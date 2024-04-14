import Foundation

public protocol NetworkService {
    func performRequest<T: Decodable>(_ urlRequest: URLRequest, completion: @escaping (Result<T, Error>) -> Void)
}

class RealNetworkService: NetworkService {
    func performRequest<T>(_ urlRequest: URLRequest, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
