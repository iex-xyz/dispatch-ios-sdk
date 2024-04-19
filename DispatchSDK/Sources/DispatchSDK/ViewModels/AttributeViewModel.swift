import Foundation

internal class AttributeViewModel: ObservableObject, Identifiable {
    var id: String {
        attribute.id
    }

    @Published private(set) var attribute: Attribute
    @Published private(set) var selectedValueText: String = ""
    @Published private(set) var variations: [Variation]

    @Published private(set) var selectedVariant: Variation? = nil
//    {
//        didSet {
//            self.selectedValueText = selectedVariant?.attributes?[attribute.id] ?? ""
//        }
//    }
    
    init(attribute: Attribute, variations: [Variation], currentQuantity: Int) {
        self.attribute = attribute
        self.variations = variations.filter { $0.attributes?[attribute.id] != nil }
        self.selectedVariant = self.variations.first
    }
    
    func onVariationTapped(_ variation: Variation) {
        self.selectedVariant = variation
        print("Selected variant", selectedVariant?.id)
    }
    
    func title(for variation: Variation) -> String {
        return variation.attributes?[attribute.id] ?? "none"
    }
}

