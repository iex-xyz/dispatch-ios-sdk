import SwiftUI

struct PayButton: View {
    @Preference(\.theme) var theme
    let productType: ProductType
    let paymentMethod: PaymentMethods
    @State var isDisabled: Bool
    let onButtonTapped: () -> Void

    var body: some View {
        Button(action: {
            onButtonTapped()
        }) {
            HStack(spacing: 4) {
                Text(productType.renderedCTAString)
                    .lineLimit(1)
                switch (paymentMethod, theme.mode) {
                case (.applePay, .light):
                    Icons.Payment.applePayLight
                case (.applePay, .dark):
                    Icons.Payment.applePayLight
                case (.creditCard, .light):
                    Icons.Payment.cardDark
                case (.creditCard, .dark):
                    Icons.Payment.cardDark
                case (.googlePay, .light):
                    Icons.Payment.googlePayLight
                case (.googlePay, .dark):
                    Icons.Payment.googlePayDark
                case (.stripeLink, .light):
                    Icons.Payment.cardDark
                case (.stripeLink, .dark):
                    Icons.Payment.cardDark
                }
            }
            .opacity(isDisabled ? 0.24 : 1)
        }
        .disabled(isDisabled)
        .buttonStyle(
            PrimaryButtonStyle()
        )
        
    }
}

#Preview {
    ScrollView {
        VStack {
            ForEach([ProductType.donation, ProductType.product], id: \.self) { productType in
                    VStack {
                        PayButton(productType: productType, paymentMethod: .applePay, isDisabled: true) {}
                        PayButton(productType: productType, paymentMethod: .googlePay, isDisabled: false) {}
                        PayButton(productType: productType, paymentMethod: .creditCard, isDisabled: true) {}
                        PayButton(productType: productType, paymentMethod: .stripeLink, isDisabled: false) {}
                    }
                    
                    VStack {
                        PayButton(productType: productType, paymentMethod: .applePay, isDisabled: true) {}
                        PayButton(productType: productType, paymentMethod: .googlePay, isDisabled: true) {}
                        PayButton(productType: productType, paymentMethod: .creditCard, isDisabled: false) {}
                        PayButton(productType: productType, paymentMethod: .stripeLink, isDisabled: false) {}
                    }
                    .environment(\.theme, .mock(mode: .dark))
            }
        }
        .padding(.horizontal)
    }
    .background(Color.dispatchDarkGray)
}
