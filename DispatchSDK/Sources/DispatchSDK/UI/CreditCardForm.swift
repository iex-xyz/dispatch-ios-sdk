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
    @Published var expirationDate: Date = .now
    @Published var securityCode: String = ""

    @Published var billingAddressMatchesShipping: Bool = true
    
    @Published var isCardNumberDirty: Bool = false
    @Published var isExpirationDateDirty: Bool = false
    @Published var isSecurityCodeDirty: Bool = false
    
    @Published var isCardNumberValid: Bool = false
    @Published var isExpirationDateValid: Bool = false
    @Published var isSecurityCodeValid: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    override init(addressLookupService: AddressLookupService) {
        super.init(addressLookupService: addressLookupService)
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
}
struct CreditCardForm: View {
    @Preference(\.theme) var theme
    @ObservedObject var viewModel: CreditCardInputViewModel
    @FocusState private var focusedField: FocusField?
    
    @State var showCountryPicker: Bool = false
    @State var query: String = ""
    
    var validDateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .month, value: 0, to: Date())!
        let endDate = calendar.date(byAdding: .year, value: 30, to: startDate)!
        return startDate...endDate
    }
    enum FocusField: Hashable {
        case cardNumber, expiry, securityCode
    }
    var body: some View {
        VStack {
            ScrollView {
                
                
                VStack {
                    CreditCardTextField(text: $viewModel.cardNumber)
                        .textContentType(.creditCardNumber)
                        .focused($focusedField, equals: .cardNumber)
                        .textFieldStyle(
                            ThemeTextFieldStyle(
                                isFocused: $focusedField.wrappedValue == .cardNumber,
                                isValid: !viewModel.isCardNumberDirty || viewModel.isCardNumberValid || $focusedField.wrappedValue == .cardNumber
                            )
                        )
                    HStack {
                        TextField("Expiry", text: $viewModel.cardNumber)
                            .focused($focusedField, equals: .expiry)
                            .textFieldStyle(
                                ThemeTextFieldStyle(
                                    isFocused: $focusedField.wrappedValue == .expiry,
                                    isValid: !viewModel.isExpirationDateDirty || viewModel.isExpirationDateValid || $focusedField.wrappedValue == .expiry,
                                    labelText: "Expiry"

                                )
                            )
                            .keyboardType(.numbersAndPunctuation)

                        TextField("Security Code", text: $viewModel.securityCode)
                            .focused($focusedField, equals: .securityCode)
                            .textFieldStyle(
                                ThemeTextFieldStyle(
                                    isFocused: $focusedField.wrappedValue == .securityCode,
                                    isValid: !viewModel.isSecurityCodeDirty || viewModel.isSecurityCodeValid || $focusedField.wrappedValue == .securityCode,
                                    labelText: "Security Code"
                                )
                            )
                            .keyboardType(.numberPad)
                    }
                    
                    Toggle("Same as Shipping", isOn: $viewModel.billingAddressMatchesShipping)
                        .padding()
                    
                    if !viewModel.billingAddressMatchesShipping {
                        ShippingAddressForm(viewModel: viewModel)
                    }
                }
            }
            VStack(spacing: 32) {
                Button(action: {}) {
                    Text("Continue")
                }
                .buttonStyle(PrimaryButtonStyle(isLoading: false))
                FooterView()
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .colorScheme(theme.colorScheme)
    }
}

#Preview {
    let viewModel: CreditCardInputViewModel = .init(addressLookupService: MockAddressLookupService())
    @Preference(\.theme) var theme
    return ZStack {
        CreditCardForm(
            viewModel: viewModel
        )
        .onAppear {
            theme = .mock(ctaStyle: .sharp, inputStyle: .sharp)//, mode: .dark)
        }
    }
    
}
