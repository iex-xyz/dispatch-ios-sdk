import Foundation

enum ProductType: String, Codable {
    case donation = "DONATION"
    case ebayRecommended = "EBAY_RECOMMENDED"
    case ebayRefurbished = "EBAY_REFURBISHED"
    case product = "PRODUCT"
}

extension ProductType {
    var renderedString: String {
        switch self {
        case .donation:
            "Donate"
        case .ebayRecommended:
            "Pay"
        case .ebayRefurbished:
            "Pay"
        case .product:
            "Pay"
        }
    }
    
    var renderedCTAString: String {
        switch self {
        case .donation:
            "Donate with"
        case .ebayRecommended:
            "Buy with"
        case .ebayRefurbished:
            "Buy with"
        case .product:
            "Buy with"
        }
    }
}
