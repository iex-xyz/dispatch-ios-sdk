import Foundation
import PassKit

struct PaymentJson: Codable {
    let signature: String
    let version: String
    let data: String
    let header: Header
    
    struct Header: Codable {
        let ephemeralPublicKey: String
        let publicKeyHash: String
        let transactionId: String
        
        var stringValue: String {
            let encoder = JSONEncoder()
//            encoder.outputFormatting = .prettyPrinted
            guard let data = try? encoder.encode(self), let jsonString = String(data: data, encoding: .utf8) else {
                return ""
            }
            return jsonString
        }
    }
}


class ApplePayViewModel: NSObject, ObservableObject {
    internal enum State {
        case idle
        case initiatingOrder
        case fetchingShippingMethods(InitiateOrder)
        case loaded(InitiateOrder, [ShippingMethod])
        case error(Error)
        
//        var shouldShowSpinner: Bool {
//            if case .loading = self {
//                return true
//            } else {
//                return false
//            }
//        }
//        
//        var isDisabled: Bool {
//            switch self {
//            case .initiatingOrder, .fetchingShippingMethods:
//                return true
//            case .error, .idle:
//                return false
//            }
//        }
//        
//        var errorMessage: String? {
//            switch self {
//            case let .error(error):
//                if let error = error as? GraphQLError {
//                    return error.description
//                } else {
//                    return "Something went wrong"
//                }
//            default:
//                return nil
//            }
//        }

    }


    let paymentRequest: PKPaymentRequest
    let content: Checkout

    @Published var state: State = .idle

    private let apiClient: GraphQLClient
    private let quantity: Int
    private var order: InitiateOrder?
    private let selectedVariant: Variation?

    private var selectedContact: PKContact?
    private var selectedPaymentMethod: PKPaymentMethod?
    private var selectedShippingMethod: PKShippingMethod?


    private(set) var supportedNetworks: [PKPaymentNetwork] = []
    private(set) var shippingMethods: [PKShippingMethod] = []

    // TODO: Checkout -> Content?
    init(content: Checkout, quantity: Int, selectedVariant: Variation?, apiClient: GraphQLClient) {
        self.content = content
        self.apiClient = apiClient
        self.quantity = quantity
        self.selectedVariant = selectedVariant
        self.supportedNetworks = []
        self.order = nil
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = "merchant.com.dispatch.secondary"
        paymentRequest.merchantCapabilities = [.debit, .credit]
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = content.product.currencyCode


        // TODO: Where should we get these from?
        paymentRequest.supportedNetworks = [.amex, .visa, .masterCard]
        paymentRequest.requiredBillingContactFields = [
            .postalAddress,
            .emailAddress,
            .phoneNumber,
            .name
        ]
        // TODO: Where should we get these from?
        paymentRequest.requiredShippingContactFields = [
            .postalAddress,
            .emailAddress,
            .phoneNumber,
            .name
        ]
        
        paymentRequest.shippingMethods = []
        paymentRequest.shippingType = content.product.requiresShipping ? .shipping : .delivery
        paymentRequest.paymentSummaryItems = [.init(label: "Total", amount: .zero)]

        self.paymentRequest = paymentRequest
        
        super.init()
        paymentRequest.paymentSummaryItems = self.paymentSummaryItemsGenerator()
    }
    
    private func initiateOrder() async throws -> InitiateOrder {
        let request =  InitiateOrderRequest(
            email: "apple@dispatch.co",
            productId: self.content.product.id,
            variantId: self.selectedVariant?.id,
            quantity: self.quantity
        )
        return try await apiClient.performOperation(request)
    }

    func paymentSummaryItemsGenerator() -> [PKPaymentSummaryItem] {
        var items: [PKPaymentSummaryItem] = []
        var total: NSDecimalNumber = 0
        
        let product = content.product
        let amount = NSDecimalNumber(
            string: CurrencyHelpers.formatCentsToDollars(
                cents: product.basePrice,
                currencyCode: content.product.currencyCode,
                forceDecimalSeparator: false,
                hideCurrencySymbol: true
            )
        )
        .multiplying(by: NSDecimalNumber(value: quantity))
        let item = PKPaymentSummaryItem(
            label: "\(product.name) (x\(quantity))" ,
            amount: amount,
            type: .final
        )
        items.append(item)
        total = total.adding(amount)
        
        if let selectedShippingMethod {
            let item = PKPaymentSummaryItem(
                label: selectedShippingMethod.label,
                amount: selectedShippingMethod.amount,
                type: .final
            )
            items.append(item)
            total = total.adding(selectedShippingMethod.amount)
        }
        
        if let taxCost = order?.taxCost {
            let item = PKPaymentSummaryItem(
                label: "Tax",
                amount: .init(
                    string: CurrencyHelpers.formatCentsToDollars(
                        cents: taxCost,
                        currencyCode: content.product.currencyCode,
                        forceDecimalSeparator: false,
                        hideCurrencySymbol: true
                    )
                ),
                type: .final
            )
            items.append(item)
            total = total.adding(item.amount)

        }
        
        let summaryItem = PKPaymentSummaryItem(label: "Total", amount: total, type: .final)
        items.append(summaryItem)
        
        return items
    }
    
