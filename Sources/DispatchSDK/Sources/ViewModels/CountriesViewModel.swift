import Foundation
import Combine

@available(iOS 15.0, *)
class CountriesViewModel: ObservableObject {

    enum State {
        case idle
        case loading
        case complete([Country])
        case failed(Error)
        
        var countries: [Country] {
            switch self {
            case let .complete(countries):
                return countries
            default:
                return []
            }
        }
        
        var isEnabled: Bool {
            switch self {
            case .complete, .failed:
                return true
            default:
                return false
            }
        }
    }
    
    @Published var state: State = .idle
    
    let apiClient: GraphQLClient
    
    init(apiClient: GraphQLClient) {
        self.apiClient = apiClient
        
        fetchCountries()
    }

    func fetchCountries() {
        self.state = .loading
        Task {
            do {
                let request = GetCountriesRequest(locale: "en") // TODO: https://github.com/iex-xyz/frontend-monorepo/blob/development/apps/checkout/i18n/i18n.ts#L16
                let response = try await apiClient.performOperation(request)
                
                DispatchQueue.main.async {
                    self.state = .complete(response.countries)
                }
            } catch {
                print("[DispatchSDK] Unable to fetch countries list: ", error)
                DispatchQueue.main.async {
                    self.state = .failed(error)
                }
            }
        }
    }
}
