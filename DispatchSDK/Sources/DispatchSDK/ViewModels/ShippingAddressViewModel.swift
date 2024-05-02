import Foundation
import Combine

class CountriesViewModel: ObservableObject {

    enum State {
        case idle
        case loading
        case complete([Country])
        case failed(Error)
        
        var countries: [Country] {
            switch self {
            case let .complete(countries):
                return countries
            default:
                return []
            }
        }
        
        var isEnabled: Bool {
            switch self {
            case .complete, .failed:
                return true
            default:
                return false
            }
        }
    }
    
    @Published var state: State = .idle
    
    let apiClient: GraphQLClient
    
    init(apiClient: GraphQLClient) {
        self.apiClient = apiClient
        
        fetchCountries()
    }

    func fetchCountries() {
        self.state = .loading
        Task {
            do {
                let request = GetCountriesRequest(locale: "en") // TODO: https://github.com/iex-xyz/frontend-monorepo/blob/development/apps/checkout/i18n/i18n.ts#L16
                let response = try await apiClient.performOperation(request)
                
                DispatchQueue.main.async {
                    self.state = .complete(response.countries)
                }
            } catch {
                print("Unable to fetch countries list: ", error)
                DispatchQueue.main.async {
                    self.state = .failed(error)
                }
            }
        }
    }
}

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
        
    let _onOrderUpdated = PassthroughSubject<(InitiateOrder, Address, String), Never>()

    @Published var addressLookupState: AddressLookupState = .idle
    @Published var countriesViewModel: CountriesViewModel

    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var address1: String = ""
    @Published var address2: String = ""
    @Published var city: String = ""
    @Published var state: String = ""
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
        self.state = address.state
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

        $state
            .dropFirst()
            .map { !$0.isEmpty || self.country.zones.isEmpty || !self.country.shouldShowField("zone") }
            .assign(to: &$isStateValid)

        $state
            .dropFirst()
            .map { _ in true }
            .assign(to: &$isStateDirty)

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
        // TODO: Form validation
        guard
            !isUpdatingOrder,
            isAddress1Valid,
            isCityValid,
            isStateValid,
            isZipValid,
            isPhoneValid
        else {
            return
        }
        Task {
            // NOTE: We optimistically set the billing address here to save a round trip
            // on the billing form if the user's shipping and billing match. Otherwise we
            // will need to update the billing address separately
            // TODO: Can this potentially bite us when editing the form?
            await updateOrderAddress(using: .shippingAndBilling)
        }
    }

    private func updateOrderAddress(using updateType: UpdateOrderShippingRequest.UpdateShippingType) async {
        self.isUpdatingOrder = true
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
                print("Error updating order address: \(error)")
            }
        }
    }

}

