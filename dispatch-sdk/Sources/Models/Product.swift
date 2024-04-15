import Foundation

//struct Product: Codable {
//    let attributes: [String: JSONValue]? 
//    let baseCompareAtPrice: Float?
//    let baseImages: [String]
//    let basePrice: Float
//    let baseQuantity: Float?
//    let baseStrikethroughPrice: Float?
//    let currencyCode: Currencies
//    let description: String?
//    let descriptionHtml: String?
//    let hideCoverTransactionCosts: Bool?
//    let id: String
//    let merchantId: String?
//    let name: String
//    let pdpUrl: String?
//    let priceSubtitleText: String?
//    let productLanguage: ProductLanguage?
//    let requiresBilling: Bool?
//    let requiresShipping: Bool?
//    let salesEnabled: Bool
//    let type: ProductType?
//    let variations: [Variation]?
//}

struct Product: Codable {
    let name: String
    let description: String
    let requiresShipping: Bool
    let basePrice: Int
    let baseImages: [String]
    let pdpUrl: String
    let baseQuantity: Int
    let currencyCode: String
    let attributes: [String: Attribute]
    let variations: [Variation]
    let salesEnabled: Bool
    let updatedAt: String
    let createdAt: String
    let descriptionHtml: String
    let priceSubtitleText: String
    let type: String
    let productLanguage: String
    let requiresBilling: Bool
    let id: String
}

struct Attribute: Codable {
    let title: String
    let options: [String: AttributeOption]
    
    struct AttributeOption: Codable {
        let title: String
        let images: [String]
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        
        var optionsDict = [String: AttributeOption]()
        for key in container.allKeys {
            if key.stringValue != "title" {
                let option = try container.decode(AttributeOption.self, forKey: key)
                optionsDict[key.stringValue] = option
            }
        }
        options = optionsDict
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        
        for (key, value) in options {
            try container.encode(value, forKey: CodingKeys(stringValue: key)!)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title
    }
}


struct AttributeOption: Codable {
    let title: String
    let images: [String]
}


extension Product {
    static func mock(
        name: String = "Product Name",
        description: String = "Product Description",
        requiresShipping: Bool = true,
        basePrice: Int = 9999,
        baseImages: [String] = [
            "https://example.com/image1.jpg",
            "https://example.com/image2.jpg"
        ],
        pdpUrl: String = "https://example.com/product",
        currencyCode: String = "USD",
        salesEnabled: Bool = true,
        updatedAt: String = "2023-07-20T14:53:54.101Z",
        createdAt: String = "2023-07-20T14:53:54.066Z",
        descriptionHtml: String = "<p>Product Description</p>",
        priceSubtitleText: String = "Price Subtitle",
        type: String = "PRODUCT",
        variations: [Variation] = [],
        productLanguage: String = "EN",
        requiresBilling: Bool = true,
        id: String = UUID().uuidString
    ) -> Self {
        Product(
            name: name,
            description: description,
            requiresShipping: requiresShipping,
            basePrice: basePrice,
            baseImages: baseImages,
            pdpUrl: pdpUrl,
            baseQuantity: 1,
            currencyCode: currencyCode,
            attributes: [:],
            variations: variations, 
            salesEnabled: salesEnabled,
            updatedAt: updatedAt,
            createdAt: createdAt,
            descriptionHtml: descriptionHtml,
            priceSubtitleText: priceSubtitleText,
            type: type,
            productLanguage: productLanguage,
            requiresBilling: requiresBilling,
            id: id
        )
    }
}
