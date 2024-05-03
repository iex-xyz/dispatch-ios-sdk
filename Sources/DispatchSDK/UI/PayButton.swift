import SwiftUI

struct PayButton: View {
    @Preference(\.theme) var theme
    let ctaText: String
    let paymentMethod: PaymentMethods
    @State var isDisabled: Bool
    let onButtonTapped: () -> Void

    var body: some View {
        Button(action: {
            onButtonTapped()
        }) {
            HStack(spacing: 4) {
                Text(ctaText)
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
            ForEach(["Pay with", "Continue with", "Donate with"], id: \.self) { cta in
                    VStack {
                        PayButton(ctaText: cta, paymentMethod: .applePay, isDisabled: true) {}
                        PayButton(ctaText: cta, paymentMethod: .googlePay, isDisabled: false) {}
                        PayButton(ctaText: cta, paymentMethod: .creditCard, isDisabled: true) {}
                        PayButton(ctaText: cta, paymentMethod: .stripeLink, isDisabled: false) {}
                    }
                    
                    VStack {
                        PayButton(ctaText: cta, paymentMethod: .applePay, isDisabled: true) {}
                        PayButton(ctaText: cta, paymentMethod: .googlePay, isDisabled: true) {}
                        PayButton(ctaText: cta, paymentMethod: .creditCard, isDisabled: false) {}
                        PayButton(ctaText: cta, paymentMethod: .stripeLink, isDisabled: false) {}
                    }
                    .environment(\.theme, .mock(mode: .dark))
            }
        }
        .padding(.horizontal)
    }
    .background(Color.dispatchDarkGray)
}
