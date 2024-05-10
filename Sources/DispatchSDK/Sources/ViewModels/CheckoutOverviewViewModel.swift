import Foundation
import Combine
import UIKit

class CheckoutOverviewViewModel: ObservableObject {
    enum OrderCheckoutState {
        case idle
        case loading
        case complete(InitiateOrder)
        case failed(Error)
        
        var isEnabled: Bool {
            switch self {
            case .idle, .failed, .complete: return true
            case .loading: return false
            }
        }
        
        var isLoading: Bool {
            switch self {
            case .idle, .failed, .complete: return false
            case .loading: return true
            }
        }
    }
    
    @Published var state: OrderCheckoutState = .idle
    
    let apiClient: GraphQLClient
    let analyticsClient: AnalyticsClient
    let checkout: Checkout
    let email: String
    let variant: Variation?
    let phone: String
    let shippingAddress: Address
    let billingAddress: Address?
    let billingInfo: BillingInfo
    let shippingMethod: ShippingMethod
    let tokenizedPayment: String
    let paymentMethods: [PaymentMethods]
    let order: InitiateOrder
    
    let _onShippingMethodTapped = PassthroughSubject<(ShippingMethod), Never>()
    let _onShippingAddressTapped = PassthroughSubject<(Address), Never>()
    let _onPaymentDetailsTapped = PassthroughSubject<(Address), Never>()
    let _onEmailTapped = PassthroughSubject<(String), Never>()
    let _onPhoneTapped = PassthroughSubject<(String), Never>()

    let _onOrderComplete = PassthroughSubject<(InitiateOrder), Never>()

    init(
        apiClient: GraphQLClient,
        analyticsClient: AnalyticsClient,
        checkout: Checkout,
        order: InitiateOrder,
        email: String,
        variant: Variation?,
        phone: String,
        shippingAddress: Address,
        billingAddress: Address?,
        billingInfo: BillingInfo,
        shippingMethod: ShippingMethod,
        paymentMethods: [PaymentMethods],
        tokenizedPayment: String
    ) {
        self.apiClient = apiClient
        self.analyticsClient = analyticsClient
        self.checkout = checkout
        self.order = order
        self.email = email
        self.variant = variant
        self.phone = phone
        self.shippingAddress = shippingAddress
        self.billingAddress = billingAddress
        self.billingInfo = billingInfo
        self.shippingMethod = shippingMethod
        self.paymentMethods = paymentMethods
        self.tokenizedPayment = tokenizedPayment
    }
    
    func onPayButtonTapped() {
        DispatchQueue.main.async {
            self.state = .loading
        }
        Task {
            do {
                let order = try await completeOrder()
                DispatchQueue.main.async {
                    self.analyticsClient.send(event: .paymentSent_Checkout)
                    self.state = .complete(order)
                    self._onOrderComplete.send(order)
                }
            } catch {
                print("[DispatchSDK] Unable to complete order", error)
                DispatchQueue.main.async {
                    self.analyticsClient.send(event: .paymentFailed_Checkout)
                    self.state = .failed(error)
                }
            }
        }
    }

    func onTermsButtonTapped() {
        if
            let url = URL(string: checkout.merchantTermsUrl),
            UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url)
        }

        analyticsClient.send(event: .termsClicked_Checkout)
    }
    
    private func completeOrder() async throws -> InitiateOrder {
        let request = CompleteOrderRequest(orderId: order.id, tokenizedPayment: tokenizedPayment)
        return try await apiClient.performOperation(request)
    }
}
