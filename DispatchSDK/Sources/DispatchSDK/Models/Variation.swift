import Foundation

public struct Variation: Codable, Equatable, Identifiable, Hashable {
    public let attributes: [String: String]?
    public let compareAtPrice: Float?
    public let externalVariantId: String?
    public let id: String
    public let maxPrice: Float?
    public let price: Float?
    public let quantityAvailable: Float?
    public let strikethroughPrice: Float?
}

extension Variation {
    public static func random(id: String = UUID().uuidString, quantityAvailable: Float = 10) -> Self {
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
