import Foundation

struct ShippingMethod: Codable, Identifiable {
    let id: String
    let estimatedTimeInTransit: [Float]?
    let handle: String
    let phoneRequired: Bool
    let price: Int
    let title: String
    
    init(
        estimatedTimeInTransit: [Float],
        handle: String,
        id: String,
        phoneRequired: Bool,
        price: Int,
        title: String
    ) {
        self.estimatedTimeInTransit = estimatedTimeInTransit
        self.handle = handle
        self.id = id
        self.phoneRequired = phoneRequired
        self.price = price
        self.title = title
    }

    enum CodingKeys: String, CodingKey {
        case estimatedTimeInTransit
        case handle
        case id
        case phoneRequired
        case price
        case title
    }

    // Custom init from decoder if needed, especially for handling nullable arrays or transforming units
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.handle = try container.decode(String.self, forKey: .handle)
        self.id = try container.decode(String.self, forKey: .id)
        self.phoneRequired = try container.decode(Bool.self, forKey: .phoneRequired)
        self.price = try container.decode(Int.self, forKey: .price)
        self.title = try container.decode(String.self, forKey: .title)
        // Handle optional array of Floats
        self.estimatedTimeInTransit = try container.decodeIfPresent([Float].self, forKey: .estimatedTimeInTransit)
    }

    // Encode function is standard unless specific custom behavior is needed
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(handle, forKey: .handle)
        try container.encode(id, forKey: .id)
        try container.encode(phoneRequired, forKey: .phoneRequired)
        try container.encode(price, forKey: .price)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(estimatedTimeInTransit, forKey: .estimatedTimeInTransit)
    }
}

extension ShippingMethod {
    static func random(
        estimatedTimeInTransit: [Float] = [],
        handle: String = "handle",
        id: String = UUID().uuidString,
        phoneRequired: Bool = false,
        price: Int = 0,
        title: String = "title"
    ) -> Self {
        ShippingMethod(
            estimatedTimeInTransit: estimatedTimeInTransit,
            handle: handle,
            id: id,
            phoneRequired: phoneRequired,
            price: price,
            title: title
        )
    }
}
