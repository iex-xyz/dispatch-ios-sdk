import Foundation
import Combine

class ShippingMethodViewModel: ObservableObject {
    internal enum State {
        case idle
        case loading
        case loaded([ShippingMethod])
        case error(Error)
    }
    
    let apiClient: GraphQLClient
    let orderId: String
    
    
    let _onShippingMethodTapped = PassthroughSubject<(ShippingMethod), Never>()

    
    @Published var state: State = .idle
    
    init(apiClient: GraphQLClient, orderId: String) {
        self.apiClient = apiClient
        self.orderId = orderId
    }
    
    func onAppear() {
        Task {
            await fetchShippingMethods()
        }
    }
    
    func fetchShippingMethods() async {
        self.state = .loading

        Task { [weak self] in
            guard let self else { return }
            do {
                let request = GetShippingMethodsForOrderRequest(orderId: self.orderId)
                let response = try await apiClient.performOperation(request)
                DispatchQueue.main.async {
                    self.state = .loaded(response.availableShippingMethods)
                }
            } catch {
                print("Error fetching shipping methods: \(error)")
                DispatchQueue.main.async {
                    self.state = .error(error)
                }
            }
        }
    }
    
    func onShippingMethodTapped(_ shippingMethod: ShippingMethod) {
        Task {
            await updateShippingMethodForOrder(shippingMethod: shippingMethod)
        }
    }
    
    private func updateShippingMethodForOrder(shippingMethod: ShippingMethod) async {
        do {
            let request = UpdateOrderShippingMethodRequest(
                params: .init(
                    orderId: orderId,
                    shippingMethod: shippingMethod.id
                )
            )
            
            let response = try await apiClient.performOperation(request)
            DispatchQueue.main.async {
                self._onShippingMethodTapped.send(shippingMethod)
            }
        } catch {
            print("Error updating shipping method (\(shippingMethod.id) for \(orderId)")
        }
        
    }
}
