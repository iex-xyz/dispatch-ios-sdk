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
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Card Number")
                            .foregroundStyle(.primary)
                            .font(.footnote)
                            .frame(alignment: .leading)

                        CreditCardTextField(text: $viewModel.cardNumber)
                            .textContentType(.creditCardNumber)
                            .focused($focusedField, equals: .cardNumber)
                            .textFieldStyle(
                                ThemeTextFieldStyle(
                                    isFocused: $focusedField.wrappedValue == .cardNumber,
                                    isValid: !viewModel.isCardNumberDirty || viewModel.isCardNumberValid || $focusedField.wrappedValue == .cardNumber
                                )
                            )
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Exp. Date")
                                .foregroundStyle(.primary)
                                .font(.footnote)
                                .frame(alignment: .leading)

                            ExpirationDateTextField(text: $viewModel.expirationDate)
                                .frame(height: 48)
                                .focused($focusedField, equals: .expiry)
                                .keyboardType(.numberPad)
                        }

                        TextField("Security Code", text: $viewModel.securityCode)
                            .focused($focusedField, equals: .securityCode)
                            .textFieldStyle(
                                ThemeTextFieldStyle(
                                    isFocused: $focusedField.wrappedValue == .securityCode,
                                    isValid: !viewModel.isSecurityCodeDirty || viewModel.isSecurityCodeValid || $focusedField.wrappedValue == .securityCode,
                                    labelText: "CVC"
                                )
                            )
                            .keyboardType(.numberPad)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Billing Address")
                            .foregroundStyle(.primary)
                            .font(.footnote)
                            .frame(alignment: .leading)
                        Toggle("Same as Shipping", isOn: $viewModel.billingAddressMatchesShipping)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Colors.controlBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Colors.borderGray, lineWidth: 2)
                            )
                    }

                    if !viewModel.billingAddressMatchesShipping {
                        ShippingAddressForm(viewModel: viewModel)
                    }
                }
                .padding()
            }
            VStack(spacing: 32) {
                Button(action: {
                    viewModel.onContinueButtonTapped()
                }) {
                    Text("Continue")
                }
                .buttonStyle(PrimaryButtonStyle(isLoading: false))
                FooterView()
            }
            .padding()
        }
        .background(theme.backgroundColor)
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
