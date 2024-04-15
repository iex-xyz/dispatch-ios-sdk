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

    enum FocusField: Hashable {
        case firstName, lastName, address1, address2, city, state, zip, phone
    }
    var body: some View {
        VStack {
            Button(action: {}) {
                
            }
            
            TextField("First Name", text: $viewModel.firstName)
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
                .textFieldStyle(
                    ThemeTextFieldStyle(
                        isFocused: $focusedField.wrappedValue == .lastName,
                        isValid: .constant(true),
                        theme: theme
                    )
                )
            TextField("Address Line 1", text: $viewModel.address1)
                .focused($focusedField, equals: .address1)
                .textFieldStyle(
                    ThemeTextFieldStyle(
                        isFocused: $focusedField.wrappedValue == .address1,
                        isValid: .constant(true),
                        theme: theme
                    )
                )
            TextField("Apartment, Suite, etc.", text: $viewModel.address2)
                .focused($focusedField, equals: .address2)
                .textFieldStyle(
                    ThemeTextFieldStyle(
                        isFocused: $focusedField.wrappedValue == .address2,
                        isValid: .constant(true),
                        theme: theme
                    )
                )
            TextField("City", text: $viewModel.city)
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
                    .focused($focusedField, equals: .state)
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: $focusedField.wrappedValue == .state,
                            isValid: .constant(true),
                            theme: theme
                        )
                    )
                TextField("ZIP", text: $viewModel.zip)
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
