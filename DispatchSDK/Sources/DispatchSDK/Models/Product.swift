import Foundation

public struct Product: Codable, Equatable {
    public let name: String
    public let description: String
    public let requiresShipping: Bool
    public let basePrice: Int
    public let baseCompareAtPrice: Int?
    public let baseImages: [String]
    public let pdpUrl: String
    public let baseQuantity: Int
    public let currencyCode: String
    public let attributes: [String: Attribute]?
    public let variations: [Variation]
    public let salesEnabled: Bool
    public let updatedAt: String
    public let createdAt: String
    public let descriptionHtml: String
    public let priceSubtitleText: String
    public let type: String
    public let productLanguage: String
    public let requiresBilling: Bool
    public let id: String
    
    public var pdpDomain: String? {
        return URL(string: pdpUrl)?.host
    }
    
    init(
        name: String,
        description: String,
        requiresShipping: Bool,
        basePrice: Int,
        baseCompareAtPrice: Int?,
        baseImages: [String],
        pdpUrl: String,
        baseQuantity: Int,
        currencyCode: String,
        attributes: [String: Attribute],
        variations: [Variation],
        salesEnabled: Bool,
        updatedAt: String,
        createdAt: String,
        descriptionHtml: String,
        priceSubtitleText: String,
        type: String,
        productLanguage: String,
        requiresBilling: Bool,
        id: String
    ) {
        self.name = name
        self.description = description
        self.requiresShipping = requiresShipping
        self.basePrice = basePrice
        self.baseCompareAtPrice = baseCompareAtPrice
        self.baseImages = baseImages
        self.pdpUrl = pdpUrl
        self.baseQuantity = baseQuantity
        self.currencyCode = currencyCode
        self.attributes = attributes
        self.variations = variations
        self.salesEnabled = salesEnabled
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.descriptionHtml = descriptionHtml
        self.priceSubtitleText = priceSubtitleText
        self.type = type
        self.productLanguage = productLanguage
        self.requiresBilling = requiresBilling
        self.id = id
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        requiresShipping = try container.decode(Bool.self, forKey: .requiresShipping)
        basePrice = try container.decode(Int.self, forKey: .basePrice)
        baseCompareAtPrice = try container.decodeIfPresent(Int.self, forKey: .baseCompareAtPrice)
        baseImages = try container.decode([String].self, forKey: .baseImages)
        pdpUrl = try container.decode(String.self, forKey: .pdpUrl)
        baseQuantity = try container.decode(Int.self, forKey: .baseQuantity)
        currencyCode = try container.decode(String.self, forKey: .currencyCode)
        attributes = try container.decodeIfPresent([String: Attribute].self, forKey: .attributes)
        variations = try container.decode([Variation].self, forKey: .variations)
        salesEnabled = try container.decode(Bool.self, forKey: .salesEnabled)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        descriptionHtml = try container.decode(String.self, forKey: .descriptionHtml)
        priceSubtitleText = try container.decode(String.self, forKey: .priceSubtitleText)
        type = try container.decode(String.self, forKey: .type)
        productLanguage = try container.decode(String.self, forKey: .productLanguage)
        requiresBilling = try container.decode(Bool.self, forKey: .requiresBilling)
        id = try container.decode(String.self, forKey: .id)
    }
}

public struct Attribute: Codable, Identifiable, Equatable {
    public let id: String
    public let title: String
    public var options: [String: AttributeOption]
    
    public init(
        id: String,
        title: String,
        options: [String: AttributeOption]
    ) {
        self.id = id
        self.title = title
        self.options = options
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        
        // Capture the parent key as the id using the decoder's codingPath
        if let lastKey = decoder.codingPath.last {
            id = lastKey.stringValue
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .id,
                in: container,
                debugDescription: "Unable to retrieve coding path to initialize Attribute id"
            )
        }

        let optionsContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var optionsDict = [String: AttributeOption]()

        for key in optionsContainer.allKeys {
            if key.stringValue != "title" {  // Skip known keys
                let option = try optionsContainer.decode(AttributeOption.self, forKey: key)
                optionsDict[key.stringValue] = option
            }
        }

        options = optionsDict
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        
        var optionsContainer = encoder.container(keyedBy: DynamicCodingKeys.self)
        for (key, value) in options {
            guard let codingKey = DynamicCodingKeys(stringValue: key) else {
                continue
            }
            try optionsContainer.encode(value, forKey: codingKey)
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
    }
    
    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            self.intValue = intValue
            self.stringValue = "\(intValue)"
        }
    }

}


public struct AttributeOption: Codable, Equatable {
    public var title: String
    public var images: [String]
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.images = try container.decodeIfPresent([String].self, forKey: .images) ?? []
    }
}

extension Product {
    public static func mock(
        name: String = "Product Name",
        description: String = "Product Description",
        requiresShipping: Bool = true,
        basePrice: Int = 9999,
        baseCompareAtPrice: Int? = 5555,
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
            baseCompareAtPrice: baseCompareAtPrice,
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
