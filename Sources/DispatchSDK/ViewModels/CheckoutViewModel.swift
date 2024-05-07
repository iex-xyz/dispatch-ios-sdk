import Foundation
import Combine

internal class CheckoutViewModel: ObservableObject {
    internal enum State {
        case idle
        case loading
        case loaded(Checkout)
        case error(Error)
    }
    
    
    let _onMorePaymentMethodsButtonTapped = PassthroughSubject<Checkout, Never>()
    let _onSecureCheckoutButtonTapped = PassthroughSubject<Checkout, Never>()
    let _onAttributeTapped = PassthroughSubject<(Attribute, [Variation], Variation, Int), Never>()
    let _onLockButtonTapped = PassthroughSubject<Checkout, Never>()
    let _onPaymentCTATapped = PassthroughSubject<(Checkout, PaymentMethods), Never>()
    let _onCloseButtonTapped = PassthroughSubject<Void, Never>()
    let _onMoreProductInfoButtonTapped = PassthroughSubject<Checkout, Never>()

    @Published private(set) var state: State = .idle

    @Published var productViewModel: ProductViewModel? = nil
    
    @Published var checkout: Checkout? = nil {
        didSet {
            if productViewModel == nil, let product = checkout?.product {
                self.productViewModel = ProductViewModel(
                    product: product,
                    apiClient: apiClient
                )
            }
            guard let checkout else { return }
            self.selectedVariation = checkout.product.variations.first(where: {
                guard 
                    let quantityAvailable = $0.quantityAvailable,
                        quantityAvailable > 0
                else {
                    return false
                }
                
                return true
            })
            checkout.product.attributes?.values.forEach { attribute in
                self.selectedVariantMap[attribute.id] = .init(
                    attribute: attribute,
                    variations: checkout.product.variations,
                    currentQuantity: currentQuantity
                )
            }
        }
    }

    @Published var selectedVariantMap: [String: AttributeViewModel] = [:]
    @Published var selectedAt: Attribute? = nil
    @Published var selectedVariation: Variation? = nil

    @Published var selectedPaymentMethod: PaymentMethods = .creditCard
    @Published var enabledPaymentMethods: [PaymentMethods] = []
    @Published var paymentConfiguration: PaymentConfiguration? = nil {
        didSet {
            var paymentMethods: [PaymentMethods] = []
            #if DEBUG
            paymentMethods.append(.applePay)
            #endif
            if paymentConfiguration?.applePayEnabled == true {
                paymentMethods.append(.applePay)
            }
            
            if paymentConfiguration?.cardEnabled == true {
                paymentMethods.append(.creditCard)
            }
            self.enabledPaymentMethods = paymentMethods
            
            // TODO: We should make selectedPaymentMethod optional but will need to rework some things
            if !enabledPaymentMethods.contains(selectedPaymentMethod) {
                selectedPaymentMethod = enabledPaymentMethods.first ?? .creditCard
            }
        }
    }

    @Published var currentQuantity: Int = 1
    
    private let id: String
    
    var maxQuantity: Int {
        guard let product = checkout?.product else {
            return 0
        }
        
        if let selectedVariation {
            return Int(selectedVariation.quantityAvailable ?? 0)
        }
        
        return product.baseQuantity
    }

    private let apiClient: GraphQLClient
    
    init(id: String, apiClient: GraphQLClient) {
        self.id = id
        self.apiClient = apiClient

        Task {
            await fetchDistribution(for: id)
        }
    }
    
    func onIncreaseQuantityButtonTapped() {
        guard currentQuantity > 1 else {
            return
        }
        currentQuantity += 1
    }
    
    func onDecreateQuantityButtonTapped() {
        guard
            let maxQuantity = productViewModel?.currentMaxQuantity,
            currentQuantity < maxQuantity
        else {
            return
        }
        currentQuantity -= 1
    }
    
    func onAttributeTapped(_ attribute: Attribute) {
        guard let checkout, let selectedVariation else {
            return
        }
        
        let possibleVariations: [Variation] = checkout.product.variations.filter { variant in
            guard let attributes = selectedVariation.attributes else {
                return true
            }

            for (key, value) in attributes {
                if key != attribute.id, variant.attributes?[key] != value {
                    return false
                }
            }
            
            return true
        }
        
        _onAttributeTapped.send((attribute, possibleVariations, selectedVariation, currentQuantity))
    }
    
    func onVariationTapped(_ variation: Variation, for attributeId: String) {
        selectedVariantMap[attributeId]?.onVariationTapped(variation)
    }
    
    func onPaymentCTATapped() {
        guard let checkout else { return }
        _onPaymentCTATapped.send((checkout, selectedPaymentMethod))
    }
    
    private func updateCheckout(_ checkout: Checkout) {
        self.checkout = checkout
        self.productViewModel = .init(product: checkout.product, apiClient: apiClient)
    }
    
    func onMoreProductInfoButtonTapped() {
        guard let checkout else { return }
        _onMoreProductInfoButtonTapped.send(checkout)
    }
    func onCloseButtonTapped() {
        _onCloseButtonTapped.send()
    }

    func onLockButtonTapped() {
        guard let checkout else { return }
        _onLockButtonTapped.send(checkout)
    }
    
    func onMorePaymentMethodsButtonTapped() {
        guard let checkout else { return }
        _onMorePaymentMethodsButtonTapped.send(checkout)
    }
    
    func onSecureCheckoutButtonTapped() {
        guard let checkout else {
            return
        }
        _onSecureCheckoutButtonTapped.send(checkout)
    }
    
    func fetchDistribution(for id: String) async {
        Task {
            do {
                let request = GetDistributionRequest(id: id)
                let distribution = try await apiClient.performOperation(request)

                switch distribution {
                case .checkout(let checkout):
                    
                    let paymentMethodsRequest = GetMerchantPaymentMethodsRequest(
                        merchantId: checkout.merchantId
                    )
                    
                    let paymentConfiguration = try await apiClient.performOperation(paymentMethodsRequest)

                    DispatchQueue.main.async {
                        self.paymentConfiguration = paymentConfiguration
                        self.updateCheckout(checkout)
                    }
                case .content:
                    // TODO: Add support for 'content'
                    break
                case .leadgen:
                    // TODO: Add support for leadgen
                    break
                }
                
            } catch {
                print("[DispatchSDK] Error fetching distribution: \(error)")
            }
        }
    }
    
}
