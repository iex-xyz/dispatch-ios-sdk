import Foundation

internal class ProductViewModel: ObservableObject {
    @Published var product: Product
    @Published var selectedVariantMap: [String: AttributeViewModel] = [:]
    @Published var currentAttributePicker: Attribute? = nil
    @Published var selectedVariantId: String? = nil
    @Published var currentQuantity: Int = 1

    
    var currentMaxQuantity: Int {
        guard
            let selectedVariant = product.variations.first(where: { variation in
            variation.id == selectedVariantId
        }), 
            let quantityAvailable = selectedVariant.quantityAvailable
        else {
            return product.baseQuantity
        }

        return Int(quantityAvailable)
    }

    private let apiClient: GraphQLClient
    
    init(
        product: Product,
        apiClient: GraphQLClient
    ) {
        self.product = product
        self.apiClient = apiClient

        product.attributes?.values.forEach { attribute in
            if selectedVariantMap[attribute.id] == nil {
                selectedVariantMap[attribute.id] = AttributeViewModel(
                    attribute: attribute,
                    variations: product.variations,
                    currentQuantity: product.baseQuantity
                )
            }
        }
    }
    
    func onIncreaseQuantityButtonTapped() {
        guard currentQuantity > 1 else {
            return
        }
        currentQuantity += 1
    }
    
    func onDecreateQuantityButtonTapped() {
        guard currentQuantity < currentMaxQuantity else { return }
        currentQuantity -= 1
    }
    
    func setCurrentAttributePicker(_ attribute: Attribute?) {
        self.currentAttributePicker = attribute
    }
    
    func onVariationTapped(_ variation: Variation, for attributeId: String) {
        selectedVariantMap[attributeId]?.onVariationTapped(variation)
    }

}
