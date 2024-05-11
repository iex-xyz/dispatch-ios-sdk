enum AddressLookupError: Error {
    case unableToSearch(Error)
}

@available(iOS 15.0, *)
struct AddressLookupResult: Equatable, Identifiable {
    var id: String {
        "\(address1), \(city), \(state) \(postalCode), \(country)"
    }
    var address1: String
    var city: String
    var state: String
    var postalCode: String
    var country: String
    
    init(address1: String, city: String, state: String, postalCode: String, country: String) {
        self.address1 = address1
        self.city = city
        self.state = state
        self.postalCode = postalCode
        self.country = country
    }
    
}

@available(iOS 15.0, *)
protocol AddressLookupService {
    func query(for address: String) async throws -> [AddressLookupResult]
}

@available(iOS 15.0, *)
class MockAddressLookupService: AddressLookupService {
    func query(for address: String) async throws -> [AddressLookupResult] {
        // Sleep for 1 second
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return [
            AddressLookupResult(
                address1: "123 Main St",
                city: "Springfield",
                state: "IL",
                postalCode: "62701",
                country: "USA"
            ),
            AddressLookupResult(
                address1: "456 Elm St",
                city: "Springfield",
                state: "IL",
                postalCode: "62701",
                country: "USA"
            ),
            AddressLookupResult(
                address1: "789 Oak St",
                city: "Springfield",
                state: "IL",
                postalCode: "62701",
                country: "USA"
            ),
        ]
    }
}
