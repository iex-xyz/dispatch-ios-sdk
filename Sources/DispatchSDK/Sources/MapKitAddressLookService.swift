import MapKit

@available(iOS 15.0, *)
class MapKitAddressLookupService: AddressLookupService {
    func query(for address: String) async throws -> [AddressLookupResult] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address
        
        let search = MKLocalSearch(request: request)
        do {
            let response = try await search.start()
            return response.mapItems.map { item in
                AddressLookupResult(placemark: item.placemark)
            }
        } catch {
            print("[DispatchSDK] Failed to lookup address: \(error)")
            throw AddressLookupError.unableToSearch(error)
        }
    }
}

@available(iOS 15.0, *)
extension MKLocalSearchCompleter {
    func results(for query: String) async throws -> [MKLocalSearchCompletion] {
        self.queryFragment = query

        return try await withCheckedThrowingContinuation { continuation in
            let delegate = CompleterDelegate(completionHandler: { completions, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: completions ?? [])
                }
            })
            self.delegate = delegate
            // Keep a strong reference to the delegate to avoid deallocation
            objc_setAssociatedObject(self, &associationKey, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private var associationKey = 0

@available(iOS 15.0, *)
class CompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    var completionHandler: ([MKLocalSearchCompletion]?, Error?) -> Void

    init(completionHandler: @escaping ([MKLocalSearchCompletion]?, Error?) -> Void) {
        self.completionHandler = completionHandler
    }

    func completerDidUpdateResults(_ completer : MKLocalSearchCompleter) {
        completionHandler(completer.results, nil)
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        completionHandler(nil, error)
    }
}

@available(iOS 15.0, *)
extension AddressLookupResult {
    init(placemark: MKPlacemark) {
        address1 = (placemark.subThoroughfare ?? "") + " " + (placemark.thoroughfare ?? "")
        city = placemark.locality ?? ""
        state = placemark.administrativeArea ?? ""
        postalCode = placemark.postalCode ?? ""
        country = placemark.countryCode ?? ""
    }
}
