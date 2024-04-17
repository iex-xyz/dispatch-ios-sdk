import Foundation

struct Variation: Codable, Equatable, Identifiable, Hashable {
    let attributes: [String: String]?
    let compareAtPrice: Float?
    let externalVariantId: String?
    let id: String
    let maxPrice: Float?
    let price: Float?
    let quantityAvailable: Float?
    let strikethroughPrice: Float?
}

extension Variation {
    static func random(id: String = UUID().uuidString, quantityAvailable: Float = 10) -> Self {
        return Variation(
            attributes: ["color": "blue", "size": "large"],
            compareAtPrice: 100,
            externalVariantId: "123",
            id: id,
            maxPrice: 90,
            price: 80,
            quantityAvailable: quantityAvailable,
            strikethroughPrice: 70
        )
    }
}
