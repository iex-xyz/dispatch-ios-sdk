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
    
    @Published var isEmailDirty: Bool = false
    @Published var isEmailValid: Bool = false

    let _onOrderInitiated = PassthroughSubject<(InitiateOrder, String), Never>()

    private let apiClient: GraphQLClient
    
    init(checkout: Checkout, variantId: String?, apiClient: GraphQLClient) {
        self.checkout = checkout
        self.variantId = variantId ?? ""
        self.apiClient = apiClient
        
        setupValidation()
    }

    
    func onContinueButtonTapped() {
        guard isEmailValid else { return }
        initiateOrder()
    }
    
    private func setupValidation() {
        $email
            .dropFirst()
            .map { _ in true }
            .assign(to: &$isEmailDirty)

        $email
            .map {
                do {
                    return try EmailValidator.validateEmail($0)
                } catch {
                    print("Unable to validate email", error)
                    return false
                }
            }
            .assign(to: &$isEmailValid)
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
                    self._onOrderInitiated.send((result, self.email))
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
