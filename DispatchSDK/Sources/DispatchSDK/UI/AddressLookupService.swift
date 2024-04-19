enum AddressLookupError: Error {
    case unableToSearch(Error)
}

struct AddressLookupResult: Equatable {
    var street: String
    var city: String
    var state: String
    var postalCode: String
    var country: String
}

protocol AddressLookupService {
    func query(for address: String) async throws -> [AddressLookupResult]
}

class MockAddressLookupService: AddressLookupService {
    func query(for address: String) async throws -> [AddressLookupResult] {
        // Sleep for 1 second
        await Task.sleep(1_000_000_000)
        return [
            AddressLookupResult(street: "123 Main St", city: "Springfield", state: "IL", postalCode: "62701", country: "USA"),
            AddressLookupResult(street: "456 Elm St", city: "Springfield", state: "IL", postalCode: "62701", country: "USA"),
            AddressLookupResult(street: "789 Oak St", city: "Springfield", state: "IL", postalCode: "62701", country: "USA"),
        ]
    }
}
