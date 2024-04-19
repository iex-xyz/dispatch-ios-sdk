import Foundation

public struct CollectionStepsInput: Codable {
    public let legalText: String?
    public let promoCodes: [PromoCode]?
    public let recommendedProducts: [String]?
    public let type: CollectionStep

    enum CodingKeys: String, CodingKey {
        case legalText
        case promoCodes
        case recommendedProducts
        case type
    }
}
