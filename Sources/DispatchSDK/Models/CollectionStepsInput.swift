import Foundation

struct CollectionStepsInput: Codable {
    let legalText: String?
    let promoCodes: [PromoCode]?
    let recommendedProducts: [String]?
    let type: CollectionStep

    enum CodingKeys: String, CodingKey {
        case legalText
        case promoCodes
        case recommendedProducts
        case type
    }
}
