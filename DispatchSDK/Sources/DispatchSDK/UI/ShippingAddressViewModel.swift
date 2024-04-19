import Foundation
import Combine

class ShippingAddressViewModel: ObservableObject {
    enum AddressLookupState {
        case idle
        case loading
        case complete([AddressLookupResult])
        case failed(Error)
        
        var hasResults: Bool {
            switch self {
            case let .complete(results):
                return !results.isEmpty
            default:
                return false
            }
        }
    }
        

    @Published var addressLookupState: AddressLookupState = .idle

    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var address1: String = ""
    @Published var address2: String = ""
    @Published var city: String = ""
    @Published var state: String = ""
    @Published var zip: String = ""
    @Published var phone: String = ""
    
    @Published var isFirstNameValid = false
    @Published var isLastNameValid = false
    @Published var isAddress1Valid = false
    @Published var isCityValid = false
    @Published var isStateValid = false
    @Published var isZipValid = false
    @Published var isPhoneValid = false
    
    @Published var isFirstNameDirty = false
    @Published var isLastNameDirty = false
    @Published var isAddress1Dirty = false
    @Published var isCityDirty = false
    @Published var isStateDirty = false
    @Published var isZipDirty = false
    @Published var isPhoneDirty = false
    
    private var cancellables = Set<AnyCancellable>()
    private let addressLookupService: AddressLookupService
    
    init(addressLookupService: AddressLookupService) {
        self.addressLookupService = addressLookupService
        setupValidation()
    }

    private func setupValidation() {
        // FirstName Validation
        $firstName
            .dropFirst()
            .map { !$0.isEmpty && $0.count >= 2 }
            .assign(to: &$isFirstNameValid)

        $firstName
            .dropFirst()
            .map { _ in true }
            .assign(to: &$isFirstNameDirty)

        // LastName Validation
        $lastName
            .dropFirst()
            .map { !$0.isEmpty && $0.count >= 2 }
            .assign(to: &$isLastNameValid)

        $lastName
            .dropFirst()
            .map { _ in true }
            .assign(to: &$isLastNameDirty)

        // Address1 Validation
        $address1
            .dropFirst()
            .map { !$0.isEmpty }
            .assign(to: &$isAddress1Valid)

        $address1
            .dropFirst()
            .map { _ in true }
            .assign(to: &$isAddress1Dirty)

        // City Validation
        $city
            .dropFirst()
            .map { !$0.isEmpty }
            .assign(to: &$isCityValid)

        $city
            .dropFirst()
            .map { _ in true }
            .assign(to: &$isCityDirty)

        // State Validation
        $state
            .dropFirst()
            .map { !$0.isEmpty && $0.count == 2 }
            .assign(to: &$isStateValid)

        $state
            .dropFirst()
            .map { _ in true }
            .assign(to: &$isStateDirty)

        // ZIP Code Validation
        $zip
            .dropFirst()
            .map { zip in
                let zipRegex = "^[0-9]{5}(-[0-9]{4})?$"
                return NSPredicate(format: "SELF MATCHES %@", zipRegex).evaluate(with: zip)
            }
            .assign(to: &$isZipValid)

        $zip
            .dropFirst()
            .map { _ in true }
            .assign(to: &$isZipDirty)

        // Phone Number Validation
        $phone
            .dropFirst()
            .map { phone in
                let phoneRegex = "^\\d{3}-\\d{3}-\\d{4}$"
                return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
            }
            .assign(to: &$isPhoneValid)

        $phone
            .dropFirst()
            .map { _ in true }
            .assign(to: &$isPhoneDirty)

        $address1
            .removeDuplicates()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] address in
                guard let self = self, !address.isEmpty else {
                    self?.addressLookupState = .idle
                    return
                }
                self.performLookup(address: address)
            }
            .store(in: &cancellables)
    }
    
    private func performLookup(address: String) {
        addressLookupState = .loading
        Task {
            do {
                let results = try await self.addressLookupService.query(for: address)
                DispatchQueue.main.async {
                    self.addressLookupState = .complete(results)
                }
            } catch {
                DispatchQueue.main.async {
                    self.addressLookupState = .failed(error)
                }
            }
        }
    }


}

