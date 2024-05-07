import Foundation


struct Product: Codable, Equatable {
    let name: String
    let description: String
    let requiresShipping: Bool
    let basePrice: Int
    let baseCompareAtPrice: Int?
    let baseImages: [String]
    let pdpUrl: String?
    let baseQuantity: Int
    let currencyCode: String
    let attributes: [String: Attribute]?
    let variations: [Variation]
    let salesEnabled: Bool
    let updatedAt: String
    let createdAt: String
    let descriptionHtml: String
    let priceSubtitleText: String
    let type: ProductType
    let productLanguage: String
    let requiresBilling: Bool
    let id: String
    
    var pdpDomain: String? {
        guard let pdpUrl, let url = URL(string: pdpUrl) else { return nil }
        return url.host?.replacingOccurrences(of: "www.", with: "")
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
        type: ProductType,
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        requiresShipping = try container.decode(Bool.self, forKey: .requiresShipping)
        basePrice = try container.decode(Int.self, forKey: .basePrice)
        baseCompareAtPrice = try container.decodeIfPresent(Int.self, forKey: .baseCompareAtPrice)
        baseImages = try container.decode([String].self, forKey: .baseImages)
        pdpUrl = try container.decodeIfPresent(String.self, forKey: .pdpUrl)
        baseQuantity = try container.decodeIfPresent(Int.self, forKey: .baseQuantity) ?? 1
        currencyCode = try container.decode(String.self, forKey: .currencyCode)
        attributes = try container.decodeIfPresent([String: Attribute].self, forKey: .attributes)
        variations = try container.decode([Variation].self, forKey: .variations)
        salesEnabled = try container.decode(Bool.self, forKey: .salesEnabled)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        descriptionHtml = try container.decode(String.self, forKey: .descriptionHtml)
        priceSubtitleText = try container.decode(String.self, forKey: .priceSubtitleText)
        type = try container.decode(ProductType.self, forKey: .type)
        productLanguage = try container.decode(String.self, forKey: .productLanguage)
        requiresBilling = try container.decode(Bool.self, forKey: .requiresBilling)
        id = try container.decode(String.self, forKey: .id)
    }
}

struct Attribute: Codable, Identifiable, Equatable {
    let id: String
    let title: String
    var options: [String: AttributeOption]
    
    init(
        id: String,
        title: String,
        options: [String: AttributeOption]
    ) {
        self.id = id
        self.title = title
        self.options = options
    }

    init(from decoder: Decoder) throws {
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

    func encode(to encoder: Encoder) throws {
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


struct AttributeOption: Codable, Equatable {
    var title: String
    var images: [String]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.images = try container.decodeIfPresent([String].self, forKey: .images) ?? []
    }
}

extension Product {
    static func mock(
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
        type: ProductType = .product,
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
