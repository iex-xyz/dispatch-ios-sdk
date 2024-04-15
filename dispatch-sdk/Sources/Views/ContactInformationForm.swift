import SwiftUI

struct ContactInformationForm: View {
    let theme: Theme
    @State var isCheckboxChecked: Bool = false
    @FocusState var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text("Contact Information")
                    .font(.title3.bold())
                Spacer()
                Button(action: {
                    
                }) {
                    Image(systemName: "x.square")
                        .foregroundStyle(.primary)
                        .font(.title)
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Please enter your email to continue.")
                    .font(.footnote)
                TextField("your@email.com", text: .constant(""))
                    .focused($isFocused)
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: isFocused,
                            isValid: .constant(true),
                            theme: theme
                        )
                    )
            }
            
            Toggle(isOn: $isCheckboxChecked, label: {
                Text("Allow |merchantName| to use this email address for marketing and newsletters.")
                    .font(.caption)
            })
            .toggleStyle(
                CheckboxToggleStyle(
                    isValid: .constant(true),
                    theme: theme
                )
            )
            
            Button(action: {
                
            }) {
                Text("Continue")
            }
            .buttonStyle(
                PrimaryButtonStyle(
                    theme: theme,
                    isLoading: false,
                    isDisabled: false,
                    foregroundColor: .white,
                    backgroundColor: .blue
                )
            )
        }
    }
}



struct ContactInformationForm_Preview: PreviewProvider {
    static let theme: Theme = .sharp
    static var previews: some View {
        @State var text: String = ""
        VStack {
            Spacer()
            ContactInformationForm(theme: theme)
        }
        .padding()
        .previewDevice("iPhone 12")
    }
}

