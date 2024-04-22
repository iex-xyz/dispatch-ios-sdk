import Combine
import SwiftUI

class CreditCardValidator {
    static func validateCardNumber(_ number: String) -> Bool {
        // Implement validation logic
        return number.count >= 16 // Simplistic example
    }

    static func detectCardType(from number: String) -> CreditCardType? {
        // Simplistic detection logic
        if number.starts(with: "4") {
            return .visa
        } else if number.starts(with: "5") {
            return .masterCard
        }
        // Add more detection rules
        return nil
    }
    
    static func validateSecurityCode(_ code: String) -> Bool {
        return code.count == 3 || code.count == 4
    }
    
    static func isDateValid(_ date: Date) -> Bool {
        return date > Date() // The date should be in the future
    }
}

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
                CreditCardValidator.validateSecurityCode(code)
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
