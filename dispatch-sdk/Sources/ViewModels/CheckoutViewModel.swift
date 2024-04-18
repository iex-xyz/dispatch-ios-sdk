import Foundation
import Combine

internal class CheckoutViewModel: ObservableObject {
    internal enum State {
        case idle
        case loading
        case loaded(Checkout)
        case error(Error)
    }
    
    
    let _onSecureCheckoutButtonTapped = PassthroughSubject<Checkout, Never>()
    let _onAttributeTapped = PassthroughSubject<(AttributeViewModel), Never>()

    @Published private(set) var state: State = .idle

    @Published var productViewModel: ProductViewModel? = nil
    
    @Published var checkout: Checkout? = nil {
        didSet {
            if productViewModel == nil, let product = checkout?.product {
                self.productViewModel = ProductViewModel(product: product)
            }
            guard let checkout else { return }
            self.selectedVariant = checkout.product.variations.first
            checkout.product.attributes.values.forEach { attribute in
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
    @Published var selectedVariant: Variation? = nil

    @Published var currentQuantity: Int = 1
    
    var maxQuantity: Int {
        guard let product = checkout?.product else {
            return 0
        }
        
        if let selectedVariant {
            return Int(selectedVariant.quantityAvailable ?? 0)
        }
        
        return product.baseQuantity
    }

    private let apiClient: GraphQLClient = .init(
        networkService: RealNetworkService(),
        environment: .staging
    )
    
    init() {
        Task {
            // Checkout
//            await fetchDistribution(for: "65e6289c71acbac4d940c8ef")
            await fetchDistribution(for: "652ef22e5599070b1b8b9986")
//            await fetchDistribution(for: "661e8c14116bdd2bfe95eb29")
            // Content
//            await fetchDistribution(for: "64dabb5fa62014aafefbe89e")
            // Leadgen
//            await fetchDistribution(for: "65fb4a90149d4449c0190e3c")
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
        guard  let viewModel = selectedVariantMap[attribute.id] else { return }
        _onAttributeTapped.send(viewModel)
    }
    
    func onVariationTapped(_ variation: Variation, for attributeId: String) {
        selectedVariantMap[attributeId]?.onVariationTapped(variation)
    }
    
    private func updateCheckout(_ checkout: Checkout) {
        self.checkout = checkout
        self.productViewModel = .init(product: checkout.product)
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
