import Foundation

internal class CheckoutViewModel: ObservableObject {
    
    private let apiClient: GraphQLClient = .init(
        networkService: RealNetworkService(),
        url: URL(string: "https://checkout-api-staging.dispatch.co/graphql")!
    )
    
    init() {
        Task {
            // Checkout
            await fetchDistribution(for: "652ef22e5599070b1b8b9986")
            // Content
//            await fetchDistribution(for: "64dabb5fa62014aafefbe89e")
            // Leadgen
//            await fetchDistribution(for: "65fb4a90149d4449c0190e3c")
        }
    }
    
    func fetchDistribution(for id: String) async {
        Task {
            do {
                let request = GetDistributionRequest(id: id)
                let distribution = try await apiClient.performOperation(request)
                
                switch distribution {
                case .checkout(let checkout):
                    print("Checkout: \(checkout)")
                case let .content(content):
                    print("Content: \(content)")
                case let .leadgen(leadgen):
                    print("Leadgen: \(leadgen)")
                }
                
            } catch {
                print("Error fetching distribution: \(error)")
            }
        }
    }
    
}
