import Foundation

struct Address {
    let address1: String
    let address2: String?
    let city: String
    let state: String
    let zip: String
}

extension Address {
    var formattedString: String {
        return [address1, address2, "\(city), \(state) \(zip)"]
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
            zip: zip
        )
    }
}

