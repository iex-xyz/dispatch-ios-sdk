import UIKit
import SwiftUI
import Combine

class InitiateCreditCardCheckoutViewModel: ObservableObject {
    internal enum State {
        case idle
        case loading
        case loaded(InitiateOrder)
        case error(Error)
        
        var shouldShowSpinner: Bool {
            if case .loading = self {
                return true
            } else {
                return false
            }
        }
    }

    let checkout: Checkout
    let variantId: String

    @Published var hasAgreedToTerms: Bool = false
    @Published var email: String = ""
    @Published var orderState: State = .idle
    
    @Published var isEmailValid: Bool = false

    let _onOrderInitiated = PassthroughSubject<InitiateOrder, Never>()

    private let apiClient: GraphQLClient
    
    init(checkout: Checkout, variantId: String?, apiClient: GraphQLClient) {
        self.checkout = checkout
        self.variantId = variantId ?? ""
        self.apiClient = apiClient
    }

    
    func onContinueButtonTapped() {
//        guard hasAgreedToTerms, isEmailValid else { return }
        initiateOrder()
    }
    
    private func initiateOrder() {
        orderState = .loading
        Task { [weak self] in
            guard let self else { return }
            do {
                let request =  InitiateOrderRequest(
                    email: email,
                    productId: checkout.product.id,
                    variantId: variantId
                )
                let result = try await apiClient.performOperation(request)

                DispatchQueue.main.async {
                    self.orderState = .loaded(result)
                    self._onOrderInitiated.send(result)
                }

            } catch {
                DispatchQueue.main.async {
                    print("[ERROR] Unable to initiate order: \(error)")
                    self.orderState = .error(error)
                }
            }
        }
    }
}
