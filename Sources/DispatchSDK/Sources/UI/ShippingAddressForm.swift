import Combine
import SwiftUI

@available(iOS 15.0, *)
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
                FooterView()
            }
            .keyboardAvoiding()
            VStack(spacing: 32) {
                Button(action: {
                    viewModel.onContinueButtonTapped()
                }) {
                    Text("Continue")
                }
                .buttonStyle(PrimaryButtonStyle(isLoading: viewModel.isUpdatingOrder))
                .disabled(viewModel.isUpdatingOrder)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(theme.backgroundColor)
            .shadow(color: .black.opacity(0.1), radius: 32, y: -8)
        }
        .background(theme.backgroundColor)
        .colorScheme(theme.colorScheme)
    }
}

@available(iOS 15.0, *)
struct ShippingAddressForm: View {
    @Preference(\.theme) var theme
    @ObservedObject var viewModel: ShippingAddressViewModel
    @FocusState private var focusedField: FocusField?
    
    @State var showCountryPicker: Bool = false
    @State var query: String = ""
    @State var country: Country? = nil
    
    enum FocusField: Hashable {
        case firstName, lastName, address1, address2, city, state, zip, phone
    }
    var body: some View {
        VStack {
            CountryPickerControl(
                viewModel: viewModel.countriesViewModel,
                selectedCountry: $viewModel.country
            )
            TextField(viewModel.country.labels.firstName, text: $viewModel.firstName)
                .textContentType(.givenName)
                .focused($focusedField, equals: .firstName)
                .textFieldStyle(
                    ThemeTextFieldStyle(
                        isFocused: focusedField == .firstName,
                        isValid: !viewModel.isFirstNameDirty || viewModel.isFirstNameValid || focusedField == .firstName
                    )
                )
            TextField(viewModel.country.labels.lastName, text: $viewModel.lastName)
                .focused($focusedField, equals: .lastName)
                .textContentType(.familyName)
                .textFieldStyle(
                    ThemeTextFieldStyle(
                        isFocused: focusedField == .lastName,
                        isValid: !viewModel.isLastNameDirty || viewModel.isLastNameValid || focusedField == .lastName
                    )
                )
            TextField(viewModel.country.labels.address1, text: $viewModel.address1)
                .textContentType(.streetAddressLine1)
                .focused($focusedField, equals: .address1)
                .textFieldStyle(
                    ThemeTextFieldStyle(
                        isFocused: focusedField == .address1,
                        isValid: !viewModel.isAddress1Dirty || viewModel.isAddress1Valid || focusedField == .address1
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
            
            if viewModel.country.shouldShowField("address2") {
                TextField(viewModel.country.labels.address2, text: $viewModel.address2)
                    .textContentType(.streetAddressLine2)
                    .focused($focusedField, equals: .address2)
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: focusedField == .address2,
                            isValid: true
                        )
                    )
            }
            if viewModel.country.shouldShowField("city") {
                TextField(viewModel.country.labels.city, text: $viewModel.city)
                    .textContentType(.addressCity)
                    .focused($focusedField, equals: .city)
                    .textFieldStyle(
                        ThemeTextFieldStyle(
                            isFocused: focusedField == .city,
                            isValid: !viewModel.isCityDirty || viewModel.isCityValid || focusedField == .city
                        )
                    )
            }
            
            if viewModel.country.shouldShowField("zone") || viewModel.country.shouldShowField("zip") {
                HStack {
                    if viewModel.country.shouldShowField("zone") || !viewModel.country.zones.isEmpty {
                        ZonePickerControl(
                            country: viewModel.country,
                            zones: viewModel.country.zones,
                            selectedZone: $viewModel.zone
                        )
                    }
                    
                    if viewModel.country.shouldShowField("zip") {
                        TextField(viewModel.country.labels.postalCode, text: $viewModel.zip)
                            .textContentType(.postalCode)
                            .focused($focusedField, equals: .zip)
                            .textFieldStyle(
                                ThemeTextFieldStyle(
                                    isFocused: focusedField == .zip,
                                    isValid: !viewModel.isZipDirty || viewModel.isZipValid || focusedField == .zip
                                )
                            )
                    }
                }
            }
            PhoneNumberTextField(
                text: $viewModel.phone,
                country: $viewModel.country,
                isValid: !viewModel.isPhoneDirty || viewModel.isPhoneValid || focusedField == .phone,
                isFocused: focusedField == .phone
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
                        if viewModel.country.shouldShowField("address2") {
                            focusedField = .address2
                        } else {
                            focusedField = .address1
                        }
                    case .state:
                        focusedField = .city
                    case .zip:
                        if viewModel.country.shouldShowField("zone") {
                            focusedField = .state
                        } else if viewModel.country.shouldShowField("city") {
                            focusedField = .city
                        } else if viewModel.country.shouldShowField("address2") {
                            focusedField = .address2
                        } else {
                            focusedField = .address1
                        }
                    case .phone:
                        if viewModel.country.shouldShowField("zip") {
                            focusedField = .zip
                        } else if viewModel.country.shouldShowField("zone") {
                            focusedField = .state
                        } else if viewModel.country.shouldShowField("city") {
                            focusedField = .city
                        } else if viewModel.country.shouldShowField("address2") {
                            focusedField = .address2
                        } else {
                            focusedField = .address1
                        }
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
                        if viewModel.country.shouldShowField("address2") {
                            focusedField = .address2
                        } else if viewModel.country.shouldShowField("city") {
                            focusedField = .city
                        } else if viewModel.country.shouldShowField("zone") {
                            focusedField = .state
                        } else if viewModel.country.shouldShowField("zip") {
                            focusedField = .zip
                        } else {
                            focusedField = .phone
                        }
                    case .address2:
                        if viewModel.country.shouldShowField("city") {
                            focusedField = .city
                        } else if viewModel.country.shouldShowField("zone") {
                            focusedField = .state
                        } else if viewModel.country.shouldShowField("zip") {
                            focusedField = .zip
                        } else {
                            focusedField = .phone
                        }
                    case .city:
                        if viewModel.country.shouldShowField("zone") {
                            focusedField = .state
                        } else if viewModel.country.shouldShowField("zip") {
                            focusedField = .zip
                        } else {
                            focusedField = .phone
                        }
                    case .state:
                        if viewModel.country.shouldShowField("zip") {
                            focusedField = .zip
                        } else {
                            focusedField = .phone
                        }
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
        .colorScheme(theme.colorScheme)

    }
}

@available(iOS 15.0, *)
#Preview {
    let viewModel: ShippingAddressViewModel = .init(
        addressLookupService: MockAddressLookupService(),
        apiClient: .init(
            networkService: PreviewNetworkService(),
            environment: .staging
        ), 
        order: .mock()
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
