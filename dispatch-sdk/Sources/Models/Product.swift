import Foundation

struct Product: Codable {
    let attributes: [String: JSONValue]? 
    let baseCompareAtPrice: Float?
    let baseImages: [String]
    let basePrice: Float
    let baseQuantity: Float?
    let baseStrikethroughPrice: Float?
    let currencyCode: Currencies
    let description: String?
    let descriptionHtml: String?
    let hideCoverTransactionCosts: Bool?
    let id: String
    let merchantId: String?
    let name: String
    let pdpUrl: String?
    let priceSubtitleText: String?
    let productLanguage: ProductLanguage?
    let requiresBilling: Bool?
    let requiresShipping: Bool?
    let salesEnabled: Bool
    let type: ProductType?
    let variations: [Variation]?
}
