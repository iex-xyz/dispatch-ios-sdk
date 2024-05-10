import SwiftUI

struct CheckoutOverviewView: View {
    @Preference(\.theme) var theme
    @ObservedObject var viewModel: CheckoutOverviewViewModel
    
    init(viewModel: CheckoutOverviewViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            HStack {
                Text("Checkout")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom)
            CheckoutProductPreviewRow(product: viewModel.checkout.product)
                .padding(.horizontal)
            Divider()
            ScrollView {
                VStack {
                    if
                        let variant = viewModel.variant,
                        let attributes = viewModel.checkout.product.attributes?.values
                    {
                        ForEach(Array(attributes), id: \.id) { attribute in
                            if let renderedValue = variant.attributes?[attribute.id] {
                                CheckoutOverviewDetailRow(title: attribute.title, showChevron: false) {
                                    Text(renderedValue)
                                        .multilineTextAlignment(.trailing)
                                        .lineLimit(3)
                                        .foregroundStyle(.primary)
                                } handler: {
                                    viewModel.onVariantButtonTapped()
                                }
                                Divider()
                            }
                        }
                    }
                    CheckoutOverviewDetailRow(title: "Email", showChevron: false) {
                        Text(viewModel.email)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                            .foregroundStyle(.primary)
                    } handler: {
                        viewModel.onEmailButtonTapped()
                    }
                    Divider()
                    CheckoutOverviewDetailRow(title: "Phone", showChevron: false) {
                        Text(viewModel.phone)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .foregroundStyle(.primary)
                    } handler: {
                        viewModel.onPhoneButtonTapped()
                    }
                    Divider()
                    CheckoutOverviewDetailRow(title: "Ship to", showChevron: false) {
                        Text(viewModel.shippingAddress.formattedString)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(3)
                            .minimumScaleFactor(0.8)
                            .foregroundStyle(.primary)
                    } handler: {
                        viewModel.onShippingAddressButtonTapped()
                    }
                    Divider()
                    CheckoutOverviewDetailRow(title: "Payment", showChevron: false) {
                        HStack {
                            Text(viewModel.billingInfo.cardPreview)
                            if let icon = viewModel.billingInfo.cardType.iconImage {
                                Image(uiImage: icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 16)
                            }
                        }
                            .foregroundStyle(.primary)
                    } handler: {
                        viewModel.onPaymentDetailsButtonTapped()
                    }
                    Divider()
                    CheckoutOverviewDetailRow(title: "Delivery", showChevron: false) {
                        Text(viewModel.shippingMethod.title)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(3)
                            .minimumScaleFactor(0.8)
                            .foregroundStyle(.primary)
                    } handler: {
                        viewModel.onShippingMethodButtonTapped()
                    }
                    Divider()
                    CheckoutOverviewDetailRow(title: "Subtotal", showChevron: false) {
                        Text(
                            CurrencyHelpers.formatCentsToDollars(
                                cents: viewModel.order.productCost,
                                currencyCode: viewModel.checkout.product.currencyCode
                            )
                        )
                            .multilineTextAlignment(.trailing)
                            .lineLimit(3)
                            .minimumScaleFactor(0.8)
                            .foregroundStyle(.primary)
                    } handler: {
                        viewModel.onShippingMethodButtonTapped()
                    }
                    Divider()
                    CheckoutOverviewDetailRow(title: "Tax", showChevron: false) {
                        Text(
                            CurrencyHelpers.formatCentsToDollars(
                                cents: viewModel.order.taxCost,
                                currencyCode: viewModel.checkout.product.currencyCode
                            )
                        )
                            .multilineTextAlignment(.trailing)
                            .lineLimit(3)
                            .minimumScaleFactor(0.8)
                            .foregroundStyle(.primary)
                    } handler: {
                        viewModel.onShippingMethodButtonTapped()
                    }
                    Divider()
                    CheckoutOverviewDetailRow(title: "Total", showChevron: false) {
                        Text(
                            CurrencyHelpers.formatCentsToDollars(
                                cents: viewModel.order.totalCost,
                                currencyCode: viewModel.checkout.product.currencyCode
                            )
                        )
                            .multilineTextAlignment(.trailing)
                            .lineLimit(3)
                            .minimumScaleFactor(0.8)
                            .foregroundStyle(.primary)
                    } handler: {
                        viewModel.onShippingMethodButtonTapped()
                    }
                    Divider()
                    Button(action: {
                        viewModel.onTermsButtonTapped()
                    }) {
                        Text("By continuing, I agree to the ") + Text("Terms of Sale").underline()
                    }
                    .font(.caption2)
                    .foregroundStyle(.primary)
                    .padding()
                }
            }
            VStack(spacing: 16) {
                PayButton(
                    productType: viewModel.checkout.product.type,
                    paymentMethod: .creditCard,
                    isDisabled: !viewModel.state.isEnabled,
                    isLoading: viewModel.state.isLoading
                ) {
                    viewModel.onPayButtonTapped()
                }
                if viewModel.paymentMethods.count > 1 {
                    Button(action: {
                        viewModel.onMorePaymentOptionsButtonTapped()
                    }) {
                        Text("More payment options ") + Text(Image(systemName: "arrow.right"))
                    }
                    .font(.subheadline.bold())
                }
            }
            .padding()
        }
        .background(theme.backgroundColor)
        .colorScheme(theme.colorScheme)
    }
}

#Preview {
    let viewModel: CheckoutOverviewViewModel = .init(
        apiClient: .init(networkService: PreviewNetworkService(), environment: .staging),
        analyticsClient: MockAnalyticsClient(),
        checkout: .mock(),
        order: .mock(),
        email: "test@test.com",
        variant: .random(),
        phone: "8882223344",
        shippingAddress: Address.mock(),
        billingAddress: Address.mock(),
        billingInfo: BillingInfo.mock(),
        shippingMethod: .random(),
        paymentMethods: [.applePay, .creditCard],
        tokenizedPayment: UUID().uuidString
    )
    return CheckoutOverviewView(viewModel: viewModel)
}
