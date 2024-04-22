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
                Icons.close
            }
            .padding(.horizontal)
            .padding(.bottom)
            CheckoutProductPreviewRow(product: viewModel.checkout.product)
                .padding(.horizontal)
            Divider()
            ScrollView {
                VStack {
                    if let variant = viewModel.variant {
                        CheckoutOverviewDetailRow(title: "Variant") {
                            Text("Variant detail will end up going here")
                                .multilineTextAlignment(.trailing)
                                .lineLimit(3)
                                .foregroundStyle(.primary)
                        } handler: {
                            viewModel.onVariantButtonTapped()
                        }
                        Divider()
                    }
                    CheckoutOverviewDetailRow(title: "Email") {
                        Text(viewModel.email)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                            .foregroundStyle(.primary)
                    } handler: {
                        viewModel.onEmailButtonTapped()
                    }
                    Divider()
                    CheckoutOverviewDetailRow(title: "Phone") {
                        Text(viewModel.phone)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            .foregroundStyle(.primary)
                    } handler: {
                        viewModel.onPhoneButtonTapped()
                    }
                    Divider()
                    CheckoutOverviewDetailRow(title: "Ship to") {
                        Text(viewModel.shippingAddress.debugDescription)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(3)
                            .minimumScaleFactor(0.8)
                            .foregroundStyle(.primary)
                    } handler: {
                        viewModel.onShippingAddressButtonTapped()
                    }
                    Divider()
                    CheckoutOverviewDetailRow(title: "Payment") {
                        Text("TODO")
                            .multilineTextAlignment(.trailing)
                            .lineLimit(3)
                            .minimumScaleFactor(0.8)
                            .foregroundStyle(.primary)
                    } handler: {
                        viewModel.onPaymentDetailsButtonTapped()
                    }
                    Divider()
                    CheckoutOverviewDetailRow(title: "Delivery") {
                        Text(viewModel.shippingMethod.handle)
                            .multilineTextAlignment(.trailing)
                            .lineLimit(3)
                            .minimumScaleFactor(0.8)
                            .foregroundStyle(.primary)
                    } handler: {
                        viewModel.onShippingMethodButtonTapped()
                    }
                    Divider()
                }
            }
            VStack(spacing: 16) {
                PayButton(ctaText: "Pay with", paymentType: .creditCard) {
                    viewModel.onPayButtonTapped()
                }
                Button(action: {
                    viewModel.onMorePaymentOptionsButtonTapped()
                }) {
                    Text("More payment options ") + Text(Image(systemName: "arrow.right"))
                }
                .font(.subheadline.bold())
            }
            .padding()
        }
        .background(theme.backgroundColor)
        .colorScheme(theme.colorScheme)
    }
}

#Preview {
    let viewModel: CheckoutOverviewViewModel = .init(
        checkout: .mock(),
        orderId: UUID().uuidString,
        email: "test@test.com",
        variant: .random(),
        phone: "8882223344",
        shippingAddress: [:],
        billingAddress: [:],
        shippingMethod: .random(),
        subtotal: "$123.99",
        tax: "$4.99",
        delivery: "$9.99"
    )
    return CheckoutOverviewView(viewModel: viewModel)
}
