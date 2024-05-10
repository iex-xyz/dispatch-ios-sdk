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
        
        var shouldShowSpinner: Bool {
            switch self {
            case .loading:
                return true
            default:
                return false
            }
        }
    }
        
    let _onOrderUpdated = PassthroughSubject<(InitiateOrder, Address, String), Never>()

    @Published var addressLookupState: AddressLookupState = .idle
    @Published var countriesViewModel: CountriesViewModel

    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var address1: String = ""
    @Published var address2: String = ""
    @Published var city: String = ""
    @Published var zip: String = ""
    @Published var zone: Country.Zone = .empty
    @Published var phone: String = ""
    @Published var country: Country = .unitedStates {
        didSet {
            if !country.zones.contains(zone) {
                zone = .empty
            }
        }
    }

    @Published var isFirstNameValid = false
    @Published var isLastNameValid = false
    @Published var isAddress1Valid = false
    @Published var isCityValid = false
    @Published var isZoneValid = false
    @Published var isZipValid = false
    @Published var isPhoneValid = false
    
    @Published var isFirstNameDirty = false
    @Published var isLastNameDirty = false
    @Published var isAddress1Dirty = false
    @Published var isCityDirty = false
    @Published var isZoneDirty = false
    @Published var isZipDirty = false
    @Published var isPhoneDirty = false
    
    let order: InitiateOrder
    let apiClient: GraphQLClient
    
    @Published var isUpdatingOrder: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let addressLookupService: AddressLookupService
    
    init(
        addressLookupService: AddressLookupService,
        apiClient: GraphQLClient,
        order: InitiateOrder
    ) {
        self.addressLookupService = addressLookupService
        self.apiClient = apiClient
        self.order = order
        self.countriesViewModel = CountriesViewModel(apiClient: apiClient)
        setupValidation()
    }
    
    func onAddressLookupRowTapped(address: AddressLookupResult) {
        self.address1 = address.address1
        self.city = address.city
        self.zone = country.zones.first(where: { zone in
            zone.code.lowercased() == address.state.lowercased()
        }) ?? .empty
        self.zip = address.postalCode
        self.addressLookupState = .idle
    }

    private func setupValidation() {
        $firstName
            .dropFirst()
            .map { !$0.isEmpty && $0.count >= 2 }
            .assign(to: &$isFirstNameValid)

        $firstName
            .dropFirst()
            .map { _ in true }
            .assign(to: &$isFirstNameDirty)

        $lastName
            .dropFirst()
            .map { !$0.isEmpty && $0.count >= 2 }
            .assign(to: &$isLastNameValid)

        $lastName
            .dropFirst()
            .map { _ in true }
            .assign(to: &$isLastNameDirty)

        $address1
            .dropFirst()
            .map { !$0.isEmpty }
            .assign(to: &$isAddress1Valid)

        $address1
            .dropFirst()
            .map { _ in true }
            .assign(to: &$isAddress1Dirty)

        $city
            .dropFirst()
            .map { !$0.isEmpty }
            .assign(to: &$isCityValid)

        $city
            .dropFirst()
            .map { _ in true }
            .assign(to: &$isCityDirty)

        $zone
            .map { !$0.code.isEmpty || self.country.zones.isEmpty || !self.country.shouldShowField("zone") }
            .assign(to: &$isZoneValid)

        $zone
            .dropFirst()
            .map { _ in true }
            .assign(to: &$isZoneDirty)

        $zip
            .dropFirst()
            .map { zip in
                zip.isEmpty == false || !self.country.shouldShowField("zip")
            }
            .assign(to: &$isZipValid)

        $zip
            .dropFirst()
            .map { _ in true }
            .assign(to: &$isZipDirty)

        $phone
            .dropFirst()
            .map { phone in
                PhoneNumberValidator.validatePhoneNumber(phone, country: self.country)
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
    
    func onContinueButtonTapped() {
        guard
            !isUpdatingOrder,
            isAddress1Valid,
            isCityValid,
            isZoneValid,
            isZipValid,
            isPhoneValid
        else {
            return
        }
        Task {
            // NOTE: We optimistically set the billing address here to save a round trip
            // on the billing form if the user's shipping and billing match. Otherwise we
            // will need to update the billing address separately
            await updateOrderAddress(using: .shippingAndBilling)
        }
    }

    private func updateOrderAddress(using updateType: UpdateOrderShippingRequest.UpdateShippingType) async {
        DispatchQueue.main.async {
            self.isUpdatingOrder = true
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                let request = UpdateOrderShippingRequest(
                    params: .init(
                        orderId: self.order.id,
                        firstName: self.firstName,
                        lastName: self.lastName,
                        address1: self.address1,
                        address2: self.address2,
                        city: self.city,
                        state: self.zone.code,
                        zip: self.zip,
                        phoneNumber: self.phone,
                        country: self.country.code,
                        email: nil,
                        updateType: updateType
                    )
                )
                
                let response = try await apiClient.performOperation(request)
                
                let address: Address = .init(
                    address1: address1,
                    address2: address2,
                    city: city,
                    state: zone.code,
                    zip: zip,
                    country: self.country.code
                )
                DispatchQueue.main.async {
                    self.isUpdatingOrder = false
                    self._onOrderUpdated.send((response, address, self.phone))
                }
            } catch {
                DispatchQueue.main.async {
                    self.isUpdatingOrder = false
                }
                print("[DispatchSDK] Error updating order address: \(error)")
            }
        }
    }

}

