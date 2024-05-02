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
    let _onPaymentCTATapped = PassthroughSubject<(Checkout, PaymentType), Never>()
    let _onCloseButtonTapped = PassthroughSubject<Void, Never>()
    let _onMoreProductInfoButtonTapped = PassthroughSubject<Checkout, Never>()

    @Published private(set) var state: State = .idle

    @Published var productViewModel: ProductViewModel? = nil
    
    @Published var checkout: Checkout? = nil {
        didSet {
            if productViewModel == nil, let product = checkout?.product {
                self.productViewModel = ProductViewModel(product: product)
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
    @Published var selectedPaymentMethod: PaymentType = .creditCard

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

    private let apiClient: GraphQLClient = .init(
        networkService: RealNetworkService(),
        environment: .staging
    )
    
    init(id: String) {
        self.id = id

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
        self.productViewModel = .init(product: checkout.product)
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
                    DispatchQueue.main.async {
                        self.updateCheckout(checkout)
                    }
                    print("Checkout: \(checkout.product)")
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
