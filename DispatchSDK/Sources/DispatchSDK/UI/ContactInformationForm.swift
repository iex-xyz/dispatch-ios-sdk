import SwiftUI

struct ContactInformationForm: View {
    @Preference(\.theme) var theme
    @Environment(\.dismiss) var dismiss
    @State var isCheckboxChecked: Bool = false
    @FocusState var isFocused: Bool
    @ObservedObject var viewModel: InitiateCreditCardCheckoutViewModel
    
    init(viewModel: InitiateCreditCardCheckoutViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Contact Information")
                .font(.title3.bold())
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Please enter your email to continue.")
                    .font(.footnote)
                TextField(
                    "Email",
                    text: $viewModel.email
                )
                .placeholder(when: viewModel.email.isEmpty, placeholder: {
                    Text("your@gmail.com")
                        .foregroundColor(Colors.placeholderColor)
                })
                .autocorrectionDisabled()
                .foregroundStyle(.primary)
                .tint(Color.primary)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .focused($isFocused)
                .textFieldStyle(
                    ThemeTextFieldStyle(
                        isFocused: isFocused,
                        isValid: isFocused || viewModel.isEmailValid || !viewModel.isEmailDirty
                    )
                )
                .onAppear {
                    isFocused = true
                }
            }
            
            Toggle(isOn: $viewModel.hasAgreedToTerms, label: {
                Text("Allow \(viewModel.checkout.merchantName) to use this email address for marketing and newsletters.")
                    .font(.caption)
            })
            .toggleStyle(
                CheckboxToggleStyle(isValid: .constant(true))
            )
            Spacer()
            Button(action: {
                viewModel.onContinueButtonTapped()
            }) {
                Text("Continue")
            }
            .buttonStyle(
                PrimaryButtonStyle(
                    isLoading: viewModel.orderState.shouldShowSpinner
                )
            )
        }
        .padding()
        .background(theme.backgroundColor)
        .colorScheme(theme.colorScheme)
    }
}



struct ContactInformationForm_Preview: PreviewProvider {
    static let theme: Theme = .sharp
    static var previews: some View {
        @State var text: String = ""
        VStack {
            Spacer()
            ContactInformationForm(
                viewModel: .init(
                    checkout: .mock(),
                    variantId: "fake",
                    apiClient: GraphQLClient(
                        networkService: RealNetworkService(),
                        environment: .staging
                    )
                )
            )
        }
        .padding()
        .previewDevice("iPhone 12")
    }
}

