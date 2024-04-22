import Combine
import SwiftUI

struct ShippingAddressFormContainer: View {
    @Preference(\.theme) var theme
    @ObservedObject var viewModel: ShippingAddressViewModel

    var body: some View {
        VStack {
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
        Button(action: {
            showCountryPicker = true
        }) {
            Text("Country")
        }
        .buttonStyle(SecondaryButtonStyle())
        .popover(isPresented: $showCountryPicker,
                 content: {
            if #available(iOS 16.4, *) {
                List {
                    TextField.init("Search", text: $query)
                        .textFieldStyle(
                            ThemeTextFieldStyle(
                                isFocused: focusedField == .city,
                                isValid: true
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
                TextField("State", text: $viewModel.state)
                    .textContentType(.addressState)
                    .focused($focusedField, equals: .state)
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: $focusedField.wrappedValue == .state,
                            isValid: !viewModel.isStateDirty || viewModel.isStateValid || $focusedField.wrappedValue == .state
                        )
                    )
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
            TextField("Phone", text: $viewModel.phone)
                .textContentType(.telephoneNumber)
                .focused($focusedField, equals: .phone)
                .textFieldStyle(
                    ThemeTextFieldStyle(
                        isFocused: $focusedField.wrappedValue == .phone,
                        isValid: !viewModel.isPhoneDirty || viewModel.isPhoneValid || $focusedField.wrappedValue == .phone
                    )
                )
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
