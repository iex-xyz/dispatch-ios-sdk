import Foundation

public struct CollectionSteps: Codable {
    public let legalText: String?
    public let recommendedProducts: [String]?
    public let type: CollectionStep

    enum CodingKeys: String, CodingKey {
        case legalText
        case recommendedProducts
        case type
    }
}
