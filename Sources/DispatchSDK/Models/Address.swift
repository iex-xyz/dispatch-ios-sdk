import Foundation

struct Address {
    let address1: String
    let address2: String?
    let city: String
    let state: String
    let zip: String
    let country: String
}

extension Address {
    var formattedString: String {
        let normalizedAddress2 = address2?.isEmpty == true ? nil : address2
        return [address1, normalizedAddress2, "\(city), \(state) \(zip)"]
            .compactMap { $0 }
            .joined(separator: "\n")
    }
}

extension Address {
    static func mock(
        address1: String = "23 Court Sq",
        address2: String? = "923",
        city: String = "Long Island City",
        state: String = "NY",
        zip: String = "11101"
    ) -> Address {
        .init(
            address1: address1,
            address2: address2,
            city: city,
            state: state,
            zip: zip,
            country: "US"
        )
    }
}

