import Combine
import Foundation

class VariantPickerViewModel: ObservableObject {
    @Published var selectedVariation: Variation
    let attribute: Attribute
    let variations: [Variation]
    let quantity: Int
    let analyticsClient: AnalyticsClient

    init(
        attribute: Attribute,
        variations: [Variation],
        selectedVariation: Variation,
        analyticsClient: AnalyticsClient,
        quantity: Int
    ) {
        self.attribute = attribute
        self.variations = variations
        self.selectedVariation = selectedVariation
        self.analyticsClient = analyticsClient
        self.quantity = quantity
    }
    
    func onVariantTapped(_ variant: Variation) {
        self.selectedVariation = variant
        self.analyticsClient.send(event: .variantSelected_Checkout(attribute: variant.attributes ?? [:]))
    }
    
    func isVariationEnabled(_ variation: Variation) -> Bool {
        guard
            let quantityAvailable = variation.quantityAvailable
        else {
            return false
        }
        
        return Int(quantityAvailable) >= quantity
    }
}
