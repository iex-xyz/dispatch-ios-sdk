import Combine
import SwiftUI


class CreditCardInputViewModel: ShippingAddressViewModel {
    @Published var cardNumber: String = ""
    @Published var cardType: CreditCardType?
    @Published var expirationDate: String = ""
    @Published var securityCode: String = ""

    @Published var billingAddressMatchesShipping: Bool = true
    
    @Published var isCardNumberDirty: Bool = false
    @Published var isExpirationDateDirty: Bool = false
    @Published var isSecurityCodeDirty: Bool = false
    
    @Published var isCardNumberValid: Bool = false
    @Published var isExpirationDateValid: Bool = false
    @Published var isSecurityCodeValid: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    override init(
        addressLookupService: any AddressLookupService,
        apiClient: GraphQLClient,
        orderId: String
    ) {
        super.init(
            addressLookupService: addressLookupService,
            apiClient: apiClient,
            orderId: orderId
        )
        setupCardValidationPublishers()
    }

    private func setupCardValidationPublishers() {
        // Card Number
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

        // Expiration Date
        $expirationDate
            .dropFirst()
            .map { date -> Bool in
                return true
//                date.map { CreditCardValidator.isDateValid($0) }// ?? false
            }
            .sink { [weak self] isValid in
                self?.isExpirationDateValid = isValid
                self?.isExpirationDateDirty = true
            }
            .store(in: &cancellables)

        // Security Code
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
        // TODO: Ensure validation
        // TODO: Where do we send credit card info via API?
    }
}
