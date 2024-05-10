import Foundation
import Combine

class ShippingMethodViewModel: ObservableObject {
    enum SelectedShippingMethodState {
        case idle
        case loading
        case loaded(ShippingMethod)
        case error(Error)

        var isButtonDisabled: Bool {
            switch self {
            case .loading, .loaded:
                return true
            case .error, .idle:
                return false
            }
        }
    }

    enum State {
        case idle
        case loading
        case loaded([ShippingMethod])
        case error(Error)
    }
    
    let apiClient: GraphQLClient
    let orderId: String
    
    
    let _onShippingMethodTapped = PassthroughSubject<(ShippingMethod), Never>()

    
    @Published var state: State = .idle
    @Published var shippingMethodState: SelectedShippingMethodState = .idle

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
        DispatchQueue.main.async {
            self.state = .loading
        }

        Task { [weak self] in
            guard let self else { return }
            do {
                let request = GetShippingMethodsForOrderRequest(orderId: self.orderId)
                let response = try await apiClient.performOperation(request)
                DispatchQueue.main.async {
                    self.state = .loaded(response.availableShippingMethods)
                }
            } catch {
                print("[DispatchSDK] Error fetching shipping methods: \(error)")
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
        DispatchQueue.main.async {
            self.shippingMethodState = .loading
        }
        do {
            let request = UpdateOrderShippingMethodRequest(
                params: .init(
                    orderId: orderId,
                    shippingMethod: shippingMethod.id
                )
            )
            
            _ = try await apiClient.performOperation(request)
            DispatchQueue.main.async {
                self.shippingMethodState = .loaded(shippingMethod)
                self._onShippingMethodTapped.send(shippingMethod)
            }
        } catch {
            DispatchQueue.main.async {
                self.shippingMethodState = .error(error)
            }
            print("[DispatchSDK] Error updating shipping method (\(shippingMethod.id) for \(orderId)")
        }
        
    }
}
