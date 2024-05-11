import SwiftUI

@available(iOS 15.0, *)
struct ContactInformationForm: View {
    @Preference(\.theme) var theme
    @Environment(\.dismiss) var dismiss
    @State var isCheckboxChecked: Bool = false
    @FocusState var isFocused: Bool
    @ObservedObject var viewModel: InitiateCreditCardCheckoutViewModel
    
    @State private var showError: Bool = false
    
    init(viewModel: InitiateCreditCardCheckoutViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Contact Information")
                .font(.title3.bold())
            
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
            .disabled(viewModel.orderState.isDisabled)
            .buttonStyle(
                PrimaryButtonStyle(
                    isLoading: viewModel.orderState.shouldShowSpinner
                )
            )
        }
        .padding()
        .background(theme.backgroundColor)
        .colorScheme(theme.colorScheme)
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.orderState.errorMessage ?? ""),
                dismissButton: .default(Text("Okay")) {
                    viewModel.orderState = .idle
                    viewModel.showError = false
                }
            )
        }
    }
}


@available(iOS 15.0, *)
struct ContactInformationForm_Preview: PreviewProvider {
    static let theme: Theme = .sharp
    static var previews: some View {
        @State var text: String = ""
        VStack {
            Spacer()
            ContactInformationForm(
                viewModel: .init(
                    checkout: .mock(),
                    variant: nil, 
                    quantity: 1,
                    apiClient: GraphQLClient(
                        networkService: PreviewNetworkService(),
                        environment: .staging
                    )
                )
            )
        }
        .padding()
        .previewDevice("iPhone 12")
    }
}

