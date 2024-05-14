import Combine
import SwiftUI

@available(iOS 15.0, *)
class CreditCardInputViewModel: ShippingAddressViewModel {
    @Published var cardNumber: String = ""
    @Published var cardType: CreditCardType?
    @Published var expirationDate: String = ""
    @Published var securityCode: String = ""

    @Published var billingAddressMatchesShipping: Bool = true
    @Published var isUpdatingBillingAddress: Bool = false
    @Published var isGeneratingPaymentToken: Bool = false

    @Published var isCardNumberDirty: Bool = false
    @Published var isExpirationDateDirty: Bool = false
    @Published var isSecurityCodeDirty: Bool = false
    
    @Published var isCardNumberValid: Bool = false
    @Published var isExpirationDateValid: Bool = false
    @Published var isSecurityCodeValid: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []

    let _onPaymentTokenGenerated = PassthroughSubject<(String, Address, BillingInfo), Never>()

    override init(
        addressLookupService: any AddressLookupService,
        apiClient: GraphQLClient,
        order: InitiateOrder
    ) {
        super.init(
            addressLookupService: addressLookupService,
            apiClient: apiClient,
            order: order
        )
        setupCardValidationPublishers()
    }

    private func setupCardValidationPublishers() {
        $cardNumber
            .dropFirst() // Avoid initial value
            .map { number -> (CreditCardType?, Bool) in
                let isValid = CreditCardValidator.validateCardNumber(number)
                let type = CreditCardValidator.detectCardType(from: number)
                return (type, isValid)
            }
            .sink { [weak self] (type, isValid) in
                self?.cardType = type
                self?.isCardNumberValid = isValid
                self?.isCardNumberDirty = true
            }
            .store(in: &cancellables)

        $expirationDate
            .dropFirst()
            .map { date -> Bool in
                ExpirationDateValidator.validateExpirationDate(date)
            }
            .sink { [weak self] isValid in
                self?.isExpirationDateValid = isValid
                self?.isExpirationDateDirty = true
            }
            .store(in: &cancellables)

        $securityCode
            .dropFirst()
            .map { code in
                guard let cardType = self.cardType else { return false }
                return CreditCardValidator.validateSecurityCode(code, cardType: cardType)
            }
            .sink { [weak self] isValid in
                self?.isSecurityCodeValid = isValid
                self?.isSecurityCodeDirty = true
            }
            .store(in: &cancellables)
    }
    
    override func onContinueButtonTapped() {
        guard
            !isGeneratingPaymentToken,
            !isUpdatingBillingAddress,
            isCardNumberValid,
            isExpirationDateValid,
            isSecurityCodeValid,
            (billingAddressMatchesShipping || (
                isAddress1Valid &&
                isCityValid &&
                isZoneValid &&
                isZipValid &&
                isPhoneValid
            ))
        else {
            return
        }
        
        self.isGeneratingPaymentToken = true
        Task {
            do {
                // NOTE: We only need to update billing address if it does not match shipping
                // since we pass ADDRESS_SHIPPING_AND_BILLING when setting our shipping address
                if !billingAddressMatchesShipping {
                    try await updateBillingAddress()
                }
                try await generatePaymentToken()
            } catch {
                print("Unable to generate payment token", error)
                DispatchQueue.main.async {
                    self.isGeneratingPaymentToken = false
                }
            }
        }
    }
    
    private func updateBillingAddress() async throws {
        let params = UpdateOrderShippingRequest.RequestParams(
            orderId: order.id,
            firstName: firstName,
            lastName: lastName,
            address1: address1,
            address2: address2,
            city: city,
            state: zone.code,
            zip: zip,
            phoneNumber: phone,
            country: country.code,
            email: nil,
            updateType: .billing
        )
        let request = UpdateOrderShippingRequest(params: params)
        _ = try await apiClient.performOperation(request)
    }
    
    private func generatePaymentToken() async throws {
        let expirationComponents = expirationDate.split(separator: "/")
        guard
            expirationComponents.count == 2,
            let expirationMonth = expirationComponents.first,
            let expirationYear = expirationComponents.last
        else {
            // TODO: Better error handling
            return
        }
        DispatchQueue.main.async {
            self.isGeneratingPaymentToken = true
        }

        let request = GetPaymentTokenRequest(
            orderId: order.id,
            cardNumber: cardNumber,
            expirationMonth: String(expirationMonth),
            expirationYear: String(expirationYear),
            cvc: securityCode
        )
        
        let response = try await apiClient.performOperation(request)
        let address = Address(
            address1: address1,
            address2: address2,
            city: city,
            state: zone.code,
            zip: zip,
            country: country.code
        )
        
        let billingInfo = BillingInfo(cardPreview: String(cardNumber.suffix(4)), cardType: cardType ?? .visa)
        DispatchQueue.main.async {
            self._onPaymentTokenGenerated.send((response.paymentToken, address, billingInfo))
            self.isGeneratingPaymentToken = false
        }
    }
}
