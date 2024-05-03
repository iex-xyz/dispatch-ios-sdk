import Foundation

struct ShippingMethod: Codable, Identifiable {
    let id: String
    let estimatedTimeInTransit: [Int]?
    let handle: String
    let phoneRequired: Bool
    let price: Int
    let title: String
    
    init(
        estimatedTimeInTransit: [Int],
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.handle = try container.decode(String.self, forKey: .handle)
        self.id = try container.decode(String.self, forKey: .id)
        self.phoneRequired = try container.decode(Bool.self, forKey: .phoneRequired)
        self.price = try container.decode(Int.self, forKey: .price)
        self.title = try container.decode(String.self, forKey: .title)
        self.estimatedTimeInTransit = try container.decodeIfPresent([Int].self, forKey: .estimatedTimeInTransit)
    }

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
    static private let formatter = DateFormatter()

    func getEstimatedArrivalDateText() -> String? {
        guard
            let estimatedTimeInTransit = estimatedTimeInTransit,
                estimatedTimeInTransit.count == 2
        else {
            return nil
        }
        
        let SECONDS_IN_DAY = 86_400
        let maxDays = Int(ceil(Double(estimatedTimeInTransit[1]) / Double(SECONDS_IN_DAY)))
        let now = Date()
        var components = DateComponents()
        components.day = maxDays
        let futureDate = Calendar.current.date(byAdding: components, to: now)!
        
        Self.formatter.locale = Locale(identifier: "en_US")
        Self.formatter.dateFormat = "MMMM d, EEE"
        let deliveryDate = Self.formatter.string(from: futureDate)
        
        return "Delivery by \(deliveryDate)"
    }
}


extension ShippingMethod {
    static func random(
        estimatedTimeInTransit: [Int] = [],
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
