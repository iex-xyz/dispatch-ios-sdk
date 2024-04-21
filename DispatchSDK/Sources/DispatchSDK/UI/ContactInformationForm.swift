import SwiftUI

struct ContactInformationForm: View {
    @Preference(\.theme) var theme
    @State var isCheckboxChecked: Bool = false
    @FocusState var isFocused: Bool
    @ObservedObject var viewModel: InitiateCreditCardCheckoutViewModel
    
    init(viewModel: InitiateCreditCardCheckoutViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("Contact Information")
                    .font(.title3.bold())
                Spacer()
                Button(action: {
                    
                }) {
                    Icons.close
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Please enter your email to continue.")
                    .font(.footnote)
                TextField("", text: $viewModel.email)
                    .tint(Colors.borderGray)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .focused($isFocused)
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: isFocused,
                            isValid: true
                        )
                    )
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
                    isLoading: false,
                    foregroundColor: .white,
                    backgroundColor: .blue
                )
            )
        }
        .padding()
        .background(Color(UIColor.systemBackground))
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

