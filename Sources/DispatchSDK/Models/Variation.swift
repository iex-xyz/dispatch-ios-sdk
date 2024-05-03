import Foundation

public struct Variation: Codable, Equatable, Identifiable, Hashable {
    public let attributes: [String: String]?
    public let compareAtPrice: Int?
    public let externalVariantId: String?
    public let id: String
    public let maxPrice: Float?
    public let price: Int?
    public let quantityAvailable: Float?
    public let strikethroughPrice: Float?
    
    public init(
        attributes: [String : String]? = nil,
        compareAtPrice: Int? = nil,
        externalVariantId: String? = nil,
        id: String,
        maxPrice: Float? = nil,
        price: Int? = nil,
        quantityAvailable: Float? = nil,
        strikethroughPrice: Float? = nil
    ) {
        self.attributes = attributes
        self.compareAtPrice = compareAtPrice
        self.externalVariantId = externalVariantId
        self.id = id
        self.maxPrice = maxPrice
        self.price = price
        self.quantityAvailable = quantityAvailable
        self.strikethroughPrice = strikethroughPrice
    }
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
