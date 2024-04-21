import Combine
import SwiftUI

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
    let viewModel: CreditCardInputViewModel = .init(
        addressLookupService: MockAddressLookupService(),
        apiClient: GraphQLClient(networkService: RealNetworkService(), environment: .staging),
        orderId: UUID().uuidString
    )
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
