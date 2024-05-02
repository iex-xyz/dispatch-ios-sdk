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
        
        var isDisabled: Bool {
            switch self {
            case .loading, .loaded:
                return true
            case .error, .idle:
                return false
            }
        }

    }

    let checkout: Checkout
    let variant: Variation?

    @Published var hasAgreedToTerms: Bool = false
    @Published var email: String = ""
    @Published var orderState: State = .idle
    
    @Published var isEmailDirty: Bool = false
    @Published var isEmailValid: Bool = false
    
    let quantity: Int

    let _onOrderInitiated = PassthroughSubject<(InitiateOrder, String), Never>()

    private let apiClient: GraphQLClient
    
    init(checkout: Checkout, variant: Variation?, quantity: Int, apiClient: GraphQLClient) {
        self.checkout = checkout
        self.variant = variant
        self.quantity = quantity
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
    
    private func updateQuantity(for orderId: String) async throws -> UpdateOrderQuantityRequest.Response {
        let request = UpdateOrderQuantityRequest(
            params: .init(
                orderId: orderId,
                productId: checkout.product.id,
                quantity: quantity
            )
        )

        return try await apiClient.performOperation(request)
    }
    
    private func initiateOrder() {
        orderState = .loading
        Task { [weak self] in
            guard let self else { return }
            do {
                let request =  InitiateOrderRequest(
                    email: email,
                    productId: checkout.product.id,
                    variantId: variant?.id,
                    quantity: quantity
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
