import MapKit

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
            print("Failed to lookup address: \(error)")
            throw AddressLookupError.unableToSearch(error)
        }
    }
}


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


class LocalMapKitAddressLookupService: NSObject, AddressLookupService {
    var continuation: CheckedContinuation<[AddressLookupResult], Error>?

    func query(for address: String) async throws -> [AddressLookupResult] {
        
        return try await withCheckedThrowingContinuation { continuation in
            // Store the continuation to be resumed later
            self.continuation = continuation
            
            let completer = MKLocalSearchCompleter()
            completer.queryFragment = address
        }

//        let completions = try await completer.results(for: address)
//        var results: [AddressLookupResult] = []

//        for completion in completions {
//            let searchRequest = MKLocalSearch.Request(completion: completion)
//            let search = MKLocalSearch(request: searchRequest)
//            do {
//                let response = try await search.start()
//                results.append(contentsOf: response.mapItems.map { item in
//                    AddressLookupResult(placemark: item.placemark)
//                })
//            } catch {
//                print("Failed to complete details for completion: \(error)")
//                continue
//            }
//        }
//        return results
    }
}

extension LocalMapKitAddressLookupService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer : MKLocalSearchCompleter) {
//        completer.results.map { }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {

    }
}


extension AddressLookupResult {
    init(placemark: MKPlacemark) {
        address1 = (placemark.subThoroughfare ?? "") + " " + (placemark.thoroughfare ?? "")
        city = placemark.locality ?? ""
        state = placemark.administrativeArea ?? ""
        postalCode = placemark.postalCode ?? ""
        country = placemark.countryCode ?? ""
    }
}