    private func updateAvailableShippingMethods(_ shippingMethods: [ShippingMethod]) {
        self.paymentRequest.shippingMethods = shippingMethods.map {
            let method = PKShippingMethod(
                label: $0.title,
                amount: NSDecimalNumber(
                    string: CurrencyHelpers.formatCentsToDollars(
                        cents: $0.price,
                        currencyCode: self.content.product.currencyCode,
                        forceDecimalSeparator: false,
                        hideCurrencySymbol: true
                    )
                ),
                type: .final
            )
            
            method.identifier = $0.id
            return method
        }
    }
    
    // MARK: Model helpers
    
    private func firstName(for contact: PKContact) -> String {
        if let givenName = contact.name?.givenName, !givenName.isEmpty {
            return givenName
        } else {
            return "None"
        }
    }
    
    private func lastName(for contact: PKContact) -> String {
        if let familyName = contact.name?.familyName, !familyName.isEmpty {
            return familyName
        } else {
            return "None"
        }
    }
    
}

extension ApplePayViewModel: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(
        _ controller: PKPaymentAuthorizationViewController
    ) {
        controller.dismiss(animated: true)
    }
    
    func paymentAuthorizationViewControllerDidRequestMerchantSessionUpdate(
        controller: PKPaymentAuthorizationViewController
    ) async -> PKPaymentRequestMerchantSessionUpdate {
        print("[ApplePay] Merchant update requested")
        return .init(status: .success, merchantSession: .init())
    }
    
    
    func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didSelectShippingContact contact: PKContact
    ) async -> PKPaymentRequestShippingContactUpdate {
        self.selectedContact = contact
        do {
            
            if order == nil {
                print("[ApplePay] Initiating order (no current order found)")
                self.order = try await initiateOrder()
            }
            
            guard
                let order,
                let address = contact.postalAddress
            else {
                // TODO: Error handling
                print("[ApplePay] Error when updating shipping contact. Missing order or postal address: ", contact.postalAddress ?? "no-address")
                return .init()
            }

            let firstName = firstName(for: contact)
            let lastName = lastName(for: contact)
            let phoneNumber = contact.phoneNumber?.stringValue ?? "+11112223333"

            // set all the shipping information that we know
            // the fields hardcoded or set to "None" are things that we do not get until the onpaymentauthorized event
            // related complaint: https://forums.developer.apple.com/forums/thread/654899
            let request = UpdateOrderShippingRequest(
                params: .init(
                    orderId: order.id,
                    firstName: firstName,
                    lastName: lastName,
                    address1: address.street.isEmpty ? "None" : address.street,
                    address2: address.subLocality.isEmpty ? "" : address.subLocality,
                    city: address.city,
                    state: address.state,
                    zip: address.postalCode,
                    phoneNumber: phoneNumber,
                    country: address.isoCountryCode,
                    email: contact.emailAddress,
                    updateType: .shipping
                )
            )

            self.order = try await apiClient.performOperation(request)
            let shippingMethodsRequest = GetShippingMethodsForOrderRequest(orderId: order.id)
            let shippingMethodsResponse = try await apiClient.performOperation(shippingMethodsRequest)
            self.updateAvailableShippingMethods(shippingMethodsResponse.availableShippingMethods)
            return .init(
                errors: nil,
                paymentSummaryItems: paymentSummaryItemsGenerator(),
                shippingMethods: self.paymentRequest.shippingMethods ?? []
            )
        } catch {
            print("[ApplePay] Error when updating selected contact: ", error)
            return .init(
                errors: [error],
                paymentSummaryItems: paymentSummaryItemsGenerator(),
                shippingMethods: self.paymentRequest.shippingMethods ?? []
            )
        }
    }
    
    func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didSelect shippingMethod: PKShippingMethod
    ) async -> PKPaymentRequestShippingMethodUpdate {
        guard
            let orderId = self.order?.id,
            let shippingMethodId = shippingMethod.identifier
        else {
            print("[ApplePay] Error when updating shipping method. Missing order or shippingMethod identifier: ", shippingMethod.identifier ?? "no-identifier")
            return .init()
        }
        let request = UpdateOrderShippingMethodRequest(
            params: .init(
                orderId: orderId,
                shippingMethod: shippingMethodId
            )
        )
        
        do {
            let order = try await self.apiClient.performOperation(request)
            self.selectedShippingMethod = shippingMethod
            self.order = order

            print("[ApplePay] Order (\(order.id) updated shippingMethod: \(shippingMethodId)")
            return PKPaymentRequestShippingMethodUpdate(
                paymentSummaryItems: self.paymentSummaryItemsGenerator()
            )
        } catch {
            print("[ApplePay] Error when updating shipping method: ", error)
            return .init(paymentSummaryItems: paymentSummaryItemsGenerator())
        }
    }
    
    func paymentAuthorizationViewControllerWillAuthorizePayment(_ controller: PKPaymentAuthorizationViewController) {
        print("[ApplePay] Will authorize payment")
    }

    func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didAuthorizePayment payment: PKPayment
    ) async -> PKPaymentAuthorizationResult {
        guard 
            let order,
            let billing = payment.billingContact,
            let billingFirstName = billing.name?.givenName,
            let billingLastName = billing.name?.familyName,
            let billingAddress = billing.postalAddress
        else {
            // TODO: Add errors
            print("[ApplePay] Error when authorizing payment. Missing billing info or billing contact: ", payment.billingContact ?? "no-billing-contact")
            return .init(status: .failure, errors: [])
        }
        let shipping = payment.shippingContact
        do {
            if (!content.product.requiresShipping) {
                let request = UpdateOrderShippingRequest(
                    params: .init(
                        orderId: order.id,
                        firstName: billingFirstName,
                        lastName: billingLastName,
                        address1: billingAddress.street,
                        address2: billingAddress.subLocality,
                        city: billingAddress.city,
                        state: billingAddress.street,
                        zip: billingAddress.postalCode,
                        phoneNumber: billing.phoneNumber?.stringValue ?? "",
                        country: billingAddress.isoCountryCode,
                        email: billing.emailAddress,
                        updateType: .billing
                    )
                )
                
                self.order = try await apiClient.performOperation(request)
            } else if
                let shipping,
                let address = shipping.postalAddress,
                let shippingFirstName = shipping.name?.givenName,
                let shippingLastName = shipping.name?.familyName,
                let shippingPhone = shipping.phoneNumber?.stringValue
            {
                
                if
                    shipping.postalAddress?.street == billing.postalAddress?.street &&
                    shipping.postalAddress?.postalCode == billing.postalAddress?.postalCode
                {
                    let request = UpdateOrderShippingRequest(
                        params: .init(
                            orderId: order.id,
                            firstName: shippingFirstName,
                            lastName: shippingLastName,
                            address1: address.street,
                            address2: address.subLocality,
                            city: address.city,
                            state: address.street,
                            zip: address.postalCode,
                            phoneNumber: shippingPhone,
                            country: address.isoCountryCode,
                            email: shipping.emailAddress,
                            updateType: .shippingAndBilling
                        )
                    )
                    
                    self.order = try await apiClient.performOperation(request)
                } else {
                    let billingRequest = UpdateOrderShippingRequest(
                        params: .init(
                            orderId: order.id,
                            firstName: billingFirstName,
                            lastName: billingLastName,
                            address1: billingAddress.street,
                            address2: billingAddress.subLocality,
                            city: billingAddress.city,
                            state: billingAddress.street,
                            zip: billingAddress.postalCode,
                            phoneNumber: shippingPhone,
                            country: billingAddress.isoCountryCode,
                            email: shipping.emailAddress,
                            updateType: .shipping
                        )
                    )
                    
                    self.order = try await apiClient.performOperation(billingRequest)

                    let shippingRequest = UpdateOrderShippingRequest(
                        params: .init(
                            orderId: order.id,
                            firstName: shippingFirstName,
                            lastName: shippingLastName,
                            address1: address.street,
                            address2: address.subLocality,
                            city: address.city,
                            state: address.street,
                            zip: address.postalCode,
                            phoneNumber: shippingPhone,
                            country: address.isoCountryCode,
                            email: shipping.emailAddress,
                            updateType: .shipping
                        )
                    )
                    self.order = try await apiClient.performOperation(shippingRequest)
                }
            }
                        
            let paymentJson = try JSONDecoder().decode(PaymentJson.self, from: payment.token.paymentData)
            let tokenizeApplePayRequest = GetApplePayPaymentTokenRequest(
                input: .init(
                    data: paymentJson.data,
                    header: paymentJson.header.stringValue,
                    signature: paymentJson.signature,
                    version: paymentJson.version,
                    orderId: order.id,
                    accountId: nil // TODO: Do we get the stripe account id somewhere?
                )
            )

            
            let tokenizeApplePayResponse = try await apiClient.performOperation(tokenizeApplePayRequest)
            
            
            // TODO: How do we check if PSP is stripe?
//            let tokenizeRequest = CompleteOrderRequest(orderId: order.id, applePayEncryptedPaymentData: paymentData)
            let tokenizeRequest = CompleteOrderRequest(
                orderId: order.id,
                tokenizedPayment: tokenizeApplePayResponse.paymentToken
            )
            
            let response = try await apiClient.performOperation(tokenizeRequest)
            self.order = response

            return PKPaymentAuthorizationResult(status: .success, errors: nil)
        } catch {
            print("[ApplePay] Error when authorizing payment: ", error)
            return PKPaymentAuthorizationResult(status: .failure, errors: [error])
        }
    }
    
}
