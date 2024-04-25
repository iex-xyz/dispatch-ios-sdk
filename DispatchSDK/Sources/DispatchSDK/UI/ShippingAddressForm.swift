import Combine
import SwiftUI

struct ShippingAddressFormContainer: View {
    @Preference(\.theme) var theme
    @ObservedObject var viewModel: ShippingAddressViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Shipping Address")
                .font(.title3.bold())
                .padding(.horizontal)

            ScrollView {
                ShippingAddressForm(viewModel: viewModel)
                    .padding()
            }
            VStack(spacing: 32) {
                Button(action: {
                    viewModel.onContinueButtonTapped()
                }) {
                    Text("Continue")
                }
                .buttonStyle(PrimaryButtonStyle(isLoading: viewModel.isUpdatingOrder))
                FooterView()
            }
            .padding()
        }
        .background(theme.backgroundColor)
        .colorScheme(theme.colorScheme)
    }
}

struct ShippingAddressForm: View {
    @Preference(\.theme) var theme
    @ObservedObject var viewModel: ShippingAddressViewModel
    @FocusState private var focusedField: FocusField?
    
    @State var showCountryPicker: Bool = false
    @State var query: String = ""
    
    enum FocusField: Hashable {
        case firstName, lastName, address1, address2, city, state, zip, phone
    }
    var body: some View {
        VStack {
            TextField("First Name", text: $viewModel.firstName)
                .textContentType(.givenName)
                .focused($focusedField, equals: .firstName)
                .textFieldStyle(
                    ThemeTextFieldStyle(
                        isFocused: $focusedField.wrappedValue == .firstName,
                        isValid: !viewModel.isFirstNameDirty || viewModel.isFirstNameValid || $focusedField.wrappedValue == .firstName
                    )
                )
            TextField("Last Name", text: $viewModel.lastName)
                .focused($focusedField, equals: .lastName)
                .textContentType(.familyName)
                .textFieldStyle(
                    ThemeTextFieldStyle(
                        isFocused: $focusedField.wrappedValue == .lastName,
                        isValid: !viewModel.isLastNameDirty || viewModel.isLastNameValid || $focusedField.wrappedValue == .lastName
                    )
                )
            TextField("Address Line 1", text: $viewModel.address1)
                .textContentType(.streetAddressLine1)
                .focused($focusedField, equals: .address1)
                .textFieldStyle(
                    ThemeTextFieldStyle(
                        isFocused: $focusedField.wrappedValue == .address1,
                        isValid: !viewModel.isAddress1Dirty || viewModel.isAddress1Valid || $focusedField.wrappedValue == .address1
                    )
                )
            if focusedField == .address1 {
                switch viewModel.addressLookupState {
                case .idle:
                    EmptyView()
                case .loading:
                    ProgressView()
                        .progressViewStyle(StrokedCircularProgressViewStyle())
                        .padding()
                case .complete(let results):
                    VStack(spacing: 8) {
                        ForEach(results.prefix(3)) { result in
                            Button(action: {
                                withAnimation(.interactiveSpring) {
                                    self.focusedField = .phone
                                    self.viewModel.onAddressLookupRowTapped(address: result)
                                }
                            }) {
                                ShippingAddressRow(address: result)
                            }
                            .foregroundStyle(.primary)
                            
                        }
                    }
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Colors.borderGray, lineWidth: 2))
                case .failed(_):
                    EmptyView()
                }
            }
            
            TextField("Apartment, Suite, etc.", text: $viewModel.address2)
                .textContentType(.streetAddressLine2)
                .focused($focusedField, equals: .address2)
                .textFieldStyle(
                    ThemeTextFieldStyle(
                        isFocused: $focusedField.wrappedValue == .address2,
                        isValid: true
                    )
                )
            TextField("City", text: $viewModel.city)
                .textContentType(.addressCity)
                .focused($focusedField, equals: .city)
                .textFieldStyle(
                    ThemeTextFieldStyle(
                        isFocused: $focusedField.wrappedValue == .city,
                        isValid: !viewModel.isCityDirty || viewModel.isCityValid || $focusedField.wrappedValue == .city
                    )
                )
            HStack {
                StatePickerControl(state: $viewModel.state)
                TextField("ZIP", text: $viewModel.zip)
                    .textContentType(.postalCode)
                    .focused($focusedField, equals: .zip)
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: $focusedField.wrappedValue == .zip,
                            isValid: !viewModel.isZipDirty || viewModel.isZipValid || $focusedField.wrappedValue == .zip
                        )
                    )
            }
            PhoneNumberTextField(
                text: $viewModel.phone,
                isValid: viewModel.isPhoneValid
            )
                .focused($focusedField, equals: .phone)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button(action: {
                    switch focusedField {
                    case .firstName:
                        break
                    case .lastName:
                        focusedField = .firstName
                    case .address1:
                        focusedField = .lastName
                    case .address2:
                        focusedField = .address1
                    case .city:
                        focusedField = .address2
                    case .state:
                        focusedField = .city
                    case .zip:
                        focusedField = .state
                    case .phone:
                        focusedField = .zip
                    case nil:
                        break
                    }
                }) {
                    Image(systemName: "chevron.up")
                }
                Button(action: {
                    switch focusedField {
                    case .firstName:
                        focusedField = .lastName
                    case .lastName:
                        focusedField = .address1
                    case .address1:
                        focusedField = .address2
                    case .address2:
                        focusedField = .city
                    case .city:
                        focusedField = .state
                    case .state:
                        focusedField = .zip
                    case .zip:
                        focusedField = .phone
                    case .phone:
                        break
                    case nil:
                        break
                    }

                }) {
                    Image(systemName: "chevron.down")
                }
                Spacer()
            }
        }

    }
}

#Preview {
    let viewModel: ShippingAddressViewModel = .init(
        addressLookupService: MockAddressLookupService(),
        apiClient: .init(
            networkService: RealNetworkService(),
            environment: .staging
        ), 
        orderId: UUID().uuidString
    )
    @Preference(\.theme) var theme
    return ZStack {
        ShippingAddressFormContainer(
            viewModel: viewModel
        )
        .onAppear {
            theme = .mock(ctaStyle: .sharp, inputStyle: .sharp)//, mode: .dark)
        }
    }
    
}
