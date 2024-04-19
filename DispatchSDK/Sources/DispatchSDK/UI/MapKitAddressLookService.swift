import MapKit

class MapKitAddressLookupService: AddressLookupService {
    func query(for address: String) async throws -> [AddressLookupResult] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address
        
        let search = MKLocalSearch(request: request)
        do {
            let response = try await search.start()
            return response.mapItems.map { item in
                AddressLookupResult(
                    street: item.placemark.thoroughfare ?? "",
                    city: item.placemark.locality ?? "",
                    state: item.placemark.administrativeArea ?? "",
                    postalCode: item.placemark.postalCode ?? "",
                    country: item.placemark.country ?? ""
                )
            }
        } catch {
            print("Failed to lookup address: \(error)")
            throw AddressLookupError.unableToSearch(error)
        }
    }
}

