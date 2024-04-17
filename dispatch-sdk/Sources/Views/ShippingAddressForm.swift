import SwiftUI

class ShippingAddressViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var address1: String = ""
    @Published var address2: String = ""
    @Published var city: String = ""
    @Published var state: String = ""
    @Published var zip: String = ""
    @Published var phone: String = ""
    
    
}

struct ShippingAddressForm: View {
    @ObservedObject var viewModel: ShippingAddressViewModel
    let theme: Theme = .soft
    @FocusState private var focusedField: FocusField?
    
    @State var showCountryPicker: Bool = false
    @State var query: String = ""

    enum FocusField: Hashable {
        case firstName, lastName, address1, address2, city, state, zip, phone
    }
    var body: some View {
        VStack {
            ScrollView {
                Button(action: {
                    showCountryPicker = true
                }) {
                    Text("Country")
                }
                .buttonStyle(SecondaryButtonStyle(theme: .round))
                .popover(isPresented: $showCountryPicker,
                         content: {
                    if #available(iOS 16.4, *) {
                        List {
                            TextField.init("Search", text: $query)
                                .textFieldStyle(
                                    ThemeTextFieldStyle(
                                        isFocused: focusedField == .city,
                                        isValid: .constant(true),
                                        theme: theme
                                    )
                                )
                            Text("United States")
                            Text("United States")
                            Text("United States")
                            Text("United States")
                            Text("United States")
                        }
                        .padding()
                        .frame(minWidth: 300, maxWidth: .infinity)
                        .presentationCompactAdaptation(.popover)
                    } else {
                        // Fallback on earlier versions
                    }
                })
                

                VStack {
                    TextField("First Name", text: $viewModel.firstName)
                        .textContentType(.givenName)
                        .focused($focusedField, equals: .firstName)
                        .textFieldStyle(
                            ThemeTextFieldStyle(
                                isFocused: $focusedField.wrappedValue == .firstName,
                                isValid: .constant(true),
                                theme: theme
                            )
                        )
                    TextField("Last Name", text: $viewModel.lastName)
                        .focused($focusedField, equals: .lastName)
                        .textContentType(.familyName)
                        .textFieldStyle(
                            ThemeTextFieldStyle(
                                isFocused: $focusedField.wrappedValue == .lastName,
                                isValid: .constant(true),
                                theme: theme
                            )
                        )
                    TextField("Address Line 1", text: $viewModel.address1)
                        .textContentType(.streetAddressLine1)
                        .focused($focusedField, equals: .address1)
                        .textFieldStyle(
                            ThemeTextFieldStyle(
                                isFocused: $focusedField.wrappedValue == .address1,
                                isValid: .constant(true),
                                theme: theme
                            )
                        )
                    TextField("Apartment, Suite, etc.", text: $viewModel.address2)
                        .textContentType(.streetAddressLine2)
                        .focused($focusedField, equals: .address2)
                        .textFieldStyle(
                            ThemeTextFieldStyle(
                                isFocused: $focusedField.wrappedValue == .address2,
                                isValid: .constant(true),
                                theme: theme
                            )
                        )
                    TextField("City", text: $viewModel.city)
                        .textContentType(.addressCity)
                        .focused($focusedField, equals: .city)
                        .textFieldStyle(
                            ThemeTextFieldStyle(
                                isFocused: $focusedField.wrappedValue == .city,
                                isValid: .constant(true),
                                theme: theme
                            )
                        )
                    HStack {
                        TextField("State", text: $viewModel.state)
                            .textContentType(.addressState)
                            .focused($focusedField, equals: .state)
                            .textFieldStyle(
                                ThemeTextFieldStyle(
                                    isFocused: $focusedField.wrappedValue == .state,
                                    isValid: .constant(true),
                                    theme: theme
                                )
                            )
                        TextField("ZIP", text: $viewModel.zip)
                            .textContentType(.postalCode)
                            .focused($focusedField, equals: .zip)
                            .textFieldStyle(
                                ThemeTextFieldStyle(
                                    isFocused: $focusedField.wrappedValue == .zip,
                                    isValid: .constant(true),
                                    theme: theme
                                )
                            )
                    }
                    TextField("Phone", text: $viewModel.phone)
                        .textContentType(.telephoneNumber)
                        .focused($focusedField, equals: .phone)
                        .textFieldStyle(
                            ThemeTextFieldStyle(
                                isFocused: $focusedField.wrappedValue == .phone,
                                isValid: .constant(true),
                                theme: theme
                            )
                        )
                }
            }
            Button(action: {}) {
                Text("Continue")
            }
            .buttonStyle(PrimaryButtonStyle(theme: .round, isLoading: false, isDisabled: false, foregroundColor: .white, backgroundColor: .blue))
        }
    }
}

#Preview {
    let viewModel: ShippingAddressViewModel = .init()
    return ZStack {
        ShippingAddressForm(
           viewModel: viewModel
       )
        .padding()
        .preferredColorScheme(.dark)
    }

}
