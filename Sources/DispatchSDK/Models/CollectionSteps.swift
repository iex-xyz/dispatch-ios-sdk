import Foundation

struct CollectionSteps: Codable {
    let legalText: String?
    let recommendedProducts: [String]?
    let type: CollectionStep

    enum CodingKeys: String, CodingKey {
        case legalText
        case recommendedProducts
        case type
    }
}
